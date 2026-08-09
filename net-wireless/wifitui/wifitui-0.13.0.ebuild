# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Fast featureful friendly wifi terminal UI (nmtui replacement)"
HOMEPAGE="https://github.com/shazow/wifitui"
SRC_URI="https://github.com/shazow/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# Generate this yourself (see below), then host it or drop it in DISTDIR:
SRC_URI+=" https://github.com/ddepsadd/gentoo-overlay/releases/download/${PN}-${PV}/${P}-deps.tar.xz"

# MIT: wifitui + большинство deps. BSD-3: atotto/clipboard, google/uuid,
# jessevdk/go-flags, golang.org/x/sys. BSD-2: godbus/dbus.
# Проверено lichen на 0.13.0 (28 модулей в бинаре).
LICENSE="BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

# Runtime: needs a backend daemon. NetworkManager for your setup; iwd also supported.
RDEPEND="
	|| (
		net-misc/networkmanager
		net-wireless/iwd
	)
"

src_compile() {
	# CGO not needed (pure-Go dbus); matches upstream goreleaser build.
	CGO_ENABLED=0 ego build -ldflags "-s -w -X main.Version=v${PV}" -o ${PN} .
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
