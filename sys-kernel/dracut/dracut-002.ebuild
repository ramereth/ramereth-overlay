# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils mount-boot

DESCRIPTION="Generic initramfs generation tool"
HOMEPAGE="http://sourceforge.net/projects/dracut/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt dmraid lvm md network selinux"

RDEPEND="app-shells/dash
	>=sys-apps/module-init-tools-3.6
	app-arch/cpio
	sys-apps/coreutils
	sys-apps/findutils
	sys-devel/binutils
	sys-apps/grep
	sys-apps/which
	sys-apps/util-linux
	app-shells/bash
	app-arch/gzip
	app-arch/tar
	sys-fs/e2fsprogs
	sys-apps/file
	app-arch/bzip2
	crypt? ( sys-fs/cryptsetup )
	dmraid? ( sys-fs/dmraid )
	lvm? ( >=sys-fs/lvm2-2.02.33 )
	md? ( sys-fs/mdadm )
	network? ( sys-apps/iproute2 net-misc/dhcp net-misc/bridge-utils
		net-fs/nfs-utils net-nds/rpcbind sys-block/open-iscsi[utils]
		sys-block/nbd )
	selinux? ( sys-libs/libselinux sys-libs/libsepol )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-unmount.patch"
	epatch "${FILESDIR}/${P}-custom-paths.patch"
	epatch "${FILESDIR}/${P}-dir-symlinks.patch"
}

src_compile() {
	emake prefix=/usr sysconfdir=/etc || die "emake failed"
}

src_install() {
	local modules_dir="${D}/usr/share/dracut/modules.d"

	emake prefix=/usr sysconfdir=/etc DESTDIR="${D}" install || die "emake install failed"
	echo "${PF}" > "${modules_dir}"/10rpmversion/dracut-version
	dodir /boot/dracut /var/lib/dracut/overlay
	dodoc HACKING TODO AUTHORS NEWS README*
	# disable modules not enabled by use flags
	for module in crypt dmraid lvm md ; do
		! use ${module} && rm -rf ${modules_dir}/90${module}
	done
	# disable all network modules
	if ! use network ; then
		rm -rf ${modules_dir}/40network
		rm -rf ${modules_dir}/95{iscsi,nbd,nfs,fcoe}
	fi
}

pkg_postinst() {
	elog 'To generate the initramfs:'
	elog ' # mount /boot (if necessary)'
	elog ' # dracut "" <kernel-version>'
	elog ''
	elog 'For command line documentation, see:'
	elog 'http://sourceforge.net/apps/trac/dracut/wiki/commandline'
	elog ''
	elog 'Simple example to select root and resume partition:'
	elog ' root=/dev/???? resume=/dev/????'
	elog ''
	elog 'Configuration is in /etc/dracut.conf.'
	elog 'The default config includes all available disk drivers and'
	elog 'should work on almost any system.'
	elog 'To include only drivers for this system, use the "-H" option.'
}
