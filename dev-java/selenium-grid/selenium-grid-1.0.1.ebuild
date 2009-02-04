# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="Open-source tool that dramatically speeds up web testing by
leveraging your existing computing infrastructure."
HOMEPAGE="http://selenium-grid.openqa.org/"
SRC_URI="http://release.openqa.org/selenium-grid/${P}-src.tar.bz2"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="examples"

COMMON_DEP="dev-java/ant-junit"

RDEPEND=">=virtual/jre-1.5
	dev-ruby/rake
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET=""
WANT_ANT_TASKS="ant-junit"
EANT_EXTRA_ARGS="-Djruby.home="${T}"/.jruby"

pkg_setup() {
	enewgroup selenium
	enewuser selenium -1 -1 -1 selenium
}

src_unpack() {
	mkdir -p ${S}
	cd ${S}
	unpack ${A}
	epatch "${FILESDIR}"/${PN}-jruby-home-fix.patch
}

src_install() {
	java-pkg_dojar dist/${P}/lib/*.jar

	exeinto /usr/sbin
	doexe ${FILESDIR}/selenium-{hub,remote}

	insinto /usr/share/${PN}
	doins dist/${P}/{build.xml,grid_configuration.yml,project.properties,Rakefile}
	insinto /usr/share/${PN}/lib/ruby
	doins -r dist/${P}/lib/ruby
	dodir /var/log/selenium
	dosym /var/log/selenium /usr/share/${PN}/log
	fowners selenium:selenium /var/log/selenium

	use doc && java-pkg_dojavadoc dist/${P}/doc
	use examples && java-pkg_doexamples dist/${P}/examples
	use source && java-pkg_dosrc src

	newinitd "${FILESDIR}"/selenium-hub.init selenium-hub
	newinitd "${FILESDIR}"/selenium-remote.init selenium-remote
	newconfd "${FILESDIR}"/selenium-remote.confd selenium-remote
}

