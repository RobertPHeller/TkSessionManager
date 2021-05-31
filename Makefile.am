ACLOCAL_AMFLAGS = -I m4

SUBDIRS = BuildData BuildScripts Doc Scripts SigTrap glib_tcl glib_schema


EXTRA_DIST = bootstrap Doxyfile.in TkSessionManager.desktop

TCLKIT = $(top_builddir)/BuildData/tclkit${BEXEEXT}

BUILT_SOURCES = $(TCLKIT)

bin_SCRIPTS = TkSessionManager$(EXEEXT)

CLEANFILES = $(bin_SCRIPTS)

man_MANS = man1/TkSessionManager.1

desktopdir = $(datadir)/xsessions
desktop_DATA = TkSessionManager.desktop

AllScripts = $(wildcard $(top_srcdir)/Scripts/*.tcl) $(wildcard Scripts/*.tcl)
LibScripts = $(filter-out %TkSessionManager.tcl,$(AllScripts))
AllImages  = $(wildcard $(top_srcdir)/Scripts/*.gif) \
		$(wildcard $(top_srcdir)/Scripts/*.png)
AllHelpDep = Doc/User/UserManual/UserManual.html
AllHelpFiles = $(wildcard Doc/User/UserManual/*)

TkSessionManager$(EXEEXT): $(AllScripts) $(AllImages) $(AllHelpDep) \
	SigTrap/sigtrap.la SigTrap/pkgIndex.tcl \
	glib_tcl/glib_tcl.la glib_tcl/pkgIndex.tcl
	-rm -rf TkSessionManager.vfs
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit qwrap \
			$(srcdir)/Scripts/TkSessionManager.tcl
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit unwrap TkSessionManager.kit
	-rm -rf TkSessionManager.kit
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit TkSessionManager \
		lib $(SNITLIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitDir.kit TkSessionManager \
		lib $(BWLIB)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
		TkSessionManager lib/Common $(LibScripts)
	$(TCLKIT) $(top_srcdir)/BuildScripts/MakePkgIndex.kit TkSessionManager \
		Common
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
		TkSessionManager lib/SigTrap \
		SigTrap/pkgIndex.tcl SigTrap/.libs/sigtrap$(SHLIB_SUFFIX)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
		TkSessionManager lib/GlibTcl \
		glib_tcl/pkgIndex.tcl glib_tcl/.libs/glib_tcl$(SHLIB_SUFFIX)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
		TkSessionManager Images $(AllImages)
	$(TCLKIT) $(top_srcdir)/BuildScripts/AddKitFile.kit -srcdir $(srcdir) \
		TkSessionManager Help $(AllHelpFiles)
	$(TCLKIT) $(top_srcdir)/BuildScripts/sdx.kit wrap \
		TkSessionManager$(EXEEXT) \
		-runtime $(top_srcdir)/BuildData/$(TCLKITRUN)
	-rm -rf TkSessionManager.vfs TkSessionManager.kit

$(top_builddir)/BuildData/tclkit${BEXEEXT}: FORCE
	$(MAKE) -C $(top_builddir)/BuildData tclkit${BEXEEXT}

$(top_builddir)/Scripts/Version.tcl: $(top_builddir)/config.status
	$(MAKE) -C $(top_builddir)/Scripts Version.tcl

FORCE:

Doc/User/UserManual/UserManual.html: FORCE
	$(MAKE) -C $(top_builddir)/Doc/User UserManual/UserManual.html


man1/TkSessionManager.1 : Doxyfile Scripts/TkSessionManager.tcl
	-rm -rf man1
	$(DOXYGEN)

SigTrap/sigtrap.la : FORCE
	$(MAKE) -C $(top_builddir)/SigTrap sigtrap.la

SigTrap/pkgIndex.tcl : FORCE
	$(MAKE) -C $(top_builddir)/SigTrap pkgIndex.tcl

glib_tcl/glib_tcl.la : FORCE
	$(MAKE) -C $(top_builddir)/glib_tcl glib_tcl.la

glib_tcl/pkgIndex.tcl : FORCE
	$(MAKE) -C $(top_builddir)/glib_tcl pkgIndex.tcl

clean-local:
	-rm -rf man1
