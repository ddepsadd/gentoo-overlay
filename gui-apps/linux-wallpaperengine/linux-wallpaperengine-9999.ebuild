# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic git-r3

# Keep in sync with CEF_VERSION in the upstream CMakeLists.txt.
CEF_VERSION="135.0.17+gcbc1c5b+chromium-135.0.7049.52"
CEF_DIST="cef_binary_${CEF_VERSION}_linux64_minimal"

DESCRIPTION="Wallpaper Engine backgrounds for Linux"
HOMEPAGE="https://github.com/Almamu/linux-wallpaperengine"
EGIT_REPO_URI="https://github.com/Almamu/linux-wallpaperengine.git"

# CEF is fetched by CMakeModules/DownloadCEF.cmake at configure time; we
# pre-seed it into the build dir instead so the build stays sandboxed.
SRC_URI="https://cef-builds.spotifycdn.com/${CEF_DIST//+/%2B}.tar.bz2 -> ${CEF_DIST}.tar.bz2"

LICENSE="GPL-3 BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+wayland X"
REQUIRED_USE="|| ( wayland X )"

RDEPEND="
	app-accessibility/at-spi2-core
	app-arch/lz4:=
	dev-libs/nspr
	dev-libs/nss
	media-libs/freeglut
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/libpulse
	media-libs/libsdl2
	media-video/ffmpeg:=
	media-video/mpv:=
	net-print/cups
	sys-apps/dbus
	virtual/opengl
	virtual/zlib
	x11-libs/libXcomposite
	x11-libs/libXdamage
	wayland? (
		dev-libs/wayland
		gui-libs/egl-wayland
	)
	X? (
		x11-libs/libX11
		x11-libs/libXrandr
	)
"
DEPEND="
	${RDEPEND}
	media-libs/glm
	wayland? ( dev-libs/wayland-protocols )
"
BDEPEND="wayland? ( dev-util/wayland-scanner )"

# CEF ships prebuilt libraries and a sandbox helper binary.
RESTRICT="strip"
QA_PREBUILT="opt/${PN}/*"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake_src_prepare

	mkdir -p "${BUILD_DIR}/cef" || die
	tar -xf "${DISTDIR}/${CEF_DIST}.tar.bz2" -C "${BUILD_DIR}/cef" || die

	# The minimal CEF distribution only ships Release/ and Debug/; the build
	# system copies blobs from a dir named after CMAKE_BUILD_TYPE.
	ln -s Release "${BUILD_DIR}/cef/${CEF_DIST}/RelWithDebInfo" || die
}

src_configure() {
	# Upstream redefines __FILE__ for shorter log paths.
	append-flags -Wno-builtin-macro-redefined
	# The vendored glslang fork predates GCC 15 dropping transitive
	# <climits> includes; INT_MAX & co. end up undeclared without this.
	append-cxxflags -include climits

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/opt/${PN}"
		-DBUILD_TESTING=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# glslang and the CEF wrapper are built as shared libs but upstream has
	# no install rules for them; the binary links against both.
	exeinto "/opt/${PN}/lib64"
	doexe "${BUILD_DIR}/lib/libglslang.so.15.2.0"
	doexe "${BUILD_DIR}/lib/libcef_dll_wrapper.so"
	dosym libglslang.so.15.2.0 "/opt/${PN}/lib64/libglslang.so.15"
	dosym libglslang.so.15 "/opt/${PN}/lib64/libglslang.so"

	# Vendored deps drop their test binaries and CLI tools into the prefix.
	local junk=(
		api-test bm_fftw-float bm_kiss-float fastconv-float fastconvr-float
		fastfilt-float ffr-float fft-float function_source glslang
		glslangValidator psdpng-float qjs qjsc run-test262 spirv-cross
		spirv-remap st-float testcpp-float tkfc-float tr-float
	)
	local f
	for f in "${junk[@]}"; do
		rm -f "${ED}/opt/${PN}/${f}" || die
	done
	rm -rf "${ED}/opt/${PN}"/{include,share,bin} || die
	rm -f "${ED}/opt/${PN}"/lib64/*.a || die
	rm -rf "${ED}/opt/${PN}"/lib64/{cmake,pkgconfig} || die

	fperms +x "/opt/${PN}/${PN}"
	fperms +x "/opt/${PN}/chrome-sandbox"

	cat > "${T}/${PN}" <<-EOF || die
		#!/bin/sh
		export LD_LIBRARY_PATH="/opt/${PN}:/opt/${PN}/lib64:\${LD_LIBRARY_PATH}"
		cd "/opt/${PN}" || exit 1
		exec "./${PN}" "\$@"
	EOF
	dobin "${T}/${PN}"
}

pkg_postinst() {
	elog "Run with: ${PN} --screen-root <output> --bg <wallpaper-id>"
	elog "Wallpapers live in your Steam library under"
	elog "  steamapps/workshop/content/431960/"
	elog
	elog "On a hybrid GPU setup you may need CUDA_VISIBLE_DEVICES= to keep"
	elog "the nvidia stack out of the way."
}
