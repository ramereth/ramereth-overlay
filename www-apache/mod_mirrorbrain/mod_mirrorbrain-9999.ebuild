# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit apache-module subversion

#MY_PN="mirrorbrain"
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="An Apache module Download Redirector and Metalink Generator"
HOMEPAGE="http://mirrorbrain.org"
SRC_URI=""
ESVN_REPO_URI="https://forgesvn1.novell.com/svn/opensuse/trunk/tools/download-redirector-v2/mod_mirrorbrain"
LICENSE="Apache-2.0"

KEYWORDS=""
IUSE="memcache"
SLOT="0"

# require postgres for now, may get mysql support later from upstream
DEPEND="www-apache/mod_form
	dev-libs/apr-util[postgres]
	www-servers/apache[apache2_modules_dbd]
	memcache? ( www-apache/mod_memcache )"
RDEPEND="${DEPEND}"
PDEPEND="=www-misc/mirrorbrain-${PV}"

#S="${WORKDIR}/${MY_P}/${PN}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="70_${PN}"
APACHE2_MOD_DEFINE="MIRRORBRAIN"

if use memcache ; then
	APXS2_ARGS="-DWITH_MEMCACHE -c ${PN}.c"
else
	APXS2_ARGS="-c ${PN}.c"
fi

DOCFILES="mod_dbd.conf mod_memcache.conf mod_mirrorbrain.conf"

need_apache2
