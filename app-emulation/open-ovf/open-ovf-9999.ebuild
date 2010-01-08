# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit git distutils

DESCRIPTION="Library and tools for working with the virtual machines described
in the Open Virtualization Format"
HOMEPAGE="http://open-ovf.sourceforge.net"
SRC_URI=""
EGIT_REPO_URI="git://gitorious.org/open-ovf/mainline.git"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="dev-libs/libxml2[python]"

DOCS="README CONTRIBUTING"

src_unpack() {
	git_src_unpack
}

src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}
	if use examples; then
		doins -r examples || die
		doins -r schemas || die
	fi
}
