# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mount-boot

MYARCH="x86"
KV_LOCALVER=""
KV_FULL="${PV/_rc/-rc}"
#[[ -z "${PR//r0}" ]] && KV_FULL="${PV}-gentoo${KV_LOCALVER}"

DESCRIPTION="Linux kernel for the eeepc (${KV_FULL})"
HOMEPAGE="http://kernel.org"
# Update to reflect your distfiles location
SRC_URI="http://ammo.osuosl.org/distfiles/kernel-linux-${KV_FULL}.${MYARCH}.tbz2 
		http://ammo.osuosl.org/distfiles/modules-linux-${KV_FULL}.${MYARCH}.tbz2"

LICENSE="GPL-2"
KEYWORDS="x86"
SLOT="${PVR}"
#IUSE="+source"
IUSE=""

DEPEND=""
#RDEPEND="source? ( =sys-kernel/gentoo-sources-${PVR} )"
RDEPEND=""

src_unpack() {
	cd ${WORKDIR}
	mkdir kernel modules
	cd kernel
	unpack kernel-linux-${KV_FULL}.${MYARCH}.tbz2
	cd ../modules
	unpack modules-linux-${KV_FULL}.${MYARCH}.tbz2
}

src_install() {
	dodir /boot
	mv ${WORKDIR}/kernel/* ${D}/boot
	mv ${WORKDIR}/modules/* ${D}/
}
