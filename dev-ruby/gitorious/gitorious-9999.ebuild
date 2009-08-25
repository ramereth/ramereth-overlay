# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git

DESCRIPTION="Gitorious aims to provide a great way of doing distributed
opensource code collaboration."
HOMEPAGE="http://gitorious.org/projects/gitorious"
SRC_URI=""

LICENSE="AGPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-ruby/oniguruma
		app-misc/sphinx
		dev-db/mysql
		media-gfx/imagemagick
		dev-ruby/bluecloth
		dev-ruby/mime-types
		dev-ruby/textpow
		dev-ruby/rmagick
		dev-ruby/net-geoip
		dev-ruby/ruby-openid
		dev-ruby/ruby-yadis
		dev-ruby/chronic
		dev-ruby/ultrasphinx"
RDEPEND="${DEPEND}"

EGIT_REPO_URI="git://gitorious.org/gitorious/mainline.git"
EGIT_BRANCH="master"

pkg_setup() {
	enewgroup gitorious
	enewuser gitorious -1 /bin/bash /var/lib/gitorious gitorious
}

src_install() {
	insinto /usr/share/${PN}
	cp -r "${S}"/* "${D}"/usr/share/${PN}
}
