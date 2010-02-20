# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit webapp

GIT_V="1.6.4.3"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="http://hjemli.net/git/cgit/about/"
SRC_URI="mirror://kernel/software/scm/git/git-${GIT_V}.tar.bz2
	http://hjemli.net/git/cgit/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="+cgi"

RDEPEND="dev-util/git
	sys-libs/zlib
	dev-libs/openssl
	cgi? ( virtual/httpd-cgi )"
DEPEND="${RDEPEND}
	app-text/asciidoc"

src_prepare() {
	rmdir git
	mv "${WORKDIR}"/git-"${GIT_V}" git
}

src_compile() {
	emake || die "emake died"
	emake man-doc || die "emake man-doc died"
}

src_install() {
	webapp_src_preinst

	mv cgit cgit.cgi
	if use cgi -o use fastcgi ; then
		cp cgit.cgi "${D}"/${MY_CGIBINDIR}
	fi
	insinto ${MY_HTDOCSDIR}
	doins cgit.css cgit.png
	insinto /etc
	doins "${FILESDIR}"/cgitrc
	dodir /var/cache/cgit
	keepdir /var/cache/cgit
	dodoc README
	doman cgitrc.5

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install
}
