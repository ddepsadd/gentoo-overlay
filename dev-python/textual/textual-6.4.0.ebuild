# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Modern Text User Interface framework (pinned to the version Harlequin 2.5.2 actually targets)"
HOMEPAGE="
	https://textual.textualize.io/
	https://github.com/Textualize/textual/
	https://pypi.org/project/textual/
"
SRC_URI="https://files.pythonhosted.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/rich-14.2.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-it-py-2.1.0[${PYTHON_USEDEP}]
	dev-python/linkify-it-py[${PYTHON_USEDEP}]
	dev-python/mdit-py-plugins[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.4.0[${PYTHON_USEDEP}]
	>=dev-python/platformdirs-3.6.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.19.2[${PYTHON_USEDEP}]
"
