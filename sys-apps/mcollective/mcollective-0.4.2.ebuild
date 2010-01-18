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
