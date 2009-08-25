# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit ruby gems

DESCRIPTION=" Ruby on Rails configurator and client to the Sphinx fulltext
search engine"
HOMEPAGE="http://blog.evanweaver.com/files/doc/fauna/ultrasphinx"

LICENSE="AFL-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-ruby/chronic"
RDEPEND="${DEPEND}"

