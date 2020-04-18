dnl Process this file with autoconf to produce a configure script.
AC_INIT(Scripts/TkSessionManager.tcl)
AC_CONFIG_MACRO_DIR([m4])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SUBST(build)
AC_CANONICAL_TARGET
AC_SUBST(target)

AM_INIT_AUTOMAKE([TkSessionManager],1.0.4)
if test "x${prefix}" = "xNONE"; then
    prefix=/usr/local
fi
if test "x${exec_prefix}" = "xNONE"; then
    exec_prefix="${prefix}"
fi
PACKAGE_NAME="TkSessionManager"

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
m4_pattern_allow(PKG_)

TEA_INIT([3.5])
TEA_PATH_TCLCONFIG
TEA_LOAD_TCLCONFIG
TEA_PROG_TCLSH
TEA_ENABLE_SHARED
TEA_CONFIG_SYSTEM
TEA_CONFIG_CFLAGS
TEA_PUBLIC_TCL_HEADERS
AC_SUBST(SHLIB_SUFFIX)
AX_PKG_SWIG(1.3)
AC_LIBTOOL_DLOPEN
AM_PROG_LIBTOOL

AC_PATH_PROGS(HOSTTCLSH,[tclsh8.4 tclsh])

AX_BWIDGET
AX_SNIT

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
      arm*)
        AC_SUBST(IMG_ZIP, Img-1.3-Linuxarmv7l.zip)
        AC_SUBST(TCLKITRUN, tclkit-linux-armv7l)
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
      arm*)
        AC_SUBST(TCLKITBSRC, tclkit-linux-armv7l)
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
          SigTrap/Makefile \
	  Doxyfile
	  )






