dnl Process this file with autoconf to produce a configure script.
AC_INIT
AC_CONFIG_SRCDIR([Scripts/TkSessionManager.tcl])
AC_CONFIG_MACRO_DIR([m4])

AC_CANONICAL_BUILD
AC_CANONICAL_HOST
AC_SUBST(build)
AC_CANONICAL_TARGET
AC_SUBST(target)

AM_INIT_AUTOMAKE([TkSessionManager],1.1.2)
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
_LT_SET_OPTION([LT_INIT],[dlopen])
m4_warn([obsolete],[_LT_SET_OPTION([LT_INIT],[dlopen])
m4_warn([obsolete],[AC_LIBTOOL_DLOPEN: Remove this warning and the call to _LT_SET_OPTION when you
put the 'dlopen' option into LT_INIT's first parameter.])
: Remove this warning and the call to _LT_SET_OPTION when you
put the 'dlopen' option into LT_INIT's first parameter.])

LT_INIT

AC_PATH_PROGS(HOSTTCLSH,[tclsh8.6 tclsh])

AX_BWIDGET
AX_SNIT

PKG_PROG_PKG_CONFIG()
PKG_CHECK_MODULES([DBUS_GLIB], dbus-glib-1)
PKG_CHECK_MODULES([GLIB2], glib-2.0)
PKG_CHECK_MODULES([GIO2], gio-2.0)
_PKG_CONFIG([GIO2_INCLUDES], [cflags-only-I], gio-2.0)
AC_SUBST([GIO2_INCLUDES],$pkg_cv_GIO2_INCLUDES)
GLIB_GSETTINGS

AC_PATH_PROGS(UNZIP,unzip)

AC_MSG_CHECKING([Checking target Img and tclkit])
case $target_os in 
  linux-gnu*)
    case $target_cpu in
      x86_64)
        AC_SUBST(TCLKITRUN, [tclkit-8.6.11-x86_64-Img1.4.7])
	;;
      i*86)
	AC_SUBST(TCLKITRUN, [tclkit-8.6.11-i386-Img1.4.7])
	;;
      arm*)
        AC_SUBST(TCLKITRUN, [tclkit-8.6.11-armv7l-Img1.4.8])
        ;;
      aarch64)
        AC_SUBST(TCLKITRUN, [tclkit-8.6.10-aarch64-Img1.4.14])
        ;;
      *)
	AC_MSG_ERROR([Unsupported Linux arch: $target_cpu])
	;;
     esac
     ;;

   *) 
     AC_MSG_ERROR([Unsupported Operating System: $target_os])
     ;;
esac
AC_MSG_RESULT([TCLKITRUN is $TCLKITRUN])


AC_MSG_CHECKING([Checking build tclkit])
case $build_os in 
  linux-gnu*)
    AC_SUBST(BEXEEXT, )
    case $build_cpu in
      x86_64)
	AC_SUBST(TCLKITBSRC, [tclkit-8.6.11-x86_64-Img1.4.7])
	;;
      i*86)
	AC_SUBST(TCLKITBSRC, [tclkit-8.6.11-i386-Img1.4.7])
	;;
      arm*)
        AC_SUBST(TCLKITBSRC, [tclkit-8.6.11-armv7l-Img1.4.8])
        ;;
      aarch64)
        AC_SUBST(TCLKITBSRC, [tclkit-8.6.10-aarch64-Img1.4.14])
        ;;
      *)
	AC_MSG_ERROR([Unsupported Linux arch: $build_cpu])
	;;
     esac
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

AC_CONFIG_FILES([Makefile \
	  BuildScripts/Makefile \
	  BuildData/Makefile \
	  Scripts/Makefile \
	  Doc/Makefile \
		Doc/Support/Makefile \
		Doc/User/Makefile \
		Doc/User/Doxyfile \
          SigTrap/Makefile \
          glib_tcl/Makefile \
          glib_schema/Makefile \
          glib_schema/org.tk.sessionmanager.gschema.xml \
	  Doxyfile
	  ])
AC_OUTPUT






