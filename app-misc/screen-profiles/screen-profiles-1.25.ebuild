# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A set of useful profiles for the GNU screen window manager"
HOMEPAGE="https://launchpad.net/screen-profiles"
SRC_URI="mirror://ubuntu/pool/main/s/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=""
RDEPEND="app-misc/screen
	sys-devel/gettext
	>=dev-libs/newt-0.52.8"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's/screen.real/screen/g' screen
	sed -i -e 's/usr\/share\/doc\/screen-profiles/usr\/share\/screen-profiles\/doc/g' screen-profiles
}

src_install() {
	newbin screen screen-p
	dobin select-screen-profile screen-profiles screen-launcher motd+shell
	insinto /usr/share/${PN}
	for i in profiles keybindings windows doc ; do
		doins -r ${i}
	done
	exeinto /usr/share/${PN}
	doexe screen-launcher-*
	exeinto /usr/share/${PN}/bin
	doexe bin/*
	doman *.1
	dodoc  README
}
