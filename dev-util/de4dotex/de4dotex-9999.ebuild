# Copyright 2026 depsad
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit git-r3

DESCRIPTION=".NET deobfuscator and unpacker (G DATA fork of de4dot)"
HOMEPAGE="https://github.com/GDATAAdvancedAnalytics/de4dotEx"

MY_PN="de4dotEx"
EGIT_REPO_URI="https://github.com/GDATAAdvancedAnalytics/${MY_PN}.git"
EGIT_BRANCH="master"

LICENSE="GPL-3 MIT public-domain"
SLOT="0"
KEYWORDS=""

RESTRICT="network-sandbox strip test"

RDEPEND="
	dev-libs/icu
	dev-libs/openssl
	sys-libs/zlib
"
BDEPEND=">=dev-dotnet/dotnet-sdk-bin-8.0"

QA_PREBUILT="opt/${MY_PN}/*"

src_compile() {
	export HOME="${T}/home"
	export DOTNET_CLI_HOME="${T}/home"
	export NUGET_PACKAGES="${T}/nuget"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
	mkdir -p "${HOME}" "${NUGET_PACKAGES}" || die

	dotnet publish de4dot/de4dot.csproj \
		--configuration Release \
		--framework net8.0 \
		--runtime linux-x64 \
		--self-contained true \
		-p:UseAppHost=true \
		--output "${S}/publish" \
		|| die "dotnet publish failed"

	rm -f "${S}"/publish/*.pdb "${S}"/publish/*.xml || die
}

src_install() {
	dodir "/opt/${MY_PN}"
	cp -r "${S}/publish/." "${ED}/opt/${MY_PN}/" || die
	fperms 0755 "/opt/${MY_PN}/de4dot"

	dosym -r "/opt/${MY_PN}/de4dot" /usr/bin/de4dot

	dodoc README.md README-CEx.md README-vg.md
}
