# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNIM_PV="1.9.1"

inherit meson git-r3

DESCRIPTION="Scaffolding CLI tool for Astal+Gnim desktop shell projects"
HOMEPAGE="https://github.com/aylur/ags"
EGIT_REPO_URI="https://github.com/aylur/ags.git"

# gnim is bundled as a pre-built npm tarball — meson copies node_modules/gnim
# verbatim into /usr/share/ags/js/node_modules/, and ags resolves
# `gnim/...` imports against gnim/dist/ at runtime.
SRC_URI="https://registry.npmjs.org/gnim/-/gnim-${GNIM_PV}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""

# Go CLI fetches modules during 'go build'.
RESTRICT="network-sandbox"

RDEPEND="
	dev-libs/gjs
	app-shells/bash
	gui-libs/gtk4-layer-shell
"
DEPEND="
	gui-libs/gtk4-layer-shell
"
BDEPEND="
	dev-lang/go
	dev-build/meson
	dev-build/ninja
	dev-libs/gjs
	virtual/pkgconfig
"

src_unpack() {
	# ags itself via git-r3
	git-r3_src_unpack

	# gnim tarball is fetched via SRC_URI; unpack it
	unpack "gnim-${GNIM_PV}.tgz"
	# npm tarballs always unpack into 'package/'
}

src_prepare() {
	# meson.build expects node_modules/gnim to exist for install_subdir().
	mkdir -p "${S}/node_modules" || die
	mv "${WORKDIR}/package" "${S}/node_modules/gnim" || die

	# Isolate Go caches inside the build tree.
	export GOCACHE="${T}/go-cache"
	export GOMODCACHE="${T}/go-mod-cache"
	export GOFLAGS="-mod=mod"

	default
}
