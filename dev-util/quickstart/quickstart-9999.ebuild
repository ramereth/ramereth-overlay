# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

if [[ ${PV} == "9999" ]]; then
	ESVN_REPO_URI="https://agaffney.org/repos/quickstart/trunk"
	inherit subversion
else
	SRC_URI="http://agaffney.org/quickstart/releases/${P}.tar.bz2"
fi

DESCRIPTION="Very simple bash-based Gentoo Installer"
HOMEPAGE="http://agaffney.org/quickstart.php"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-amd64 -x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	einfo "no compile"
}

src_install() {
	insinto /usr/share/${PN}
	doins -r modules quickstart server
	dosym /usr/share/${PN}/quickstart /usr/sbin/quickstart
	dodoc doc/*
}
