# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

DESCRIPTION="Apache Module that manages the parsing of memcached server
configuration"
HOMEPAGE="http://code.google.com/p/modmemcache/"
LICENSE="Apache-2.0"
SRC_URI="http://modmemcache.googlecode.com/files/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="dev-libs/apr_memcache"
RDEPEND="${DEPEND}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="50_${PN}"

DOCFILES="README"

src_compile() {
	econf --with-apxs=${APXS} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	apache-module_src_install
	insinto /usr/include
	doins src/${PN}.h
}

need_apache2
