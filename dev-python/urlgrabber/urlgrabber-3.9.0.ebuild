# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/urlgrabber/urlgrabber-3.1.0.ebuild,v 1.5 2009/01/24 13:00:13 aballier Exp $

EAPI=2

inherit distutils eutils

DESCRIPTION="python module for downloading files"
HOMEPAGE="http://urlgrabber.baseurl.org/"
SRC_URI="http://urlgrabber.baseurl.org/download/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-python/pycurl"
RDEPEND="${DEPEND}"

src_prepare() {
	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}/${P}-8-HEAD.patch.bz2"
}
