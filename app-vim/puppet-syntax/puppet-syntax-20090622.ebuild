# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

inherit vim-plugin

DESCRIPTION="vim plugin: Puppet configuration files syntax"
HOMEPAGE="http://reductivelabs.com/downloads/puppet/puppet.vim"
LICENSE="as-is"
KEYWORDS=""
IUSE=""
SRC_URI="http://staff.osuosl.org/~ramereth/projects/puppet-syntax/${P}.tar.bz2"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Puppet configuration
files. Detection is by filename (*.pp)."
