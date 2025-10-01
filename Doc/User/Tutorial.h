// -!- C++ -!- //////////////////////////////////////////////////////////////
//
//  System        : 
//  Module        : 
//  Object Name   : $RCSfile$
//  Revision      : $Revision$
//  Date          : $Date$
//  Author        : $Author$
//  Created By    : Robert Heller
//  Created       : 2025-09-30 20:29:53
//  Last Modified : <251001.0825>
//
//  Description	
//
//  Notes
//
//  History
//	
/////////////////////////////////////////////////////////////////////////////
/// @copyright
///    Copyright (C) 2025  Robert Heller D/B/A Deepwoods Software
///			51 Locke Hill Road
///			Wendell, MA 01379-9728
///
///    This program is free software; you can redistribute it and/or modify
///    it under the terms of the GNU General Public License as published by
///    the Free Software Foundation; either version 2 of the License, or
///    (at your option) any later version.
///
///    This program is distributed in the hope that it will be useful,
///    but WITHOUT ANY WARRANTY; without even the implied warranty of
///    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
///    GNU General Public License for more details.
///
///    You should have received a copy of the GNU General Public License
///    along with this program; if not, write to the Free Software
///    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
/// @file Tutorial.h
/// @author Robert Heller
/// @date 2025-09-30 20:29:53
/// 
///
//////////////////////////////////////////////////////////////////////////////

#ifndef __$BUFFER_NAME$
#define __$BUFFER_NAME$


#endif // __$BUFFER_NAME$

$TEMPLATE_END$1$
$TEMPLATE_START$2$
// -!- c++ -!- //////////////////////////////////////////////////////////////
//
//  System        : 
//  Module        : 
//  Object Name   : $RCSfile$
//  Revision      : $Revision$
//  Date          : $Date$
//  Author        : $Author$
//  Created By    : Robert Heller
//  Created       : 2025-09-30 20:29:53
//  Last Modified : <230327.1007>
//
//  Description	
//
//  Notes
//
//  History
//	
/////////////////////////////////////////////////////////////////////////////
/// @copyright
///    Copyright (C) 2025  Robert Heller D/B/A Deepwoods Software
///			51 Locke Hill Road
///			Wendell, MA 01379-9728
///
///    This program is free software; you can redistribute it and/or modify
///    it under the terms of the GNU General Public License as published by
///    the Free Software Foundation; either version 2 of the License, or
///    (at your option) any later version.
///
///    This program is distributed in the hope that it will be useful,
///    but WITHOUT ANY WARRANTY; without even the implied warranty of
///    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
///    GNU General Public License for more details.
///
///    You should have received a copy of the GNU General Public License
///    along with this program; if not, write to the Free Software
///    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
/// @file Tutorial.h
/// @author Robert Heller
/// @date 2025-09-30 20:29:53
/// 
///
//////////////////////////////////////////////////////////////////////////////

/** @page Tutorial Tutorial
 * @section Tutorial1 What you should put in .xsession or .xinitrc
 * The scripts .xsession (called from xdm, gdm, etc.) or .xinitrc (called
 * from xinit or startx) control what happens when you log in or start X. 
 * Typically this file initializes your X11 environment.  To use
 * TkSessionManager, you should have 
 * 
 * @verbatim
path/to/TkSessionManager                                                        
@endverbatim
 * 
 * as the last (eg after things like calls to xrdb or xset or xmodmap) or
 * only thing in this file.  TkSessionManager will launch your window
 * manager (eg fvwm) and run a script that starts your default
 * applications. 
 * 
 * @section Tutorial2 Initial Configuration
 * 
 * TkSessionManager uses the dconf configuration system. The gsettings
 * command line program and the dconf-editor GUI program can be used to set
 * or display the settings.  The schema used is @c org.tk.sessionmanager
 * 
 * The settable keys are:
 * 
 *  @arg @b main-title
 * 	Specifies the main title.  The default is "TK Session Manager".
 *  @arg @b main-geometry
 * 	Specifies the size and placement of the session manager window.
 * 	The default is to use the natural size and to center the window
 * 	on the screen.
 *  @arg @b menu-filename
 * 	Specifies the name of the file containing the commands menu.
 * 	The default is \$HOME/tkSessionManager.menu.
 *  @arg @b print-command
 * 	Specifies the command to use to print the contents of the
 * 	session manager's text area.  Should be a command that can take
 * 	a plain text stream on its stdin. Defaults to lp or lpr.
 *  @arg @b pipe-name-suffix
 * 	Specifies the name of the pipe created in the /tmp directory.
 * 	Text written to this pipe is displayed on the session manager's
 * 	text area.  The default is \${USER}_TkSessionManager.
 *  @arg @b window-manager
 * 	Specifies the path to the window manager program to start. 
 * 	Defaults to /usr/bin/fvwm.
 *  @arg @b session-script
 * 	Session startup script to run.  This stript contains the
 * 	commands to start up the initial set of processes for the user's
 * 	session. The default is \$HOME/tkSessionManager.session.
 *  @arg @b panel
 *        The name of a panel program to run.
 *  @arg @b text-font
 *        The text font to use.
 *  @arg @b background-color
 *        The background color
 *  @arg @b foreground-color
 *        The foreground color
 *  @arg @b border-color
 *        The border color
 *  @arg @b icon-name
 *        The icon name to use
 *
 * You will very much want to create the session start up script yourself,
 * although it too is optional.  You will also want to make sure you have a
 * configuration file for your window manager as well!
 * 
 * @section Tutorial3 Creating a Launcher Menu
 * You can either create a Launcher Menu using a text editor or you can use
 * the Menu Editor, as shown here.  The Menu Editor is started from the 
 * @image latex  MenuEditor.png "Menu Editor Window." width=5in
 * @image html MenuEditor.png 
 * @c Menu menu item on the @c Edit menu. The Menu Editor is described in 
 * detail in Section @ref Reference2. 
 * 
 * @section Tutorial4 Using the text area
 * 
 * The text area is just a plain text area which accepts keyboard input
 * with basic Emacs-like bindings.  It can be pasted to from the X11 copy
 * buffer and the text in it can be selected and copied to the X11 copy
 * buffer.  The contents of this text area can be saved to a text file
 * (@c Save As menu item on the @cSession menu) or sent to the printer 
 * (@c Print menu item on the @c Session menu). The text area can be 
 * completely cleared with the @c Clear menu item on the @c Session menu.  In 
 * addition, anything written to the named pipe gets appended to the end of 
 * the text area, so it is possible to capture the stdout and/or stderr 
 * streams from processes (all processes launched from the @c Commands menu 
 * have their stdout and stderr streams directed to this pipe).
 */







