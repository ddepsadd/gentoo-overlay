# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Cake Wallet — non-custodial multi-currency wallet (prebuilt Linux bundle)"
HOMEPAGE="https://cakewallet.com"
SRC_URI="https://github.com/cake-tech/cake_wallet/releases/download/v${PV}/Cake_Wallet_v${PV}_Linux.tar.xz"
S="${WORKDIR}/Cake_Wallet_v${PV}_Linux"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

# SHA256 of the release asset as published by GitHub (asset digest) —
# re-check on every bump: github.com/cake-tech/cake_wallet/releases
CW_SHA256="c24310b8f0a111580e59f38b48cfd40f66c6e4353d7629bee38b049e56b91025"

RESTRICT="strip mirror bindist"
QA_PREBUILT="opt/cake-wallet/*"

RDEPEND="
	app-arch/bzip2
	app-crypt/libsecret
	dev-libs/glib:2
	media-libs/mesa
	virtual/zlib
	x11-libs/gtk+:3
	x11-libs/libX11
"

src_unpack() {
	local got
	got=$(sha256sum "${DISTDIR}/${A}" | awk '{print $1}')
	[[ ${got} == ${CW_SHA256} ]] \
		|| die "SHA256 mismatch! upstream=${CW_SHA256} got=${got}"
	default
}

src_install() {
	# Whole Flutter bundle into /opt, preserving perms/symlinks.
	dodir /opt/cake-wallet
	cp -a "${S}"/. "${ED}/opt/cake-wallet/" || die "install of bundle failed"
	fperms 0755 /opt/cake-wallet/cake_wallet

	cat > "${T}/cake-wallet" <<-EOF || die
		#!/bin/sh
		exec /opt/cake-wallet/cake_wallet "\$@"
	EOF
	dobin "${T}/cake-wallet"

	make_desktop_entry cake-wallet "Cake Wallet" \
		"/opt/cake-wallet/data/flutter_assets/assets/images/app_logo.png" \
		"Network;Finance;"
}
