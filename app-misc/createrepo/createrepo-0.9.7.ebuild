# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Generates repodata dir and xml files for a repository of rpm packages"
HOMEPAGE="http://linux.duke.edu/createrepo/"
SRC_URI="http://linux.duke.edu/createrepo/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-arch/rpm
	>=sys-apps/yum-3.2.22
	dev-libs/libxml2"

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc COPYING.lib ChangeLog README
	doman docs/*.8 docs/*.1
}
