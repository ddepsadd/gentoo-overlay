# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.4
	android_system_properties@0.1.5
	anstream@0.6.21
	anstyle-parse@0.2.7
	anstyle-query@1.1.5
	anstyle-wincon@3.0.11
	anstyle@1.0.13
	async-broadcast@0.7.2
	async-channel@2.5.0
	async-executor@1.13.3
	async-io@2.6.0
	async-lock@3.4.2
	async-process@2.5.0
	async-recursion@1.1.1
	async-signal@0.2.13
	async-task@4.7.1
	async-trait@0.1.89
	atomic-waker@1.1.2
	auto_impl@1.3.0
	autocfg@1.5.0
	bitflags@1.3.2
	bitflags@2.10.0
	blocking@1.6.2
	bumpalo@3.19.1
	bytemuck@1.25.0
	byteorder-lite@0.1.0
	bytes@1.11.0
	cc@1.2.53
	cfg-if@1.0.4
	chrono@0.4.44
	clap@4.5.60
	clap_builder@4.5.60
	clap_derive@4.5.55
	clap_lex@1.0.0
	colorchoice@1.0.4
	concurrent-queue@2.5.0
	core-foundation-sys@0.8.7
	crc32fast@1.5.0
	crossbeam-utils@0.8.21
	dashmap@5.5.3
	deranged@0.5.8
	dirs-sys@0.5.0
	dirs@6.0.0
	displaydoc@0.2.6
	downcast-rs@1.2.1
	endi@1.1.1
	enumflags2@0.7.12
	enumflags2_derive@0.7.12
	equivalent@1.0.2
	errno@0.3.14
	event-listener-strategy@0.5.4
	event-listener@5.4.1
	eventline@0.8.0
	fastrand@2.3.0
	fdeflate@0.3.7
	find-msvc-tools@0.1.8
	flate2@1.1.9
	form_urlencoded@1.2.2
	futures-channel@0.3.32
	futures-core@0.3.32
	futures-executor@0.3.32
	futures-io@0.3.32
	futures-lite@2.6.1
	futures-macro@0.3.32
	futures-sink@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	futures@0.3.32
	getrandom@0.2.17
	getrandom@0.3.4
	hashbrown@0.14.5
	hashbrown@0.16.1
	heck@0.5.0
	hermit-abi@0.5.2
	hex@0.4.3
	httparse@1.10.1
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.64
	icu_collections@2.1.1
	icu_locale_core@2.1.1
	icu_normalizer@2.1.1
	icu_normalizer_data@2.1.1
	icu_properties@2.1.2
	icu_properties_data@2.1.2
	icu_provider@2.1.1
	idna@1.1.0
	idna_adapter@1.2.1
	image@0.25.10
	indexmap@2.13.0
	is_terminal_polyfill@1.70.2
	itoa@1.0.17
	js-sys@0.3.85
	ksni@0.3.4
	libc@0.2.182
	libredox@0.1.12
	linux-raw-sys@0.12.1
	litemap@0.8.2
	lock_api@0.4.14
	log@0.4.29
	lsp-types@0.94.1
	memchr@2.7.6
	memoffset@0.9.1
	miniz_oxide@0.8.9
	mio@1.1.1
	moxcms@0.8.1
	ntapi@0.4.2
	num-conv@0.2.1
	num-traits@0.2.19
	num_threads@0.1.7
	objc2-core-foundation@0.3.1
	objc2-io-kit@0.3.1
	once_cell@1.21.3
	once_cell_polyfill@1.70.2
	option-ext@0.2.0
	ordered-stream@0.2.0
	parking@2.2.1
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pastey@0.2.3
	percent-encoding@2.3.2
	pin-project-internal@1.1.13
	pin-project-lite@0.2.16
	pin-project@1.1.13
	piper@0.2.4
	pkg-config@0.3.32
	png@0.18.1
	polling@3.11.0
	potential_utf@0.1.4
	powerfmt@0.2.0
	proc-macro-crate@3.4.0
	proc-macro2@1.0.105
	procfs-core@0.18.0
	procfs@0.18.0
	pxfm@0.1.29
	quick-xml@0.38.4
	quote@1.0.43
	r-efi@5.3.0
	redox_syscall@0.5.18
	redox_users@0.5.2
	regex-automata@0.4.13
	regex-syntax@0.8.8
	regex@1.12.3
	rune-cfg@0.5.0
	rustix@1.1.4
	rustversion@1.0.22
	scopeguard@1.2.0
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_json@1.0.149
	serde_repr@0.1.20
	shlex@1.3.0
	signal-hook-registry@1.4.8
	simd-adler32@0.3.9
	slab@0.4.11
	smallvec@1.15.1
	socket2@0.6.1
	stable_deref_trait@1.2.1
	strsim@0.11.1
	syn@2.0.114
	synstructure@0.13.2
	sysinfo@0.38.2
	tempfile@3.24.0
	thiserror-impl@2.0.17
	thiserror@2.0.17
	time-core@0.1.8
	time-macros@0.2.27
	time@0.3.47
	tinystr@0.8.2
	tokio-macros@2.6.0
	tokio-util@0.7.18
	tokio@1.49.0
	toml_datetime@0.7.5+spec-1.1.0
	toml_edit@0.23.10+spec-1.0.0
	toml_parser@1.0.6+spec-1.1.0
	tower-layer@0.3.3
	tower-lsp-macros@0.9.0
	tower-lsp@0.20.0
	tower-service@0.3.3
	tower@0.4.13
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing@0.1.44
	uds_windows@1.1.0
	unicode-ident@1.0.22
	url@2.5.8
	utf8_iter@1.0.4
	utf8parse@0.2.2
	uuid@1.19.0
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasm-bindgen-macro-support@0.2.108
	wasm-bindgen-macro@0.2.108
	wasm-bindgen-shared@0.2.108
	wasm-bindgen@0.2.108
	wayland-backend@0.3.12
	wayland-client@0.31.12
	wayland-protocols@0.32.10
	wayland-scanner@0.31.8
	wayland-sys@0.31.8
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.3.2
	windows-core@0.62.2
	windows-future@0.3.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-numerics@0.3.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.60.2
	windows-sys@0.61.2
	windows-targets@0.53.5
	windows-threading@0.2.1
	windows@0.62.2
	windows_aarch64_gnullvm@0.53.1
	windows_aarch64_msvc@0.53.1
	windows_i686_gnu@0.53.1
	windows_i686_gnullvm@0.53.1
	windows_i686_msvc@0.53.1
	windows_x86_64_gnu@0.53.1
	windows_x86_64_gnullvm@0.53.1
	windows_x86_64_msvc@0.53.1
	winnow@0.7.14
	wit-bindgen@0.51.0
	writeable@0.6.3
	yoke-derive@0.8.1
	yoke@0.8.1
	zbus@5.14.0
	zbus_macros@5.14.0
	zbus_names@4.3.1
	zerofrom-derive@0.1.6
	zerofrom@0.1.8
	zerotrie@0.2.3
	zerovec-derive@0.11.2
	zerovec@0.11.5
	zmij@1.0.15
	zvariant@5.10.0
	zvariant_derive@5.10.0
	zvariant_utils@3.3.0
"

RUST_MIN_VER="1.85.0"

inherit cargo desktop systemd

DESCRIPTION="A modern Wayland idle manager that knows when to step back"
HOMEPAGE="https://github.com/saltnpepper97/stasis"
SRC_URI="
	https://github.com/saltnpepper97/stasis/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	GPL-3+ MIT MPL-2.0 Unicode-3.0 Unlicense
	|| ( Apache-2.0 BSD )
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+notify +pulseaudio systemd"

DEPEND="dev-libs/wayland"
RDEPEND="
	${DEPEND}
	notify? ( x11-libs/libnotify )
	pulseaudio? ( media-libs/libpulse )
"
BDEPEND="virtual/pkgconfig"

QA_PRESTRIPPED="usr/bin/stasis"

src_install() {
	cargo_src_install

	doman docs/man/stasis.1 docs/man/stasis.5

	doicon assets/stasis.png
	doicon assets/stasis-tray.png

	dodoc README.md CHANGELOG.md examples/stasis.rune

	if use systemd; then
		systemd_douserunit packaging/systemd/user/stasis.service
		systemd_douserunit packaging/systemd/user/stasis-tray.service
	fi
}

pkg_postinst() {
	elog "On first run stasis creates ~/.config/stasis/stasis.rune"
	elog "Reference config: /usr/share/doc/${PF}/stasis.rune.bz2"
	elog "System-wide fallback: /etc/stasis/stasis.rune"
	elog ""
	elog "stasis needs a real session D-Bus for enable_dbus_inhibit to work."
	elog "Under OpenRC start your compositor via niri-session or dbus-run-session,"
	elog "then spawn the daemon from the niri config:"
	elog "  spawn-at-startup \"stasis\""
	elog ""
	elog "Do not let your screen locker daemonize, or enable enable_loginctl."
}
