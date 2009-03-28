# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit mount-boot

MYARCH="x86_64"
KV_NAME="${PN/kernel-}"
KV_NAME="${KV_NAME/-${MYARCH}}"
KV_LOCALVER=""
#KV_LOCALVER="-foo${PV/*_p}"
MYPV="${PV/_p*}"
KV_FULL="${MYPV/_rc/-rc}-${PR}${KV_LOCALVER}"
[[ -z "${PR//r0}" ]] && KV_FULL="${MYPV/_rc/-rc}${KV_LOCALVER}"

DESCRIPTION="Gentoo kernel for ${MYARCH} (${KV_FULL})"
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches"
# Update to reflect your distfiles location
SRC_URI="http://ammo.osuosl.org/distfiles/kernel-${KV_NAME}-${KV_FULL}.${MYARCH}.tbz2
		http://ammo.osuosl.org/distfiles/modules-${KV_NAME}-${KV_FULL}.${MYARCH}.tbz2"

LICENSE="GPL-2"
KEYWORDS="~amd64"
SLOT="${PVR}"
IUSE="+source"

DEPEND=""
RDEPEND="source? ( =sys-kernel/gentoo-sources-${PVR} )"

src_unpack() {
	cd ${WORKDIR}
	mkdir kernel modules
	cd kernel
	unpack kernel-${KV_NAME}-${KV_FULL}.${MYARCH}.tbz2
	cd ../modules
	unpack modules-${KV_NAME}-${KV_FULL}.${MYARCH}.tbz2
	if ! use source ; then
		rm lib/modules/${KV_FULL}/build lib/modules/${KV_FULL}/source
	fi
}

src_install() {
	dodir /boot
	mv ${WORKDIR}/kernel/* ${D}/boot
	mv ${WORKDIR}/modules/* ${D}/
}
