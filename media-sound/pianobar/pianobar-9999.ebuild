# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

EAPI=3

inherit git

DESCRIPTION="A free, MIT-licensed replacement for pandora's flash player."
HOMEPAGE="http://uint16.ath.cx/software/pandora_client.en.html"
SRC_URI=""
EGIT_REPO_URI="git://github.com/PromyLOPh/pianobar.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa esd pulseaudio +mad +faad"

DEPEND="media-libs/libao
	net-misc/curl
	faad? ( media-libs/faad2 )
	mad? ( media-libs/libmad )
	dev-libs/libxml2"

RDEPEND="alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )"

src_prepare() {
	sed -i -e 's/^PREFIX.*/PREFIX\:=\/usr/g' Makefile
}

src_compile() {
	local make_opts=""
	use mad && make_opts="$make_opts DISABLE_MAD=1"
	use faad && make_opts="$make_opts DISABLE_FAAD=1"

	emake ${make_opts} || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README INSTALL
	docinto contrib
	dodoc contrib/*
}
