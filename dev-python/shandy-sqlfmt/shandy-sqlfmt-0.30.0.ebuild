# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_PN="${PN//-/_}"

DESCRIPTION="SQL formatter (like black/gofmt, but for SQL) -- Harlequin dependency"
HOMEPAGE="
	https://github.com/tconbeer/sqlfmt/
	https://pypi.org/project/shandy-sqlfmt/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="jinjafmt"

RDEPEND="
	>=dev-python/click-8.1[${PYTHON_USEDEP}]

	>=dev-python/tqdm-4.67[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-2.4[${PYTHON_USEDEP}]
	>=dev-python/jinja2-3[${PYTHON_USEDEP}]
	jinjafmt? ( >=dev-python/black-24[${PYTHON_USEDEP}] )
"
