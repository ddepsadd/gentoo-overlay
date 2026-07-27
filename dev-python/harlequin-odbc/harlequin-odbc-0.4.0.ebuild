# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_PN="${PN//-/_}"

DESCRIPTION="ODBC adapter for Harlequin (MS SQL Server, Oracle, and anything else with an ODBC driver)"
HOMEPAGE="
	https://github.com/tconbeer/harlequin-odbc/
	https://pypi.org/project/harlequin-odbc/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/harlequin[${PYTHON_USEDEP}]
	dev-python/pyodbc[${PYTHON_USEDEP}]
	dev-db/unixODBC
"
