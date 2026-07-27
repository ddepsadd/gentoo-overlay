# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

MY_PN="${PN//-/_}"

DESCRIPTION="Syntax-highlighted, autocompleting multi-line text area for Textual"
HOMEPAGE="
	https://github.com/tconbeer/textual-textarea/
	https://pypi.org/project/textual-textarea/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/textual[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/pyperclip-1.9.0[${PYTHON_USEDEP}]
"
