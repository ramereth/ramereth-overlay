# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:$

inherit git

DESCRIPTION="A free, MIT-licensed replacement for pandora's flash player."
HOMEPAGE="http://uint16.ath.cx/software/pandora_client.en.html"
SRC_URI=""
EGIT_REPO_URI="git://github.com/PromyLOPh/pianobar.git"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86"
IUSE="alsa esd network oss pulseaudio"

DEPEND="dev-util/cmake
  media-libs/libao
  net-misc/curl
  media-libs/faad2
  media-libs/libmad
  dev-libs/libxml2"

RDEPEND="alsa? ( media-libs/alsa-lib )
	esd? ( media-sound/esound )
	pulseaudio? ( media-sound/pulseaudio )"

src_compile() {
	cmake \
	  -DCMAKE_INSTALL_PREFIX=/usr \
	  . || die "cmake failed"
	  emake || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS README COPYING
}
