# TkSessionManager

This program is an X11 Session Manager program.  It is started as the
last or only  command in a .xinitrc or .xsession script file.  It
provides a user definable menu of commands to be launched.  It also 
provides a text area that can be used for (electronic) note taking.  
The contents of the text area can be edited, saved, cleared, copied to
the X11 copy buffer, and printed.

## Session Startup

It does the following on startup:
 1. Creates a pipe in /tmp that it reads text from.  This text is
    displayed on the Session Manager's text area. This pipe is also
    bound to stdout and stderr of the processes launched by from the
    user defined menu.
 2. Starts up the window manager.
 3. Optionally starts a panel
 4.  Runs a session script which launches an initial set of programs.

The configuration is in the GLIB database.  The Schema is 
 org.tk.sessionmanager.  The preferences keys are:


 - __main-title__
	Specifies the main title.  The default is "TK Session Manager".
 - __main-geometry__
	Specifies the size and placement of the session manager window.
	The default is to use the natural size and to center the window
	on the screen.
 -  __menu-filename__
	Specifies the name of the file containing the commands menu.
	The default is `$HOME/tkSessionManager.menu`.
 - __print-command__
	Specifies the command to use to print the contents of the
	session manager's text area.  Should be a command that can take
	a plain text stream on its stdin. Defaults to lp or lpr.
 - __pipe-name-suffix__
	Specifies the name of the pipe created in the /tmp directory.
	Text written to this pipe is displayed on the session manager's
	text area.  The default is `${USER}_TkSessionManager`.
 - __window-manager__
	Specifies the path to the window manager program to start. 
	Defaults to /usr/bin/fvwm.
 - __session-script__
	Session startup script to run.  This stript contains the
	commands to start up the initial set of processes for the user's
	session. The default is `$HOME/tkSessionManager.session`.
 - __panel__
       The name of a panel program to run.
 - __text-font__
       The text font to use.
 - __background-color__
       The background color
 - __foreground-color__
       The foreground color
 - __border-color__
       The border color
 - __icon-name__
       The icon name to use

I wrote this program as a replacement for the DECWindows session manager
that was included with the VAX/VMS DECWindows installation.  It is
written entirely in Tcl/Tk, making use of the standard packages,
BWidget, SNIT, and Img.

## Building 

Building it should be trivial (Tcl/Tk (-devel packages), BWIDGET, dbus-glib-1,
glib-2.0, gio-2.0, Tcllib, doxygen,  need to be installed for
building from source):

```
./bootstrap
./configure
make
make install
```
It uses tclkit technology to create a standalong native executable, so
once built, it is not necessary for Tcl/Tk to be installed on a target
system.  It is possible to built a 32-bit Linux executable on a 64-bit
machine (useful if you have 32-bit target systems).

## Menu File

The menu file consists of pairs of lines, the menu item text and the
command to run (which should be something suitable as an argument list
to the Tcl exec command).  Lines starting with a ! are comments and
ignored. A casscade is introduced by using a '{' at the beginning of the
menu item text.  Lines are processed as menu items under the casscade
name until a lone '}' on a line by itself.  Casscades can occur under
casscades.  There is no set limit to the depth casscades can go.

## Session Script

The Session Script file is a normal script or program to run at startup.
Generally, it will be a series of commands that start up X11 programs. 
Each command should end in a '&', so that the programs are forked into
the background.  The script should be allowed to run to completion after
forking all of the programs.
