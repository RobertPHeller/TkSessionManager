Scripts = $(filter-out Version.tcl $(wildcard *.tcl))
Images  = DeepwoodsBanner.gif

BUILT_SOURCES = Version.tcl
noinst_DATA = Version.tcl

EXTRA_DIST = $(Scripts) $(Images)

TCLKIT = $(top_builddir)/BuildData/tclkit${BEXEEXT}

BUILT_SOURCES += $(TCLKIT)


CLEANFILES = Version.tcl

Version.tcl : $(top_builddir)/config.status 
	$(TCLKIT) $(top_srcdir)/BuildScripts/MakeVersion.kit \
		$(PACKAGE) $(VERSION)
		


$(top_builddir)/BuildData/tclkit${BEXEEXT}: FORCE
	$(MAKE) -C $(top_builddir)/BuildData tclkit${BEXEEXT}

FORCE:


