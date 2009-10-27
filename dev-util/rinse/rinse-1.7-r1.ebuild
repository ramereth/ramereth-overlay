# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit bash-completion eutils

DESCRIPTION="A utility is designed to install a minimal RPM-based distribution
of Linux in a local directory"
HOMEPAGE="http://www.xen-tools.org/software/rinse/"
SRC_URI="http://www.xen-tools.org/software/rinse/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-arch/rpm
	dev-lang/perl
	dev-perl/libwww-perl"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-32bit-installs.patch
	epatch "${FILESDIR}"/${P}-pick-saner-mirrors.patch
	epatch "${FILESDIR}"/${P}-fedora-fixes.patch
}

src_compile() {
	einfo "no compile"
}

src_install() {
	emake PREFIX="${D}" install || die "emake install failed"
	rm -rf "${D}"/etc/bash_completion.d
	dobashcompletion misc/rinse rinse
	dodoc BUGS INSTALL README
}
