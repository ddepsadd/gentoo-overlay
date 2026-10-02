# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="PINCE is not Cheat Engine: GDB front-end / RE tool (AppImage)"
HOMEPAGE="https://github.com/korcankaraokcu/PINCE"
SRC_URI="https://github.com/korcankaraokcu/PINCE/releases/download/v${PV}/PINCE-x86_64.AppImage -> ${P}.AppImage"
S="${WORKDIR}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="strip mirror bindist test"

RDEPEND="
	dev-debug/gdb[python]
	sys-auth/polkit
"

QA_PREBUILT="opt/${PN}/*"

src_unpack() {
	# извлекаем только иконку/desktop для интеграции, сам AppImage ставим целиком
	cp "${DISTDIR}/${P}.AppImage" "${WORKDIR}/PINCE.AppImage" || die
	chmod +x "${WORKDIR}/PINCE.AppImage" || die
	cd "${WORKDIR}" || die
	./PINCE.AppImage --appimage-extract >/dev/null || die
}

src_install() {
	exeinto /opt/${PN}
	doexe "${WORKDIR}/PINCE.AppImage"

	{
		echo '#!/bin/sh'
		echo 'export QT_QPA_PLATFORM=wayland'
		echo 'exec /opt/'"${PN}"'/PINCE.AppImage --appimage-extract-and-run "$@"'
	} > "${T}/pince" || die
	dobin "${T}/pince"

	local icon
	for icon in "${WORKDIR}"/squashfs-root/usr/share/icons/hicolor/*/apps/PINCE.png; do
		[[ -f ${icon} ]] || continue
		local size=${icon%/apps/*}
		size=${size##*/}
		newicon -s "${size%x*}" "${icon}" pince.png
	done

	make_desktop_entry pince PINCE pince "Development;Debugger;"
}
