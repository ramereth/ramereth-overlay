# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="git://git.osuosl.org/${PN}.git"
	EGIT_BRANCH="master"
	inherit git autotools
else
	SRC_URI="http://packages.osuosl.org/distfiles/${P}.tar.bz2"
fi

DESCRIPTION="Scripts to do autobuilds with catalyst"
HOMEPAGE="http://osuosl.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="dev-util/catalyst"

src_compile() {
	einfo "no compile"
}

src_install() {
	insinto /etc/catalyst
	doins -r etc/catalyst/*
	insinto /usr/share/${PN}
	doins -r libs
	dosbin bin/build-stages
}
