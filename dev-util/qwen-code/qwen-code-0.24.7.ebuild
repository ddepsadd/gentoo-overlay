# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Open-source AI agent for the terminal, optimized for Qwen models"
HOMEPAGE="https://github.com/QwenLM/qwen-code"
SRC_URI="https://registry.npmjs.org/@qwen-code/${PN}/-/${P}.tgz"
S="${WORKDIR}/package"

LICENSE="Apache-2.0 || ( MIT Unlicense )"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="strip"

RDEPEND=">=net-libs/nodejs-22"

QA_PREBUILT="usr/lib/${PN}/vendor/*"

src_prepare() {
	default
	rm -r vendor/ripgrep/{arm64-darwin,arm64-linux,x64-darwin,x64-win32} vendor/landlock-run/arm64-linux || die
}

src_install() {
	local dest=/usr/lib/${PN}
	insinto "${dest}"
	doins -r .
	fperms +x "${dest}"/cli-entry.js
	fperms +x "${dest}"/vendor/ripgrep/x64-linux/rg
	fperms +x "${dest}"/vendor/landlock-run/x64-linux/qwen-landlock-run

	# portage owns the package: pin the bundled version, point the self-updater nowhere
	newbin - qwen <<-EOF
	#!/bin/sh
	QWEN_CODE_MANAGED_NPM_PIN='{"bootstrap":"${EPREFIX}${dest}/cli-entry.js","version":null,"updateRoot":"/nonexistent"}'
	export QWEN_CODE_MANAGED_NPM_PIN
	exec node --no-deprecation "${EPREFIX}${dest}/cli-entry.js" "\$@"
	EOF
}
