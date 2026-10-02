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

# NuGet restore (dnlib + linux-x64 runtime packs) needs the network at build
# time, and the self-contained runtime ships prestripped .so files.
RESTRICT="network-sandbox strip test"

# Self-contained still dynamically links these from the host.
RDEPEND="
	dev-libs/icu
	dev-libs/openssl
	virtual/zlib
"
BDEPEND=">=dev-dotnet/dotnet-sdk-bin-10.0"

# Silence QA scanners on the bundled .NET runtime shared objects.
QA_PREBUILT="opt/${MY_PN}/*"

src_compile() {
	# Keep every dotnet/NuGet write inside the build sandbox.
	export HOME="${T}/home"
	export DOTNET_CLI_HOME="${T}/home"
	export NUGET_PACKAGES="${T}/nuget"
	export DOTNET_CLI_TELEMETRY_OPTOUT=1
	export DOTNET_NOLOGO=1
	export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
	mkdir -p "${HOME}" "${NUGET_PACKAGES}" || die

	# Mirrors the upstream Linux CI publish step.
	dotnet publish de4dot/de4dot.csproj \
		--configuration Release \
		--framework net10.0 \
		--runtime linux-x64 \
		--self-contained true \
		-p:UseAppHost=true \
		--output "${S}/publish" \
		|| die "dotnet publish failed"

	# Strip dev cruft, same as upstream.
	rm -f "${S}"/publish/*.pdb "${S}"/publish/*.xml || die
}

src_install() {
	dodir "/opt/${MY_PN}"
	cp -r "${S}/publish/." "${ED}/opt/${MY_PN}/" || die
	fperms 0755 "/opt/${MY_PN}/de4dot"

	# de4dot <input.dll> ... from anywhere.
	dosym -r "/opt/${MY_PN}/de4dot" /usr/bin/de4dot

	dodoc README.md README-CEx.md README-vg.md
}
