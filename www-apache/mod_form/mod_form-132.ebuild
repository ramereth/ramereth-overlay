# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module subversion

DESCRIPTION="Apache module utility to decode data submitted from Web forms"
HOMEPAGE="http://apache.webthing.com/mod_form/"
LICENSE="GPL-2"
ESVN_REPO_URI="http://apache.webthing.com/svn/apache/forms@${PV}"

KEYWORDS="~x86 ~amd64"
IUSE=""
SLOT="0"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="31_${PN}"

src_install() {
	apache-module_src_install
	insinto /usr/include
	doins mod_form.h
}

need_apache2
