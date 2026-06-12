# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.0.0
inherit branding cmake java-pkg-2 optfeature toolchain-funcs xdg

DESCRIPTION="Prism Launcher fork with offline accounts, custom auth servers and more"
HOMEPAGE="https://freesmlauncher.org/ https://github.com/FreesmTeam/FreesmLauncher"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreesmTeam/FreesmLauncher"
	EGIT_BRANCH="develop"
	EGIT_SUBMODULES=( 'libraries/libnbtplusplus' )
else
	MY_PN="FreesmLauncher"
	# CI-produced vendored tarball (bundles submodules), same scheme as upstream Prism.
	# NOTE: verify the top-level dir name / vendoring once on first build (see S=).
	SRC_URI="
		https://github.com/FreesmTeam/FreesmLauncher/releases/download/${PV}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="~amd64 ~arm64"
fi

# GPL-3 for Freesm/Prism/PolyMC, Apache-2.0 for MultiMC ancestry,
# LGPL-3+ for libnbtplusplus, rest per libraries/ dir upstream.
LICENSE="Apache-2.0 BSD BSD-2 GPL-2+ GPL-3 ISC LGPL-2.1+ LGPL-3+"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

# Required at both build time and runtime
COMMON_DEPEND="
	app-arch/libarchive:=
	app-text/cmark:=
	dev-cpp/tomlplusplus
	>=dev-qt/qtbase-${QTMIN}:6[concurrent,gui,opengl,network,vulkan,widgets,xml(+)]
	>=dev-qt/qtnetworkauth-${QTMIN}:6
	games-util/gamemode
	media-gfx/qrencode:=
	virtual/zlib:=
"
# max jdk-25 for prism bug #968411 (carried over, same upstream)
DEPEND="${COMMON_DEPEND}
	media-libs/libglvnd
	<virtual/jdk-26:*
"
# QtSvg needed at runtime for svg icons via QIcon. Runtime needs JRE not JDK.
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-${QTMIN}:6
	>=virtual/jre-1.8.0:*
	virtual/opengl
"
BDEPEND="
	app-text/scdoc
	>=kde-frameworks/extra-cmake-modules-6.0.0:*
	virtual/pkgconfig
"

# NOTE: upstream Prism ships two FILESDIR patches in ::gentoo
#   (fortify-source redef + openjdk21 java8-compat). They are NOT carried here
#   because they are version/tree-specific and the .patch files aren't vendored.
#   If the build dies on a _FORTIFY_SOURCE redefinition, grab the current
#   prismlauncher-*-fortify-source-redef.patch from ::gentoo into files/ and
#   re-add it to PATCHES below.
# PATCHES=( "${FILESDIR}/${PN}-fortify-source-redef.patch" )
src_prepare() {
	cmake_src_prepare

	# JDK >= 20 выпилил -source/-target 7; поднимаем java-хелперы до 8.
	# (аналог prism openjdk21.patch, но через sed чтобы не таскать .patch-файл)
	sed -i -e 's/-target 7/-target 8/g; s/-source 7/-source 8/g' \
		libraries/javacheck/CMakeLists.txt \
		libraries/launcher/CMakeLists.txt \
		|| die "failed to bump java source/target to 8"
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="/usr"
		# Freesm's CMake already defaults this to "freesmlauncher"; pin to ${PN}
		-DLauncher_APP_BINARY_NAME="${PN}"
		-DLauncher_BUILD_PLATFORM="${BRANDING_OS_PRETTY_NAME}"
		-DLauncher_QT_VERSION_MAJOR=6

		-DENABLE_LTO=$(tc-is-lto)
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "old Minecraft (<= 1.12.2) support" x11-apps/xrandr
	optfeature "built-in MangoHud support (GURU overlay)" games-util/mangohud
	optfeature "built-in Feral Gamemode support" games-util/gamemode
}
