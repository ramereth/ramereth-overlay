# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module subversion

DESCRIPTION="Apache module which does AS and network prefix lookups"
HOMEPAGE="http://mirrorbrain.org/news_items/mod_asn_-_Apache_module_to_look_up_routing_data"
LICENSE="Apache-2.0"
ESVN_REPO_URI="http://svn.poeml.de/svn/mod_asn/trunk@${PV}"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

# See apache-module.eclass for more information.
#APACHE2_MOD_CONF="30_${PN}"

src_install() {
	apache-module_src_install
	newsbin asn_import.py asn_import
	newsbin asn_get_routeviews.py asn_get_routeviews
	dodoc README INSTALL asn.sql mod_asn.conf
}

need_apache2
