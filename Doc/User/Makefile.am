USERMAN_HS = UserManual.h Preface.h Introduction.h Tutorial.h \
                Reference.h Help.h COPYING.h
USERMAN_FIGS = MainWindowAnnotated.png MenuEditorAnnotated.png \
		CommandPropertiesAnnotated.png \
		CasscadePropertiesAnnotated.png \
		MenuEditor.png
USERMAN = UserManual
USERMAN_PDF = $(USERMAN).pdf
USERMAN_HTML = $(USERMANHBase)/index.html
EXTRA_DIST = $(USERMAN_HS) $(USERMAN_FIGS)

pkgdatadir = $(datadir)/$(PACKAGE)/Doc
pkgdata_DATA = $(USERMAN_PDF)
noinst_DATA  = $(USERMAN_HTML)

CLEANFILES = UserManual.pdf 
	
clean-local:
	-rm -rf $(USERMANHBase) latex

$(USERMAN)_Version.h: $(top_builddir)/config.status
	echo "/** @page Version Version"             >$(USERMAN)_Version.h
	echo " * $(PACKAGE) version is $(VERSION)." >>$(USERMAN)_Version.h
	echo " */"                                  >>$(USERMAN)_Version.h

latex $(USERMAN_HTML): $(USERMAN_HS) $(USERMAN_FIGS) $(USERMAN)_Version.h \
	Doxyfile
	doxygen Doxyfile
	

$(USERMAN_PDF) : latex
	$(MAKE) -C latex
	mv latex/refman.pdf ./$(USERMAN_PDF)
	


	






