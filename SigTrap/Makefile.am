##-*- makefile -*-############################################################
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sat Apr 18 10:24:09 2020
#  Last Modified : <200630.1807>
#
#  Description	
#
#  Notes
#
#  History
#	
#  $Log$
#
##############################################################################
#
#    Copyright (C) 2020  Robert Heller D/B/A Deepwoods Software
#			51 Locke Hill Road
#			Wendell, MA 01379-9728
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# 
#
##############################################################################

xlibdir = $(libdir)/$(PACKAGE)/SigTrapNotInstalled
xlib_LTLIBRARIES = sigtrap.la
INCLUDES =  $(TCL_INCLUDES)
sigtrap_la_SOURCES = sigtrap.c
sigtrap_la_CFLAGS =  -DUSE_TCL_STUBS $(INCLUDES) $(DEFS) -Wall -g
sigtrap_la_LDFLAGS = -g -module -avoid-version $(TCL_STUB_LIB_SPEC)
sigtrap_la_LIBADD = $(TCL_STUB_LIB_SPEC)
SWIG_FLAGS =  -tcl8  $(INCLUDES)
EXTRA_DIST = sigtrap.i
BUILT_SOURCES       = sigtrap.c

sigtrap.c : sigtrap.i
	$(SWIG) $(SWIG_FLAGS) $(INCLUDES) -o sigtrap.c $(srcdir)/sigtrap.i
	
pkgIndex.tcl: sigtrap.la $(top_builddir)/config.status
	echo 'package ifneeded SigTrap 1.0 [list load [file join $$dir sigtrap[info sharedlibextension]]]' > pkgIndex.tcl

install-data-hook:
	-rm -rf $(DESTDIR)$(xlibdir)

	

