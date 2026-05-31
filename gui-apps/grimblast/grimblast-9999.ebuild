EAPI=8
inherit git-r3
DESCRIPTION="Hyprland-friendly screenshot wrapper around grim, slurp, hyprctl"
HOMEPAGE="https://github.com/hyprwm/contrib"
EGIT_REPO_URI="https://github.com/hyprwm/contrib.git"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
RDEPEND="
    gui-apps/grim
    gui-apps/slurp
    gui-apps/wl-clipboard
    x11-libs/libnotify
    media-gfx/imagemagick
"
S="${WORKDIR}/${P}/grimblast"
src_install() {
    dobin grimblast
    doman grimblast.1
}
