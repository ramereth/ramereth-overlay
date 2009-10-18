# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit bash-completion

DESCRIPTION="Utility to install a minimal RPM-based distro of within a local
directory."
HOMEPAGE="http://www.xen-tools.org/software/rinse"
SRC_URI="http://www.xen-tools.org/software/rinse/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-arch/rpm
	net-misc/wget
	dev-perl/libwww-perl"

src_compile() {
	einfo "no compile"
}

src_install() {
	emake PREFIX="${D}" install || die "emake failed"
	rm -rf "${D}"/etc/bash_completion.d
	dodoc INSTALL README BUGS
	dobashcompletion misc/rinse
}
