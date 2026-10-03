# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line tool to customize the official Spotify client (prebuilt)"
HOMEPAGE="https://spicetify.app https://github.com/spicetify/cli"
SRC_URI="https://github.com/spicetify/cli/releases/download/v${PV}/spicetify-${PV}-linux-amd64.tar.gz"
S="${WORKDIR}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror strip"

# Upper bound follows "Spotify for Linux" in the Compatibility section
# of the upstream release notes. Re-check it on every bump.
RDEPEND="
	>=media-sound/spotify-1.2.14
	<media-sound/spotify-1.2.97
"

QA_PREBUILT="opt/${PN}/spicetify"

src_install() {
	# spicetify resolves its real path and expects CustomApps/, Extensions/,
	# Themes/, jsHelper/ and css-map.json next to the binary
	insinto /opt/${PN}
	doins -r CustomApps Extensions Themes jsHelper css-map.json globals.d.ts
	exeinto /opt/${PN}
	doexe spicetify
	dosym -r /opt/${PN}/spicetify /usr/bin/spicetify
}

pkg_postinst() {
	elog "spicetify patches /opt/spotify/spotify-client and its Apps/ directory,"
	elog "so your user needs write access there. Prefer a dedicated group over"
	elog "the world-writable chmod suggested by the upstream docs."
	elog
	elog "Run as your user with Spotify closed:"
	elog "  spicetify backup apply           first time and after every Spotify update"
	elog "  spicetify restore backup apply   if it reports a backup version mismatch"
}
