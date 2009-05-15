# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

MY_P="${PN}_${PV}"

DESCRIPTION="Apache 2.x module for finding the country and city
that a web request originated from"
HOMEPAGE="http://www.maxmind.com/app/mod_geoip"
SRC_URI="http://geolite.maxmind.com/download/geoip/api/mod_geoip2/${MY_P}.tar.gz"
LICENSE="Apache-1.1"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="dev-libs/geoip"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="30_${PN}"
APACHE2_MOD_FILE=".libs/mod_geoip.so"
APXS2_ARGS="-c mod_geoip.c"
DOCFILES="INSTALL README Changes"

need_apache2
