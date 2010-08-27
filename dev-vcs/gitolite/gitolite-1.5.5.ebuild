# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Highly flexible server for git directory version tracker"
HOMEPAGE="http://github.com/sitaramc/gitolite"
SRC_URI="http://github.com/sitaramc/${PN}/tarball/v${PV} -> ${PN}-git-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl
	>=dev-vcs/git-1.6.2"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup git
	enewuser git -1 /bin/bash /var/lib/gitolite git
}

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/sitaramc-"${PN}"-* "${S}" || die
}

src_prepare() {
	rm Makefile doc/COPYING
}

src_install() {
	dodir /usr/share/gitolite/{conf,hooks} /usr/bin
	echo "${PF}" > conf/VERSION

	# install using upstream method
	"${S}"/src/gl-system-install "${D}"/usr/bin \
		"${D}"/usr/share/gitolite/conf "${D}"/usr/share/gitolite/hooks
	dosed "s:\/var\/tmp\/portage\/dev-vcs\/${P}\/image\/::g" \
		usr/bin/gl-setup usr/share/gitolite/conf/example.gitolite.rc

	dodoc README.mkd doc/*
	insinto /usr/share/doc/${P}
	doins -r contrib

	keepdir /var/lib/gitolite
	fowners git:git /var/lib/gitolite
	fperms 750 /var/lib/gitolite
}
