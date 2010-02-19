SUFFIXES        = .tcl .sty
USERMAN_TEXS = UserManual.tex Preface.tex Introduction.tex Tutorial.tex \
                Reference.tex Help.tex COPYING.tex
USERMAN_FIGS = PreferencesEditor.png MenuEditor.png MainWindowAnnotated.png \
		MenuEditorAnnotated.png CommandPropertiesAnnotated.png \
		CasscadePropertiesAnnotated.png PreferencesEditorAnnotated.png
USERMAN = UserManual
USERMAN_PDF = $(USERMAN).pdf
USERMANHBase = UserManual
USERMAN_HTML = $(USERMANHBase)/$(USERMAN).html
EXTRA_DIST = $(USERMAN_TEXS) $(USERMAN_FIGS) MyTitlepage.sty

pkgdatadir = $(datadir)/$(PACKAGE)/Doc
pkgdata_DATA = $(USERMAN_PDF)
noinst_DATA  = $(USERMAN_HTML)

CLEANFILES = UserManual.pdf *.aux *.bbl *.blg *.idx *.ilg \
	*.ind *.lof *.lot *.lol *.toc *.css UserManual

$(USERMAN)_Version.tex : $(top_builddir)/config.status
	echo '\chapter*{Version}'               >$(USERMAN)_Version.tex
	echo '\addcontentsline{toc}{chapter}{Version}' >>$(USERMAN)_Version.tex
	echo '\markboth{Version}{Version}'      >>$(USERMAN)_Version.tex
	echo "$(PACKAGE) version is $(VERSION).\\\\" >>$(USERMAN)_Version.tex

$(USERMAN_PDF) : $(USERMAN_TEXS) $(USERMAN_FIGS) $(USERMAN)_Version.tex \
	MyTitlepage.sty 
	for f in $(USERMAN_TEXS) $(USERMAN_FIGS) MyTitlepage.sty; do \
	  if test -f "./$$f"; then continue; else ln -s $(srcdir)/$$f ./; fi; \
	done
	$(PDFLATEX) $(USERMAN)
	echo '\begin{theindex}' > $(USERMAN).ind
	echo '\item Dummy, 0' >> $(USERMAN).ind
	echo '\end{theindex}' >> $(USERMAN).ind
	$(PDFLATEX) $(USERMAN)
	$(MAKEINDEX) $(USERMAN).idx
	$(PDFLATEX) $(USERMAN)

$(USERMAN_HTML) : $(USERMAN_PDF)
	-rm -rf $(USERMANHBase)
	-mkdir $(USERMANHBase)
	$(HTLATEX) $(USERMAN) "html,2,info" "" "-d$(USERMANHBase)/"
	(cd $(USERMANHBase)&&ln -s ../*.png ./)
	-rm -f zz$(USERMAN).p* $(USERMAN).4ct $(USERMAN).xref \
		$(USERMAN).4tc tex4ht.fls $(USERMAN).tmp $(USERMAN).lg \
		$(USERMAN).idv $(USERMAN).dvi $(USERMAN)*.html







EXTRA_DIST = MyTitlepage.sty
