# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module subversion

DESCRIPTION="Apache module which does AS and network prefix lookups"
HOMEPAGE="http://mirrorbrain.org/mod_asn"
LICENSE="Apache-2.0"
ESVN_REPO_URI="http://mirrorbrain.org/files/releases/${P}.tar.gz"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="30_${PN}"

src_install() {
	apache-module_src_install
	newsbin asn_import.py asn_import
	newsbin asn_get_routeviews.py asn_get_routeviews
	dodoc README INSTALL asn.sql mod_asn.conf
}

need_apache2
