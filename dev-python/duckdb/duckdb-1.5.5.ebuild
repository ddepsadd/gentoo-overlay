# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Python client library for DuckDB (builds the full DuckDB engine from source)"
HOMEPAGE="
	https://duckdb.org/
	https://github.com/duckdb/duckdb-python/
	https://pypi.org/project/duckdb/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pandas"

BDEPEND="
	dev-build/cmake
	dev-build/ninja
"
RDEPEND="
	pandas? ( >=dev-python/pandas-2.3[${PYTHON_USEDEP}] )
"

# Build compiles the entire DuckDB C++ engine (not a thin binding) --
# this is slow and RAM-hungry, expect it to take a real while even on
# a 16-core box. DISTUTILS_USE_PEP517=standalone bypasses the eclass's
# backend-name check since it doesn't have a named profile for
# scikit-build-core specifically; the generic PEP517 build-wheel/install
# flow is still used underneath, per Gentoo Python Guide.
