# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Python DB API 2.0 module for ODBC"
HOMEPAGE="
	https://github.com/mkleehammer/pyodbc/
	https://pypi.org/project/pyodbc/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT-0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-db/unixODBC"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# C extension linked against unixODBC (odbc_config/pkg-config). No Python
# runtime deps beyond the extension itself. If you need MSSQL specifically
# over ODBC, you also need a driver installed separately (dev-db/freetds
# for TDS, or a proprietary MS ODBC Driver 18 outside Portage) -- this
# ebuild only provides the driver manager binding, not a driver.
