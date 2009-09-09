# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit distutils eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://trac.osuosl.org/pydra"
	inherit git
else
	SRC_URI="http://staff.osuosl.org/~peter/myfiles/pydra/${P}.tar.gz"
fi

DESCRIPTION="Pydra is a distributed and parallel computing framework for python"
HOMEPAGE="http://trac.osuosl.org/trac/pydra"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-amd64 -x86"
IUSE="server"

DEPEND="server? ( dev-python/django )
	net-dns/avahi[python]
	dev-python/dbus-python
	dev-python/twisted
	dev-python/twisted-conch
	dev-python/pycrypto
	dev-python/simplejson"
RDEPEND="${DEPEND}"

DOCS="README INSTALL"

pkg_setup() {
	enewgroup pydra
	enewuser pydra -1 -1 -1 pydra
}

src_install() {
	distutils_src_install
	newinitd "${FILESDIR}"/pydra-master.init pydra-master
	newinitd "${FILESDIR}"/pydra-node.init pydra-node

	fowners pydra:pydra /var/lib/pydra
	fowners pydra:pydra /var/log/pydra
}
