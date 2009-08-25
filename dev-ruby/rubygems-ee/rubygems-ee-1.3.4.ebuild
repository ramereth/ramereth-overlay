# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubygems/rubygems-1.2.0.ebuild,v 1.4 2008/08/06 16:40:12 graaff Exp $

inherit ruby

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="http://rubyforge.org/projects/rubygems/"
LICENSE="|| ( Ruby GPL-2 )"

# Needs to be installed first
RESTRICT="test"

MY_PN="rubygems"
MY_P="rubygems-${PV}"
S="${WORKDIR}/${MY_P}"

# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="mirror://rubyforge/${MY_PN}/${MY_P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc server"
DEPEND="=dev-lang/ruby-enterprise-1.8*"
RDEPEND="${DEPEND}"
PDEPEND="server? ( dev-ruby/builder )" # index_gem_repository.rb

USE_RUBY="ruby18"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-setup.patch"
	# Fixes a new "feature" that would prevent us from recognizing installed
	# gems inside the sandbox
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_compile() {
	# Allowing ruby_src_compile would be bad with the new setup.rb
	:
}

src_install() {
	# RUBYOPT=-rauto_gem without rubygems installed will cause ruby to fail, bug #158455
	export RUBYOPT="${GENTOO_RUBYOPT}"
	ewarn "RUBYOPT=${RUBYOPT}"

	# Force ebuild to use Ruby Enterprise Edition
	export RUBY="/usr/bin/rubyee"

	ver=$(${RUBY} -r rbconfig -e 'print Config::CONFIG["ruby_version"]')

	# rubygems tries to create GEM_HOME if it doesn't exist, upsetting sandbox,
	# bug #202109. Since 1.2.0 we also need to set GEM_PATH
	# for this reason, bug #230163.
	export GEM_HOME="${D}/usr/$(get_libdir)/rubyee/gems/${ver}"
	export GEM_PATH="${GEM_HOME}/"
	keepdir /usr/$(get_libdir)/rubyee/gems/$ver/{doc,gems,cache,specifications}

	myconf=""
	if ! use doc; then
		myconf="${myconf} --no-ri"
		myconf="${myconf} --no-rdoc"
	fi

	${RUBY} setup.rb $myconf --destdir="${D}" || die "setup.rb install failed"

	dodoc README ChangeLog || die "dodoc README failed"

	cp "${FILESDIR}/auto_gem.rb" "${D}"/$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitedir"]') || die "cp auto_gem.rb failed"
	if [ ! -e /etc/env.d/10rubygems ] ; then
		doenvd "${FILESDIR}/10rubygems" || die "doenvd 10rubygems failed"
	fi

	if use server; then
		newinitd "${FILESDIR}/init.d-gem_server2" gem_server-ee || die "newinitd failed"
		newconfd "${FILESDIR}/conf.d-gem_server" gem_server-ee || die "newconfd failed"
	fi
}

pkg_postinst()
{
	SOURCE_CACHE="/usr/$(get_libdir)/rubyee/gems/$ver/source_cache"
	if [[ -e "${SOURCE_CACHE}" ]]; then
		rm "${SOURCE_CACHE}"
	fi

	if [[ ! -n $(readlink "${ROOT}"usr/bin/gem) ]] ; then
		eselect ruby set rubyee
	fi

	ewarn
	ewarn "This ebuild is ONLY for Ruby Enterprise Edition"
	ewarn "Use it with /usr/bin/gemee"
	ewarn
}
