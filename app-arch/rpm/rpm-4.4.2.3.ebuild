# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.4.6-r6.ebuild,v 1.1 2008/05/31 16:18:57 loki_val Exp $

inherit eutils autotools distutils flag-o-matic

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org/"
SRC_URI="http://rpm.org/releases/rpm-4.4.x/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="nls python doc"

RDEPEND=">=sys-libs/db-4
	>=sys-libs/zlib-1.1.3
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	virtual/libintl
	dev-libs/nss
	>=dev-db/sqlite-3.3.5
	>=dev-libs/beecrypt-3.1.0-r1
	python? ( >=dev-lang/python-2.2 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# upstream patches
	epatch "${FILESDIR}"/${PN}-4.4.2.3-prereq.patch
	epatch "${FILESDIR}"/${PN}-4.4.2-ghost-conflicts.patch
	epatch "${FILESDIR}"/${PN}-4.4.2-trust.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.2-devel-autodep.patch
	epatch "${FILESDIR}"/${PN}-4.4.2-rpmfc-skip.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.2-matchpathcon.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.1-no-popt.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-nss.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.2-autofoo.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.2-pkgconfig-path.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-queryformat-arch.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-no-order-rescan-limit.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-fix-find-requires.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-rc1-sparc-mcpu.patch

	# Gentoo specific patches
	epatch "${FILESDIR}"/${PN}-4.4.2.3-configure-nss-fix.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-configure-lib64-fix.patch
	epatch "${FILESDIR}"/${PN}-4.4.2.3-selinux-fix.patch
	# force external popt
	rm -rf popt
	AT_NO_RECURSIVE=1
	eautoreconf	
}

src_compile() {
	python_version
	LDFLAGS="-L/usr/lib/nss" \
	econf \
		--enable-posixmutexes \
		--without-selinux \
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

	dodoc CHANGES CREDITS GROUPS README*

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
