dnl Process this file with autoconf to produce a configure script.
AC_INIT(Scripts/TkSessionManager.tcl)

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SUBST(build)
AC_CANONICAL_TARGET
AC_SUBST(target)

AM_INIT_AUTOMAKE([TkSessionManager],1.0.0)

if test "x${prefix}" = "xNONE"; then
    prefix=/usr/local
fi
if test "x${exec_prefix}" = "xNONE"; then
    exec_prefix="${prefix}"
fi

dnl Force cross_compiling, even if it *looks* like we can run cross-built 
dnl binaries (get around wine's cleverness).
if test ${cross_compiling} = "maybe"; then
  if test ${target_os} != ${build_os}; then
    cross_compiling=yes
  fi
fi  

BUILD_DIR=`pwd`
TOP_DIR=${BUILD_DIR}

AC_SUBST(TOP_DIR)
AC_SUBST(BUILD_DIR)
srcdir=`dirname $0`
cd $srcdir
SRC_DIR=`pwd`
cd $BUILD_DIR

AC_SUBST(SRC_DIR)


AC_PATH_PROG(DOXYGEN,doxygen,/bin/true)
AC_PATH_PROG(PDFLATEX,pdflatex,/bin/true)
AC_PATH_PROGS(HTLATEX,[htlatex htlatex.sh],/bin/true)
AC_PATH_PROG(LATEX,latex,/bin/true)
AC_PATH_PROG(MAKEINDEX,makeindex,/bin/true)
AC_PATH_PROG(BIBTEX,bibtex,/bin/true)
AC_PATH_PROG(DVIPS,dvips,/bin/true)
AC_PATH_PROG(PS2PDF,ps2pdf,/bin/true)

AC_PATH_PROGS(HOSTTCLSH,[tclsh8.4 tclsh])

AC_MSG_CHECKING(bwidget dir)
BWLIB=`echo 'puts $tcl_library'|${HOSTTCLSH}`
dirs="${TCL_PREFIX}/lib/bwidget* ${TCL_PREFIX}/lib/tcllib*/bwidget* ${BWLIB}/bwidget* ${BWLIB}/../tcllib*/bwidget* ${BWLIB}/../bwidget* ${BWLIB}/tcllib*/bwidget*"
for i in $dirs ; do
  if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
    BWLIB=`cd $i; pwd`
  fi
done
AC_ARG_WITH(bwlib, [  --with-bwlib=DIR          use BWidget from DIR], BWLIB=$withval,)
if test -d $BWLIB; then
   AC_MSG_RESULT([using BWidget library in $BWLIB])
else
   AC_MSG_ERROR(BWidget library directory $BWLIB doesn't exist)
fi
AC_SUBST(BWLIB)

AC_MSG_CHECKING(snit dir)
SNITLIB=`echo 'puts $tcl_library'|${HOSTTCLSH}`

dirs="${TCL_PREFIX}/lib/snit* ${TCL_PREFIX}/lib/tcllib*/snit* ${SNITLIB}/../tcllib*/snit* ${SNITLIB}/../snit* ${SNITLIB}/tcllib*/snit* ${SNITLIB}/snit*"
for i in $dirs ; do
  if test -d "$i" -a -f "$i/pkgIndex.tcl"; then
    SNITLIB=`cd $i; pwd`
  fi
done
AC_ARG_WITH(snitlib, [  --with-snitlib=DIR          use snit from DIR], SNITLIB=$withval,)
if test -d $SNITLIB; then
   AC_MSG_RESULT([using snit library in $SNITLIB])
else
   AC_MSG_ERROR(Snit library directory $SNITLIB doesn't exist)
fi
AC_SUBST(SNITLIB)


AC_PATH_PROGS(UNZIP,unzip)

AC_MSG_CHECKING([Checking target Img and tclkit])
case $target_os in 
  macos | darwin) 
    AC_SUBST(IMG_ZIP, Img-1.3-Mac-Universal.zip)
    AC_SUBST(TCLKITRUN, tclkit-darwin-univ-aqua)
    ;;
  linux-gnu)
    case $target_cpu in
      x86_64)
	AC_SUBST(IMG_ZIP, Img-1.3-Linux64.zip)
	AC_SUBST(TCLKITRUN, tclkit-linux-x86_64)
	;;
      i*86)
	AC_SUBST(IMG_ZIP, Img-1.3-Linux32.zip)
	AC_SUBST(TCLKITRUN, tclkit-linux-x86)
	;;
      *)
	AC_MSG_ERROR([Unsupported Linux arch: $target_cpu])
	;;
     esac
     ;;

   mingw32 | winnt | windows* | cygwin)
     AC_SUBST(IMG_ZIP, Img-1.3-win32.zip)
     AC_SUBST(TCLKITRUN, tclkit-win32.exe)
     AC_SUBST(EXEEXT, .exe)
     ;;
   *) 
     AC_MSG_ERROR([Unsupported Operating System: $target_os])
     ;;
esac
AC_MSG_RESULT([IMG_ZIP is $IMG_ZIP and TCLKITRUN is $TCLKITRUN])


AC_MSG_CHECKING([Checking build tclkit])
case $build_os in 
  macos | darwin) 
    AC_SUBST(TCLKITBSRC, tclkit-darwin-univ-aqua)
    AC_SUBST(BEXEEXT, )
    ;;
  linux-gnu)
    AC_SUBST(BEXEEXT, )
    case $build_cpu in
      x86_64)
	AC_SUBST(TCLKITBSRC, tclkit-linux-x86_64)
	;;
      i*86)
	AC_SUBST(TCLKITBSRC, tclkit-linux-x86)
	;;
      *)
	AC_MSG_ERROR([Unsupported Linux arch: $build_cpu])
	;;
     esac
     ;;

   mingw32 | winnt | windows* | cygwin)
     AC_SUBST(BEXEEXT, .exe)
     AC_SUBST(TCLKITBSRC, tclkit-win32.exe)
     ;;
   *) 
     AC_MSG_ERROR([Unsupported Operating System: $build_os])
     ;;
esac
AC_MSG_RESULT([TCLKITBSRC is $TCLKITBSRC])

AC_PATH_PROG(SED,sed)

dnl Substitutions...

SYSTEMVERSION="$VERSION"
AC_SUBST(SYSTEMVERSION)

AM_CONDITIONAL(CROSSCOMPILING,test ${cross_compiling} = "yes")

AC_OUTPUT(Makefile \
	  BuildScripts/Makefile \
	  BuildData/Makefile \
	  Scripts/Makefile \
	  Doc/Makefile \
		Doc/Support/Makefile \
		Doc/User/Makefile
	  Doxyfile
	  )






