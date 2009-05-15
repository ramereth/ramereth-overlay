# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="cmdln.py fixes some of the design flaws in cmd.py and takes
advantage of new Python stdlib modules"
HOMEPAGE="http://code.google.com/p/cmdln/"
SRC_URI="http://cmdln.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DOCS="TODO.txt"

src_install() {
	distutils_src_install
	docinto examples
	dodoc examples/*
	docinto docs
	dodoc docs/*
}
