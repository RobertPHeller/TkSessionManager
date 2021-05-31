##-*- makefile -*-############################################################
#
#  System        : 
#  Module        : 
#  Object Name   : $RCSfile$
#  Revision      : $Revision$
#  Date          : $Date$
#  Author        : $Author$
#  Created By    : Robert Heller
#  Created       : Sun May 30 18:00:04 2021
#  Last Modified : <210531.1054>
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
#    Copyright (C) 2021  Robert Heller D/B/A Deepwoods Software
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


xlibdir = $(libdir)/$(PACKAGE)/glib_tclNotInstalled
xlib_LTLIBRARIES = glib_tcl.la
INCLUDES =  $(TCL_INCLUDES) 
glib_tcl_la_SOURCES = glib_tcl.c
glib_tcl_la_CFLAGS =  -DUSE_TCL_STUBS $(INCLUDES) $(DEFS) $(GIO2_CFLAGS) \
			$(GLIB2_CFLAGS) $(DBUS_GLIB_CFLAGS) -Wall -g
glib_tcl_la_LDFLAGS = -g -module -avoid-version $(TCL_STUB_LIB_SPEC)
glib_tcl_la_LIBADD = $(TCL_STUB_LIB_SPEC) $(GIO2_LIBS) $(GLIB2_LIBS) \
			$(DBUS_GLIB_LIBS)
SWIG_FLAGS =  -tcl8  $(INCLUDES) $(GIO2_INCLUDES) \
		$(GLIB2_CFLAGS) $(DBUS_GLIB_CFLAGS)
EXTRA_DIST = glib_tcl.i
BUILT_SOURCES = glib_tcl.c
glib_tcl.c : glib_tcl.i
	$(SWIG) $(SWIG_FLAGS) $(INCLUDES) -o glib_tcl.c $(srcdir)/glib_tcl.i

pkgIndex.tcl: glib_tcl.la $(top_builddir)/config.status
	echo 'package ifneeded GlibTcl 1.0 [list load [file join $$dir glib_tcl[info sharedlibextension]] Glibtcl]' > pkgIndex.tcl

install-data-hook:
	-rm -rf $(DESTDIR)$(xlibdir)

	
