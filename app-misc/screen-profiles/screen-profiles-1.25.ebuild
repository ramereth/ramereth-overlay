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
RDEPEND="app-misc/screen"

src_install() {
	newbin screen screen-p
	dobin select-screen-profile screen-profiles screen-launcher motd+shell
	insinto /usr/share/${PN}
	for i in bin profiles keybindings windows ; do
		doins -r ${i}
	done
	doins screen-launcher-*
	doman *.1
	dodoc  README doc/help.txt
}
