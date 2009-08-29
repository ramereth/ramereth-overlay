# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/yum/yum-3.2.8.ebuild,v 1.5 2008/05/29 18:04:58 hawking Exp $

EAPI=2

NEED_PYTHON=1
inherit python eutils multilib

DESCRIPTION="automatic updater and package installer/remover for rpm systems"
HOMEPAGE="http://yum.baseurl.org/"
SRC_URI="http://yum.baseurl.org/download/${PV:0:3}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/python-2.5[sqlite]
	app-arch/rpm[python]
	>=dev-python/sqlitecachec-1.1.0
	dev-python/celementtree
	dev-libs/libxml2[python]
	>=dev-python/urlgrabber-3.9.0
	dev-python/iniparse
	app-crypt/gpgme"

src_prepare() {
	# Fedora patches
	epatch "${FILESDIR}/${P}-mirror-priority.patch"
	epatch "${FILESDIR}/${P}-multilib-policy-best.patch"
	# move this patch to gentoo mirrors
	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}/${P}-14-HEAD.patch.bz2"
	epatch "${FILESDIR}/${P}-no-more-exactarchlist.patch"
	# gentoo patch
	epatch "${FILESDIR}/${P}-typeerror-fix.patch"
}

src_install() {
	python_version
	emake install DESTDIR="${D}" || die
	rm -r "${D}"/etc/rc.d || die
	find "${D}" -name '*.py[co]' -print0 | xargs -0 rm -f
}

pkg_postinst() {
	python_version
	python_mod_optimize \
		/usr/$(get_libdir)/python${PYVER}/site-packages/{yum,rpmUtils} \
		/usr/share/yum-cli
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/{yum,rpmUtils} /usr/share/yum-cli
}
