# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

MY_PN="mirrorbrain"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Download Redirector and Metalink Generator"
HOMEPAGE="http://mirrorbrain.org"
SRC_URI="http://mirrorbrain.org/files/releases/${MY_P}.tar.gz"
LICENSE="Apache-2.0"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

DEPEND="dev-libs/geoip
	www-apache/mod_autoindex_mb
	www-apache/mod_mirrorbrain
	www-apache/mod_form
	dev-python/psycopg 
	dev-perl/DBD-Pg 
	dev-python/sqlobject
	dev-perl/Config-IniFiles
	dev-perl/Digest-MD4
	dev-perl/libwww-perl
	dev-python/cmdln"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

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
	exeinto /usr/libexec/mirrorbrain
	local tools="geoip-lite-update rsyncusers geoiplookup_city
		geoiplookup_continent"
	for i in ${tools} ; do
		doexe tools/${i}
	done
	newexe tools/metalink-hasher.py metalink-hasher
	newexe tools/rsyncinfo.py rsyncinfo
	newexe tools/scanner.pl scanner
	newexe mirrorprobe/mirrorprobe.py mirrorprobe
	insinto /etc
	doins ${FILESDIR}/mirrorbrain.conf.dist
	fperms 0640 /etc/mirrorbrain.conf.dist
	fowners root:mirrorbrain /etc/mirrorbrain.conf.dist

	# install mirrordoctor
	insinto /usr/share/mirrorbrain
	cd mirrordoctor
	distutils_src_install
	doins -r famfamfam_flag_icons
	mv "${D}"/usr/bin/mirrordoctor.py "${D}"/usr/libexec/mirrorbrain/
	dosym /usr/libexec/mirrorbrain/mirrordoctor.py /usr/bin/mb
	dosym /usr/libexec/mirrorbrain/mirrordoctor.py /usr/bin/mirrordoctor
	dosym /usr/libexec/mirrorbrain/mirrorprobe /usr/bin/mirrorprobe

	# install docs
	cd "${S}"
	insinto /usr/share/doc/${P}
	doins -r sql
	dodoc ABOUT BUGS FAQ INSTALL NEWS TODO THANKS
}
