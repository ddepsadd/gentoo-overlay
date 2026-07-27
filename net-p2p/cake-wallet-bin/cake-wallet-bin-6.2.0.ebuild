# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="Cake Wallet — non-custodial multi-currency wallet (prebuilt Linux bundle)"
HOMEPAGE="https://cakewallet.com"
SRC_URI="https://github.com/cake-tech/cake_wallet/releases/download/v${PV}/Cake_Wallet_v${PV}_Linux.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

# Published upstream SHA256 — verify by eye against the GitHub release on every bump.
CW_SHA256="aff7000b9bcaf2a7e7636ec7bcf4667f16d6b1f5b3a256b9fb255a841499ca84"

RESTRICT="strip mirror bindist"
QA_PREBUILT="opt/cake-wallet/*"

RDEPEND="
	dev-libs/glib
	x11-libs/gtk+:3
	app-crypt/libsecret
	x11-libs/libX11
	media-libs/mesa
	sys-libs/zlib
"

# NOTE: verify the tarball's root dir name after the first unpack:
#   tar tf Cake_Wallet_v6.2.0_Linux.tar.xz | head
# and adjust S accordingly.
S="${WORKDIR}/Cake_Wallet_v6.2.0_Linux"

src_unpack() {
	local got
	got=$(sha256sum "${DISTDIR}/${A}" | awk '{print $1}')
	[[ ${got} == ${CW_SHA256} ]] \
		|| die "SHA256 mismatch! upstream=${CW_SHA256} got=${got}"
	default
}

src_install() {
	# Drop the whole Flutter bundle into /opt, preserving perms/symlinks.
	dodir /opt/cake-wallet
	cp -a "${S}"/. "${ED}/opt/cake-wallet/" || die "install of bundle failed"

	# NOTE: confirm the executable name inside the bundle; adjust if not cake_wallet.
	fperms +x /opt/cake-wallet/cake_wallet

	# Launcher shim.
	dodir /usr/bin
	cat > "${T}/cake-wallet" <<-EOF
		#!/bin/sh
		exec /opt/cake-wallet/cake_wallet "\$@"
	EOF
	dobin "${T}/cake-wallet"

	# Desktop entry.
	# NOTE: fix the icon path to a real PNG inside the bundle if this one is wrong.
	make_desktop_entry cake-wallet "Cake Wallet" \
		"/opt/cake-wallet/data/flutter_assets/assets/images/app_logo.png" \
		"Network;Finance;"
}
