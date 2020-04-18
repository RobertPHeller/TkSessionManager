/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Sat Apr 18 10:36:08 2020
 *  Last Modified : <200418.1134>
 *
 *  Description	
 *
 *  Notes
 *
 *  History
 *	
 ****************************************************************************
 *
 *    Copyright (C) 2020  Robert Heller D/B/A Deepwoods Software
 *			51 Locke Hill Road
 *			Wendell, MA 01379-9728
 *
 *    This program is free software; you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation; either version 2 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * 
 *
 ****************************************************************************/

/*
 * Some of the code here was lifted from the TclX sources and greatly 
 * simplified -- I could not cross compile TclX and only needed a very small
 * bit of functionallity.
 */

%module SigTrap
%{
static const char rcsid[] = "@(#) : $Id$";

#include <signal.h>

#ifdef __cplusplus
    extern "C" {
#endif
#ifdef MAC_TCL
#pragma export on
#endif
SWIGEXPORT int Sigterm_SafeInit(Tcl_Interp *);
#ifdef MAC_TCL
#pragma export off
#endif
#ifdef __cplusplus
}
#endif

#if defined(__WIN32__) || defined(_WIN32)

#ifndef NO_SIGACTION
#   define NO_SIGACTION
#endif
/*
 * No restartable signals in WIN32.
 */
#ifndef NO_SIG_RESTART
#   define NO_SIG_RESTART
#endif


#else

/*
 * If sigaction is available, check for restartable signals.
 */
#ifndef NO_SIGACTION
#    ifndef SA_RESTART
#        define NO_SIG_RESTART
#    endif
#else
#    define NO_SIG_RESTART
#endif

#endif

#ifndef CONST84
#  define CONST84
#endif

#ifndef RETSIGTYPE
#   define RETSIGTYPE void
#endif

typedef RETSIGTYPE (*signalProcPtr_t) _ANSI_ARGS_((int));

/*
 * Defines if this is not Posix.
 */
#ifndef SIG_BLOCK
#   define SIG_BLOCK       1
#   define SIG_UNBLOCK     2
#endif

/*
 * SunOS has sigaction but uses SA_INTERRUPT rather than SA_RESTART which
 * has the opposite meaning.
 */
#ifndef NO_SIGACTION
#if defined(SA_INTERRUPT) && !defined(SA_RESTART)
#define USE_SA_INTERRUPT
#endif
#endif

static unsigned char signalReceived[32] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

#define true 1
#define false 0
#define bool int

/*-----------------------------------------------------------------------------
 * SignalTrap --
 *
 *   Trap handler
 *-----------------------------------------------------------------------------
 */
static RETSIGTYPE SignalTrap (int signalNum)
{
    signalReceived[signalNum]++;

#ifdef NO_SIGACTION

    if (signal (signalNum, SignalTrap) == SIG_ERR) panic ("SignalTrap bug");

#endif /* NO_SIGACTION */

}

static int sigtrap_setfunct (int sig, signalProcPtr_t sigFunc)
{
#ifndef NO_SIGACTION
    struct sigaction newState;
    
    newState.sa_handler = sigFunc;
    sigfillset(&newState.sa_mask);
    newState.sa_flags = 0;
#ifdef USE_SA_INTERRUPT
    newState.sa_flags |= SA_INTERRUPT;
#endif
    if (sigaction (sig, &newState, NULL) < 0) return false;
    else return true;
#else
    if (signal (sig, sigFunc) == SIG_ERR) return false;
    else return true;
#endif
}

static int sigtrap_catch(int sig) {
  return sigtrap_setfunct (sig, SignalTrap);
}

static int sigtrap_default(int sig) {
  return sigtrap_setfunct (sig, SIG_DFL);
}

static int sigtrap_received(int sig) {
  return signalReceived[sig];
}

static void sigtrap_reset(int sig) {
  signalReceived[sig] = 0;
}

#undef SWIG_name
#define SWIG_name "SigTrap"
#undef SWIG_version
#define SWIG_version "1.0"
%}

%include typemaps.i

bool sigtrap_catch(int sig);

bool sigtrap_default(int sig);

int sigtrap_received(int sig);

void sigtrap_reset(int sig);

/* Signals.  */
#define	SIGHUP		1	/* Hangup (POSIX).  */
#define	SIGINT		2	/* Interrupt (ANSI).  */
#define	SIGQUIT		3	/* Quit (POSIX).  */
#define	SIGILL		4	/* Illegal instruction (ANSI).  */
#define	SIGTRAP		5	/* Trace trap (POSIX).  */
#define	SIGABRT		6	/* Abort (ANSI).  */
#define	SIGIOT		6	/* IOT trap (4.2 BSD).  */
#define	SIGBUS		7	/* BUS error (4.2 BSD).  */
#define	SIGFPE		8	/* Floating-point exception (ANSI).  */
#define	SIGKILL		9	/* Kill, unblockable (POSIX).  */
#define	SIGUSR1		10	/* User-defined signal 1 (POSIX).  */
#define	SIGSEGV		11	/* Segmentation violation (ANSI).  */
#define	SIGUSR2		12	/* User-defined signal 2 (POSIX).  */
#define	SIGPIPE		13	/* Broken pipe (POSIX).  */
#define	SIGALRM		14	/* Alarm clock (POSIX).  */
#define	SIGTERM		15	/* Termination (ANSI).  */
#define	SIGSTKFLT	16	/* Stack fault.  */
#define	SIGCLD		SIGCHLD	/* Same as SIGCHLD (System V).  */
#define	SIGCHLD		17	/* Child status has changed (POSIX).  */
#define	SIGCONT		18	/* Continue (POSIX).  */
#define	SIGSTOP		19	/* Stop, unblockable (POSIX).  */
#define	SIGTSTP		20	/* Keyboard stop (POSIX).  */
#define	SIGTTIN		21	/* Background read from tty (POSIX).  */
#define	SIGTTOU		22	/* Background write to tty (POSIX).  */
#define	SIGURG		23	/* Urgent condition on socket (4.2 BSD).  */
#define	SIGXCPU		24	/* CPU limit exceeded (4.2 BSD).  */
#define	SIGXFSZ		25	/* File size limit exceeded (4.2 BSD).  */
#define	SIGVTALRM	26	/* Virtual alarm clock (4.2 BSD).  */
#define	SIGPROF		27	/* Profiling alarm clock (4.2 BSD).  */
#define	SIGWINCH	28	/* Window size change (4.3 BSD, Sun).  */
#define	SIGPOLL		SIGIO	/* Pollable event occurred (System V).  */
#define	SIGIO		29	/* I/O now possible (4.2 BSD).  */
#define	SIGPWR		30	/* Power failure restart (System V).  */
#define SIGSYS		31	/* Bad system call.  */
#define SIGUNUSED	31



