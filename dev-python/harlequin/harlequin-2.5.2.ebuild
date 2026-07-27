# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="The SQL IDE for your terminal (DuckDB/SQLite built-in, adapters for everything else)"
HOMEPAGE="
	https://harlequin.sh/
	https://github.com/tconbeer/harlequin/
	https://pypi.org/project/harlequin/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="s3"

RDEPEND="
	~dev-python/textual-6.4.0[${PYTHON_USEDEP}]
	~dev-python/textual-fastdatatable-0.14.0[${PYTHON_USEDEP}]
	~dev-python/textual-textarea-0.17.2[${PYTHON_USEDEP}]
	>=dev-python/click-8.1[${PYTHON_USEDEP}]
	>=dev-python/rich-click-1.8[${PYTHON_USEDEP}]
	>=dev-python/shandy-sqlfmt-0.28.2[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.10[${PYTHON_USEDEP}]
	
	>=dev-python/tomlkit-0.12.5[${PYTHON_USEDEP}]
	
	>=dev-python/questionary-2[${PYTHON_USEDEP}]
	python_targets_python3_14? (
		>=dev-python/duckdb-1.4.2[${PYTHON_USEDEP}]
		>=dev-python/pandas-2.3[${PYTHON_USEDEP}]
	)
	!python_targets_python3_14? (
		>=dev-python/duckdb-0.8.0[${PYTHON_USEDEP}]
	)
	s3? ( >=dev-python/boto3-1.34[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
