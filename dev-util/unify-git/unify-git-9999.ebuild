# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git distutils

EGIT_REPO_URI="git://trac.osuosl.org/unify.git"

DESCRIPTION="Unified package building for rpm, deb, and solaris packages"
HOMEPAGE="http://trac.osuosl.org/unify"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/pkgcore
	dev-python/snakeoil
	app-arch/rpm
	dev-python/ctypes
	dev-util/debootstrap
	>=sys-apps/yum-3.2.19"
RDEPEND="${DEPEND}"

src_unpack() {
	git_src_unpack
}
