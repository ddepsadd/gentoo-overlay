# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
VALA_USE_DEPEND="vapigen"
inherit meson vala git-r3 xdg
DESCRIPTION="Astal notification daemon library — D-Bus notification server for desktop shells"
HOMEPAGE="https://github.com/aylur/astal"
EGIT_REPO_URI="https://github.com/aylur/astal.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/astal-${PV}"
S="${EGIT_CHECKOUT_DIR}/lib/notifd"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""
RDEPEND="
	>=dev-libs/glib-2.76:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	x11-libs/gdk-pixbuf:2
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
	# non-zero on benign warnings even though the .gir is produced.
	find "${WORKDIR}" -name gir.py -exec sed -i "s/check=True,/check=False,/" {} + || die
	default
}
src_configure() {
	# -Dcli pulls in quarrel-0.1 (unpackaged); we only need the library.
	local emesonargs=(
		-Dcli=false
	)
	meson_src_configure
}
src_compile() {
	# astal's gir.py hardcodes 'valadoc'; Gentoo ships slotted valadoc-0.56.
	local shimdir="${T}/valadoc-shim"
	mkdir -p "${shimdir}" || die
	ln -sf "$(type -P valadoc-0.56)" "${shimdir}/valadoc" || die
	PATH="${shimdir}:${PATH}" meson_src_compile
}
