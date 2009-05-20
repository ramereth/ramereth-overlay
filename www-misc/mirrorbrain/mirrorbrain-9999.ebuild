# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils subversion

#MY_PN="mirrorbrain"
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Download Redirector and Metalink Generator"
HOMEPAGE="http://mirrorbrain.org"
SRC_URI=""
ESVN_REPO_URI="https://forgesvn1.novell.com/svn/opensuse/trunk/tools/download-redirector-v2"
LICENSE="Apache-2.0"

KEYWORDS=""
IUSE=""
SLOT="0"

DEPEND="dev-libs/geoip
	=www-apache/mod_autoindex_mb-${PV}
	=www-apache/mod_mirrorbrain-${PV}
	www-apache/mod_form
	dev-python/psycopg
	dev-perl/DBD-Pg
	dev-python/sqlobject
	dev-perl/Config-IniFiles
	dev-perl/Digest-MD4
	dev-perl/libwww-perl
	dev-python/cmdln"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup mirrorbrain
	enewuser mirrorbrain -1 -1 /dev/null mirrorbrain
}

src_compile() {
	tc-export CC
	cd tools
	${CC} -Wall -fPIC -lGeoIP -o geoiplookup_continent geoiplookup_continent.c
	${CC} -Wall -fPIC -lGeoIP -o geoiplookup_city geoiplookup_city.c
	cd ../mirrordoctor
	distutils_src_compile
}

src_install() {
	# install docs
	dodoc ABOUT BUGS FAQ INSTALL NEWS TODO THANKS

	# install misc files/scripts
	newbin mirrorprobe/mirrorprobe.py mirrorprobe
	insinto /usr/share/"${PN}"
	doins -r sql
	doins -r tools
	rm "${D}"/usr/share/"${PN}"/tools/*.c
	# install mirrordoctor
	cd mirrordoctor
	distutils_src_install
	doins -r famfamfam_flag_icons
	mv "${D}"/usr/bin/mirrordoctor.py "${D}"/usr/bin/mirrordoctor
	dosym /usr/bin/mirrordoctor /usr/bin/mb

	# config files
	insinto /etc
	doins "${FILESDIR}"/mirrorbrain.conf.dist
	fperms 0640 /etc/mirrorbrain.conf.dist
	fowners root:mirrorbrain /etc/mirrorbrain.conf.dist
}
