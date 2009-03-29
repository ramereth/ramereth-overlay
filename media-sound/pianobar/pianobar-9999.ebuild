# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils git

DESCRIPTION="A command-line Pandora client"
HOMEPAGE="http://uint16.ath.cx/software/pandora_client.en.html"
SRC_URI=""
EGIT_REPO_URI="git://github.com/PromyLOPh/pianobar.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-util/cmake
	media-libs/libao
	net-misc/curl
	media-libs/faad2
	media-libs/libmad
	dev-libs/libxml2
	sys-libs/readline"
RDEPEND=""

src_compile() {
	cp ${WORKDIR}/${PN}_build/libwardrobe/src/config.h \
		${WORKDIR}/${P}/libwardrobe/src/
	cp ${WORKDIR}/${PN}_build/libpiano/src/config.h \
		${WORKDIR}/${P}/libpiano/src/
	cmake-utils_src_compile
}
