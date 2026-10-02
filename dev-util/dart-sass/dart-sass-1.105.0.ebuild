# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sass reference implementation written in Dart (prebuilt)"
HOMEPAGE="https://sass-lang.com/ https://github.com/sass/dart-sass"
SRC_URI="https://github.com/sass/dart-sass/releases/download/${PV}/dart-sass-${PV}-linux-x64.tar.gz"
S="${WORKDIR}/dart-sass"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# Prebuilt Dart VM + snapshot — don't strip or QA-check the binary.
RESTRICT="strip"
QA_PREBUILT="opt/dart-sass/src/dart"

src_install() {
	local dest="opt/dart-sass"
	dodir "/${dest}"
	cp -r . "${ED}/${dest}/" || die

	fperms 0755 "/${dest}/sass"
	fperms 0755 "/${dest}/src/dart"

	dosym -r "/${dest}/sass" /usr/bin/sass
}
