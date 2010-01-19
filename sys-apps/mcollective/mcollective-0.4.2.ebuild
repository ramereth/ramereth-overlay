# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit ruby

DESCRIPTION="Framework to build server orchestration or parallel job execution
systems"
HOMEPAGE="http://code.google.com/p/mcollective/"
SRC_URI="http://mcollective.googlecode.com/files/${P}.tgz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

DEPEND=""
RDEPEND="dev-ruby/stomp"

src_install() {
	local sitelibdir
	sitelibdir="$(${RUBY} -rrbconfig -e 'puts Config::CONFIG["sitelibdir"]')"
	insinto "${sitelibdir}"
	doins -r lib/*
	insinto /usr/libexec/mcollective
	doins -r plugins/*
	insinto /etc/mcollective
	dosbin mc-*
	newsbin mcollectived.rb mcollectived
	use doc && dohtml -r doc/*
	newinitd "${FILESDIR}"/mcollectived.initd mcollectived
	cd etc
	for cfg in *.dist ; do newins "${cfg}" "${cfg%%.dist}" ; done
}

pkg_postinst() {
	einfo "Mcollective requires a stomp server installed and functioning before"
	einfo "you can use it. The recommended server to use is ActiveMQ [1] but"
	einfo "any other stomp compatible server should work."
	einfo
	einfo "It is recommended you read the \'getting started\' guide [2] if this"
	einfo "is a new installation"
	einfo
	einfo "[1] http://activemq.apache.org/"
	einfo "[2] http://code.google.com/p/mcollective/wiki/GettingStarted"
}
