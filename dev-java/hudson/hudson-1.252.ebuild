# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE=""

inherit eutils java-pkg-2

DESCRIPTION="Hudson monitors executions of repeated jobs, such as building a
software project or jobs run by cron"
HOMEPAGE="https://hudson.dev.java.net/"
# Manually change this URL for each release as it has no scriptable way to
# figure this out automatically
SRC_URI="https://hudson.dev.java.net/files/documents/2402/109746/hudson.war"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64"

IUSE=""

COMMON_DEP=""

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

EANT_BUILD_TARGET=""
EANT_DOC_TARGET=""

pkg_setup() {
	enewgroup hudson
	enewuser hudson -1 -1 -1 hudson
}

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}/${A}" "${S}"
}

src_install() {
	java-pkg_dowar "hudson.war"
	dosbin "${FILESDIR}"/hudson
	dodir /var/log/hudson
	dodir /var/lib/hudson/{webroot,homedir}
	dosym /var/log/hudson /usr/share/${PN}/log
	dosym /var/lib/hudson/webroot /usr/share/${PN}/webroot
	dosym /var/lib/hudson/homedir /usr/share/${PN}/homedir
	fowners hudson:hudson /var/log/hudson
	fowners hudson:hudson /var/lib/hudson/{webroot,homedir}

	newinitd "${FILESDIR}"/hudson.initd hudson
	newconfd "${FILESDIR}"/hudson.confd hudson
}

