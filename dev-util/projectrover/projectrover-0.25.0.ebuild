# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION=".NET decompiler with Avalonia UI (ILSpy-based, cross-platform)"
HOMEPAGE="https://github.com/lextudio/ProjectRover"
SRC_URI="https://github.com/lextudio/ProjectRover/releases/download/v${PV}/ProjectRover-linux-x64.zip"
S="${WORKDIR}/${P}"

LICENSE="AGPL-3 MIT"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip test"

BDEPEND="app-arch/unzip"

# .NET 10 runtime требуется в рантайме, но в portage его сейчас нет
# (есть только dev-dotnet/dotnet-sdk-bin:10.0). Предполагается ручная
# установка через dotnet-install.sh в ~/.dotnet — wrapper подцепит её.
RDEPEND="
	dev-libs/icu
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libX11
	|| ( media-fonts/dejavu media-fonts/noto )
"

QA_PREBUILT="opt/${PN}/*"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}" || die
	cd "${S}" || die
	unpack "${WORKDIR}/ProjectRover-linux-x64.tar.gz"
}

src_install() {
	insinto /opt/${PN}
	doins -r .

	fperms 0755 /opt/${PN}/ProjectRover

	# doins снимает exec-бит, а нативным .so он нужен
	find "${ED}/opt/${PN}" -name '*.so' -exec chmod 0755 {} + || die

	# wrapper в /usr/bin: подставляет DOTNET_ROOT, если он не задан.
	# Важно при запуске из .desktop / лаунчеров без shell-окружения.
	dodir /usr/bin
	cat > "${ED}/usr/bin/${PN}" <<-WRAPPER || die
		#!/bin/sh
		# Project Rover launcher
		if [ -z "\${DOTNET_ROOT}" ]; then
		    for d in \\
		        "\${HOME}/.dotnet" \\
		        /usr/share/dotnet \\
		        /opt/dotnet; do
		        if [ -x "\${d}/dotnet" ]; then
		            export DOTNET_ROOT="\${d}"
		            break
		        fi
		    done
		fi
		exec /opt/${PN}/ProjectRover "\$@"
	WRAPPER
	fperms 0755 /usr/bin/${PN}

	make_desktop_entry \
		"${PN}" \
		"Project Rover" \
		"" \
		"Development;Debugger;IDE;"
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "ProjectRover требует .NET 10 runtime."
	elog "Проверь: dotnet --list-runtimes | grep 'Microsoft.NETCore.App 10'"
	elog ""
	elog "Запуск: projectrover [path/to/assembly.dll]"
}
