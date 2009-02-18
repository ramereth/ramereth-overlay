# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Fast, mutli-threaded malloc() and nifty performance analysis tools"
HOMEPAGE="http://code.google.com/p/google-perftools/"
SRC_URI="http://google-perftools.googlecode.com/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/libunwind"
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
