# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/ganeti/ganeti-2.4.1.ebuild,v 1.1 2011/03/09 18:20:00 ramereth Exp $

EAPI="3"

inherit eutils confutils bash-completion

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.ganeti.org/ganeti.git"
	inherit git
	KEYWORDS=""
	# you will need to pull in the haskell overlay for pandoc
	GIT_DEPEND="app-text/pandoc
		dev-python/docutils
		dev-python/sphinx
		media-libs/gd[fontconfig,jpeg,png,truetype]
		media-gfx/graphviz
		media-fonts/urw-fonts"
else
	SRC_URI="http://ganeti.googlecode.com/files/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

MY_PV="${PV/_rc/~rc}"
#MY_PV="${PV/_beta/~beta}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="Ganeti is a virtual server management software tool"
HOMEPAGE="http://code.google.com/p/ganeti/"

LICENSE="GPL-2"
SLOT="0"
IUSE="kvm xen drbd +filestorage sharedstorage htools syslog ipv6"

S="${WORKDIR}/${MY_P}"

DEPEND="xen? ( >=app-emulation/xen-3.0 )
	kvm? ( app-emulation/qemu-kvm )
	drbd? ( >=sys-cluster/drbd-8.3 )
	ipv6? ( net-misc/ndisc6 )
	htools? (
		dev-lang/ghc
		dev-haskell/json
		dev-haskell/curl
		dev-haskell/network
		dev-haskell/parallel )
	dev-libs/openssl
	dev-python/paramiko
	dev-python/pyopenssl
	dev-python/pyparsing
	dev-python/pycurl
	dev-python/pyinotify
	dev-python/simplejson
	net-analyzer/arping
	net-misc/bridge-utils
	net-misc/curl[ssl]
	net-misc/openssh
	net-misc/socat
	sys-apps/iproute2
	sys-fs/lvm2
	${GIT_DEPEND}"
RDEPEND="${DEPEND}
	!app-emulation/ganeti-htools"

pkg_setup () {
	confutils_require_any kvm xen
}

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git_src_unpack
	else
		unpack ${A}
	fi
}

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		./autogen.sh
	fi
}

src_configure () {
	local myconf
	if use filestorage ; then
		myconf="--with-file-storage-dir=/var/lib/ganeti-storage/file"
	else
		myconf="--with-file-storage-dir=no"
	fi
	if use sharedstorage ; then
		myconf="--with-shared-file-storage-dir=/var/lib/ganeti-storage/shared"
	else
		myconf="--with-shared-file-storage-dir=no"
	fi
	econf --localstatedir=/var \
		--docdir=/usr/share/doc/${P} \
		--with-ssh-initscript=/etc/init.d/sshd \
		--with-export-dir=/var/lib/ganeti-storage/export \
		--with-os-search-path=/usr/share/ganeti/os \
		$(use_enable syslog) \
		$(use_enable htools) \
		$(use_enable htools htools-rapi) \
		${myconf}
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	newinitd "${FILESDIR}"/ganeti-2.1.initd ganeti
	newconfd "${FILESDIR}"/ganeti.confd ganeti
	use kvm && newinitd "${FILESDIR}"/ganeti-kvm-poweroff.initd ganeti-kvm-poweroff
	use kvm && newconfd "${FILESDIR}"/ganeti-kvm-poweroff.confd ganeti-kvm-poweroff
	dobashcompletion doc/examples/bash_completion ganeti
	dodoc INSTALL UPGRADE NEWS README doc/*.rst
	rm -rf "${D}"/usr/share/doc/ganeti
	docinto examples
	#dodoc doc/examples/{basic-oob,ganeti.cron,gnt-config-backup}
	dodoc doc/examples/{ganeti.cron,gnt-config-backup}
	docinto examples/hooks
	dodoc doc/examples/hooks/{ipsec,ethers}

	keepdir /var/{lib,log,run}/ganeti/
	keepdir /usr/share/ganeti/os/
	keepdir /var/lib/ganeti-storage/{export,file,shared}/
}

pkg_postinst () {
	bash-completion_pkg_postinst
}
