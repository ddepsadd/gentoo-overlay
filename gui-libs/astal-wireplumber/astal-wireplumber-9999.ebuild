# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VALA_USE_DEPEND="vapigen"

inherit meson vala git-r3

DESCRIPTION="Astal Wireplumber library — PipeWire/audio bindings for Astal"
HOMEPAGE="https://github.com/aylur/astal"
EGIT_REPO_URI="https://github.com/aylur/astal.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/astal-${PV}"

# NOTE: lives in lib/wireplumber, NOT lib/astal/wireplumber
S="${EGIT_CHECKOUT_DIR}/lib/wireplumber"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""

RDEPEND="
	~gui-libs/astal-io-${PV}
	>=dev-libs/glib-2.76:2
	media-video/wireplumber
	dev-libs/gobject-introspection
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-build/meson
	virtual/pkgconfig
"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	vala_setup
	# astal gir.py runs valadoc with check=True; valadoc can exit
	# non-zero on benign warnings (Unknown parameter, etc.) even
	# though the .gir is produced. Make the check non-fatal.
	find "${WORKDIR}" -name gir.py -exec sed -i "s/check=True,/check=False,/" {} + || die
	default
}

src_compile() {
	# astal's gir.py hardcodes the 'valadoc' executable name, ignoring $VALADOC.
	# Gentoo only ships slotted valadoc-0.56, so provide a shim on PATH.
	local shimdir="${T}/valadoc-shim"
	mkdir -p "${shimdir}" || die
	ln -sf "$(type -P valadoc-0.56)" "${shimdir}/valadoc" || die
	PATH="${shimdir}:${PATH}" meson_src_compile
}
