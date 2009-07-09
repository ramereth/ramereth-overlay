# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.4.6-r6.ebuild,v 1.1 2008/05/31 16:18:57 loki_val Exp $

inherit eutils autotools distutils flag-o-matic

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org/"
SRC_URI="http://rpm.org/releases/rpm-4.7.x/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls python doc selinux"

RDEPEND=">=sys-libs/db-4
	>=sys-libs/zlib-1.1.3
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.10.2.1
	>=app-crypt/gnupg-1.2
	sys-libs/readline
	sys-apps/file
	sys-libs/ncurses
	dev-libs/elfutils
	virtual/libintl
	dev-libs/nss
	net-misc/curl
	dev-lang/lua
	app-arch/lzma-utils
	>=dev-db/sqlite-3.3.5
	>=dev-libs/beecrypt-3.1.0-r1
	python? ( >=dev-lang/python-2.2 )
	nls? ( virtual/libintl )
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# upstream patches
	epatch "${FILESDIR}"/${P}-devel-autodep.patch
	epatch "${FILESDIR}"/${PN}-4.5.90-pkgconfig-path.patch
	epatch "${FILESDIR}"/${PN}-4.5.90-gstreamer-provides.patch
	epatch "${FILESDIR}"/${PN}-4.6.0-fedora-specspo.patch
	epatch "${FILESDIR}"/${P}-findlang-kde3.patch
	epatch "${FILESDIR}"/${P}-prtsig.patch
	epatch "${FILESDIR}"/${P}-python-altnevr.patch
	epatch "${FILESDIR}"/${P}-hardlink-sizes.patch
	epatch "${FILESDIR}"/${P}-fp-symlink.patch
	epatch "${FILESDIR}"/${P}-fp-findbyfile.patch
	epatch "${FILESDIR}"/${P}-extra-provides.patch
	epatch "${FILESDIR}"/${PN}-4.6.0-niagara.patch

	# force external popt
	rm -rf popt
	AT_NO_RECURSIVE=1
	# tell it where nss is at
	append-ldflags "$(pkg-config --libs-only-L nss)"
	append-cppflags "$(pkg-config --cflags-only-I nss)"
	eautoreconf	
}

src_compile() {
	python_version
	econf \
		--enable-posixmutexes \
		--with-lua \
		--enable-sqlite3 \
		--with-external-db \
		$(use_with selinux) \
		$(use_with python python ${PYVER}) \
		$(use_with doc apidocs) \
		$(use_enable nls) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}"/usr/src/pc

	mv "${D}"/bin/rpm "${D}"/usr/bin
	rmdir "${D}"/bin

	use nls || rm -rf "${D}"/usr/share/man/??

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CHANGES CREDITS GROUPS README* ChangeLog INSTALL ABOUT-NLS TODO

}

pkg_postinst() {
	if [[ -f ${ROOT}/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${ROOT}"/usr/bin/rpm --rebuilddb --root=${ROOT}
	else
		einfo "No RPM database found... Creating database..."
		"${ROOT}"/usr/bin/rpm --initdb --root=${ROOT}
	fi

	distutils_pkg_postinst
}
