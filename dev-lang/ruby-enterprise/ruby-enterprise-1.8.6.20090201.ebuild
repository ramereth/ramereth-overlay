# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit versionator eutils flag-o-matic

EAPI="2"

MY_PV=$(replace_version_separator 3 '-')
S="${WORKDIR}/${PN}-${MY_PV}/source"

SLOT=$(get_version_component_range 1-2)
MY_SUFFIX=$(delete_version_separator 1 ${SLOT})

DESCRIPTION="Ruby Enterprise Edition is a branch of Ruby including various enhancements"
HOMEPAGE="http://www.rubyenterpriseedition.com/"
SRC_URI="mirror://rubyforge/emm-ruby/${PN}-${MY_PV}.tar.gz"

LICENSE="|| ( Ruby GPL-2 )"
KEYWORDS="amd64 x86"
IUSE="doc tcmalloc threads"

DEPEND="
	dev-libs/openssl
	sys-libs/zlib
	sys-libs/readline
	!dev-lang/ruby
	tcmalloc? ( dev-util/google-perftools )
	>=app-admin/eselect-ruby-20081211"
RDEPEND="${RDEPEND}"
PDEPEND="dev-ruby/rubygems"

PROVIDE="virtual/ruby"

src_unpack() {
	unpack "${A}"
	cd "${S}"
	epatch "${FILESDIR}/${PN}-${MY_PV}-openssl.patch"
}

src_compile() {
	if use tcmalloc ; then
		append-ldflags -ltcmalloc_minimal
	fi

	econf --program-suffix=${MY_SUFFIX} --enable-shared \
		$(use_enable doc install-doc) \
		$(use_enable threads pthread) \
		${myconf} \
		--with-sitedir=/usr/$(get_libdir)/ruby/site_ruby \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	LD_LIBRARY_PATH="${D}/usr/$(get_libdir)"
	RUBYLIB="${S}:${D}/usr/$(get_libdir)/ruby/${SLOT}"
	for d in $(find "${S}/source/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done
	export LD_LIBRARY_PATH RUBYLIB

	emake DESTDIR="${D}" install || die "make install failed"

	MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo $(MINIRUBY)'|make -f - getminiruby)
	keepdir $(${MINIRUBY} -rrbconfig -e "print Config::CONFIG['sitelibdir']")
	keepdir $(${MINIRUBY} -rrbconfig -e "print Config::CONFIG['sitearchdir']")

	if use doc; then
		make DESTDIR="${D}" install-doc || die "make install-doc failed"
	fi

	dosym libruby$MY_SUFFIX$(get_libname ${PV%_*}) /usr/$(get_libdir)/libruby$(get_libname ${PV%.*})
	dosym libruby$MY_SUFFIX$(get_libname ${PV%_*}) /usr/$(get_libdir)/libruby$(get_libname ${PV%_*})

	dodoc ChangeLog NEWS README* ToDo
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog   
	elog "This ebuild is compatible to eselect-ruby"
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(18|19|...)"
	elog
}

pkg_postrm() { 
	if [[ ! -n $(readlink "${ROOT}"usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi
}
