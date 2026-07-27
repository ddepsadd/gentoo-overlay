# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_PN="${PN//-/_}"

DESCRIPTION="Self-contained Python driver for MySQL servers (PEP 249 DB API 2.0)"
HOMEPAGE="
	https://dev.mysql.com/downloads/connector/python/
	https://pypi.org/project/mysql-connector-python/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

# Oracle's own GPL-2 + FOSS linking exception; Gentoo's now-removed
# 8.0.26 ebuild just tagged this plain GPL-2, matching that precedent.
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mysqlx"

# Pure-Python classic MySQL protocol (mysql.connector.connect(), what
# harlequin-mysql actually uses) needs nothing beyond stdlib. protobuf is
# only for the X DevAPI / mysqlx document-store client, irrelevant to
# harlequin -- gate it behind USE so you're not pulling protobuf for no
# reason. Not independently verified against setup.py/pyproject.toml,
# double check if emerge or runtime complains about a missing import.
RDEPEND="
	mysqlx? ( dev-python/protobuf-python[${PYTHON_USEDEP}] )
"
