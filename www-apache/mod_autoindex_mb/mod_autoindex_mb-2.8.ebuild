# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

MY_PN="mirrorbrain"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Apache modules that optionally adds metalinks and mirrorlists to
the HTML"
HOMEPAGE="http://mirrorbrain.org"
SRC_URI="http://mirrorbrain.org/files/releases/${MY_P}.tar.gz"
LICENSE="Apache-2.0"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

S="${WORKDIR}/${MY_P}/${PN}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="60_${PN}"
APACHE2_MOD_DEFINE="AUTOINDEX_MB"

src_install() {
	apache-module_src_install
	dodoc NOTICE
}

need_apache2
