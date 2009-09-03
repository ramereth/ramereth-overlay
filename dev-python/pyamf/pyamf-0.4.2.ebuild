# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

MY_PN="PyAMF"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="PyAMF provides Action Message Format (AMF) support for Python"
HOMEPAGE="http://pyamf.org/"
SRC_URI="http://download.pyamf.org/releases/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${MY_P}"
DOCS="CHANGES.txt INSTALL.txt MAINTAINERS.txt THANKS.txt"
