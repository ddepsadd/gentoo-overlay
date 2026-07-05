# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="TUI for searching, browsing and downloading YouTube videos (Go, Bubble Tea)"
HOMEPAGE="https://github.com/xdagiz/xytz"

# --- deps tarball -----------------------------------------------------
# go.mod requires go 1.26, and upstream does not commit a vendor/ dir, so
# go-module.eclass needs a pre-fetched module cache tarball. This can't be
# generated offline -- do it on a real machine with normal internet access:
#
#   git clone https://github.com/xdagiz/xytz.git
#   cd xytz && git checkout v${PV}
#   GOMODCACHE="${PWD}/go-mod" go mod download -modcacherw
#   XZ_OPT='-T0 -9' tar -acf ${PN}-${PV}-deps.tar.xz go-mod
#
# Then either:
#   (a) drop the resulting tarball straight into your DISTDIR
#       (e.g. /var/cache/distfiles/) -- `ebuild ... manifest` will hash the
#       local copy instead of trying to fetch it, no hosting needed, or
#   (b) upload it as a release asset on your own overlay repo and point
#       the URL below at it properly.
inherit go-module

SRC_URI="
	https://github.com/xdagiz/xytz/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/ddepsadd/gentoo-overlay/releases/download/${PN}-${PV}-deps/${PN}-${PV}-deps.tar.xz
"
S="${WORKDIR}/${PN}-${PV}"

src_prepare() {
	default
	# Upstream passes a nonexistent yt-dlp flag (--ffmpeg-path), which makes
	# every download fail immediately with "no such option" (argparse exit 2)
	# whenever ffmpeg sits next to the xytz binary (i.e. always, on a normal
	# distro install where both land in /usr/bin). The correct yt-dlp flag
	# is --ffmpeg-location. Reported upstream: TODO file an issue/PR.
	sed -i 's/--ffmpeg-path/--ffmpeg-location/' \
		internal/utils/download.go || die
}


# MIT covers xytz itself; the Bubble Tea/Charm ecosystem deps are also
# MIT/BSD-3 as of upstream's go.mod, but double check with dev-go/golicense
# against the built binary before relying on this for anything upstream-facing.
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# yt-dlp does the actual downloading, ffmpeg is needed for muxing/format
# conversion, mpv is only used for the optional /play-without-downloading
# command -- none of these are linked, xytz just execs them, so this is a
# soft runtime expectation rather than something the build breaks without.
RDEPEND="
	net-misc/yt-dlp
	media-video/ffmpeg
"

src_compile() {
	local ldflags=(
		-s -w
		-X github.com/xdagiz/xytz/internal/version.Version=${PV}
	)
	ego build -ldflags "${ldflags[*]}" -o "${PN}" .
}

src_install() {
	dobin "${PN}"
	einstalldocs
}

pkg_postinst() {
	elog "xytz just shells out to yt-dlp/ffmpeg for the real work."
	elog "Install media-video/mpv as well if you want /play <url> to work"
	elog "(inline playback without downloading first)."
}
