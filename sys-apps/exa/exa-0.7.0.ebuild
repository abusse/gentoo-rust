# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
ansi_term-0.8.0
bitflags-0.7.0
bitflags-0.9.1
byteorder-0.4.2
cmake-0.1.24
conv-0.3.3
custom_derive-0.1.7
datetime-0.4.4
gcc-0.3.51
getopts-0.2.14
git2-0.6.6
glob-0.2.11
idna-0.1.4
iso8601-0.1.1
lazy_static-0.2.8
libc-0.2.29
libgit2-sys-0.6.13
libz-sys-1.0.16
locale-0.2.2
magenta-0.1.1
magenta-sys-0.1.1
matches-0.1.6
natord-1.0.9
nom-1.2.4
num-0.1.40
number_prefix-0.2.7
num-bigint-0.1.40
num-complex-0.1.40
num_cpus-1.6.2
num-integer-0.1.35
num-iter-0.1.34
num-rational-0.1.39
num-traits-0.1.40
pad-0.1.4
percent-encoding-1.0.0
pkg-config-0.3.9
rand-0.3.16
rustc-serialize-0.3.24
scoped_threadpool-0.1.7
term_grid-0.1.5
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-width-0.1.4
url-1.5.1
users-0.5.3
vcpkg-0.2.2
"

inherit cargo

DESCRIPTION="A modern replacement for ls."
HOMEPAGE="https://the.exa.website/"
SRC_URI="https://github.com/ogham/exa/archive/v0.7.0.tar.gz
	$(cargo_crate_uris $CRATES)"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="git"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	cargo_src_unpack

	rm "${S}/Cargo.lock"
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"

	cargo build -v $(usex debug "" --release) $(usex git "" --no-default-features) \
		|| die "cargo build failed"
}

src_install() {
	cargo install --root="${D}/usr" $(usex debug --debug "") $(usex git "" --no-default-features)  \
		|| die "cargo install failed"
	rm -f "${D}/usr/.crates.toml"

	[ -d "${S}/man" ] && doman "${S}/man" || return 0
}