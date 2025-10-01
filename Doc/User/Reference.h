// -!- C++ -!- //////////////////////////////////////////////////////////////
//
//  System        : 
//  Module        : 
//  Object Name   : $RCSfile$
//  Revision      : $Revision$
//  Date          : $Date$
//  Author        : $Author$
//  Created By    : Robert Heller
//  Created       : 2025-09-30 20:59:34
//  Last Modified : <250930.2150>
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
/// @file Reference.h
/// @author Robert Heller
/// @date 2025-09-30 20:59:34
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
//  Created       : 2025-09-30 20:59:34
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
/// @file Reference.h
/// @author Robert Heller
/// @date 2025-09-30 20:59:34
/// 
///
//////////////////////////////////////////////////////////////////////////////

/** @page Reference_Manual Reference Manual
 * The annotated main window for the TkSessionManager is shown here:
 * @image latex MainWindowAnnotated.png "Main Window, Annotated." width=5in
 * @image html MainWindowAnnotated_small.png
 * There is a menu bar along the top,
 * with five menus: @c Session, @c Edit, @c Commands, 
 * @c Actions, and @c Help.  The @c Session contains menu
 * items to clear the text area, save the main text area as a text file,
 * print the main text area on a printer, reload the menu file, and quit
 * the application (if TkSessionManager is the last or only command
 * in your .xinitrc or .xsession file, this will in fact quit your X11
 * session).
 * 
 * The @c Edit menu contains, in addition to the standard edit
 * functions of cut; copy; paste; clear; delete; select all; deselect all,
 * there is a menu item to edit the commands menu (see @ref Reference2).
 *
 * The @c Commands menu is completely user defined.  This menu is
 * built from the contents of the specified menu file.  See
 * Section @ref Reference1 for a detailed description of this
 * file.
 *
 * The @c Actions menu has menu items for controlling the system as a
 * whole. This includes suspending and hibernating the system.
 * 
 * Finally, the @c Help menu has menu items for accessing this document 
 * on-line.
 * 
 * @section Reference1 Command Menu File format
 * 
 * The menu file consists of pairs of lines, the menu item text and the
 * command to run (which should be something suitable as an argument list
 * to the Tcl exec command).  Lines starting with a `!' are comments and
 * ignored. A casscade is introduced by using a `{' at the beginning of the
 * menu item text.  Lines are processed as menu items under the casscade
 * name until a lone `}'
 *
 * Commands are passed to the Tcl @c exec command and always forked
 * as background tasks, with a `\&' added to the end of the command and the
 * command's stdout and stderr bound to the pipe feeding to the text area.
 * A simple sample menu file is shown here:
 * @code{.unparsed}
 * ! Sample menu
 * Terminal
 * /usr/bin/xterm
 * GnuEmacs
 * /usr/bin/emacs
 * {CS Machines
 * Foo
 * /usr/bin/xterm -title Foo -n Foo -e slogin foo.cs.school.edu
 * Bar
 * /usr/bin/xterm -title Bar -n Bar -e slogin bar.cs.school.edu
 * }
 * Gimp
 * /usr/bin/gimp
 * Inkscape
 * /usr/bin/inkscape
 * Audacity
 * /usr/bin/audacity
 * Kino
 * /usr/bin/kino
 * @endcode
 * This menu defines the menu items @c Terminal, @c GnuEmacs,
 * @c CS Machines (a cascade menu), @c Gimp,
 * @c Inkscape, @c Audacity, and @c Kino.  The
 * @c CS Machines cascade menu has two items, @c Foo and
 * @c Bar. Each of the items is followed by the command line to run.
 * For example the @c Terminal menu item runs the command
 * @c /usr/bin/xterm, which launches the old-school xterm program,
 * which opens up a shell window.  The two menu items under the @c CS
 * Machines cascade also open up xterm windows, but use slogin to log in
 * remotely to machines on the CS network at @c school.edu.
 *
 * While it is quite possible to ``hand edit'' this file using your
 * favorite plain text editor, the TkSessionManager program includes a
 * simple built in editing tool, which is described in
 * the next section (@ref Reference2).
 * 
 * @section Reference2 Edit Command Menu
 *
 * The annotated Menu Editor window for the TkSessionManager is shown here
 * @image latex MenuEditorAnnotated.png "Menu Editor Window, annotated." width=5in
 * @image html MenuEditorAnnotated_small.png
 * At the top is the name of the menu
 * filename to save in, in the middle is the menu displayed as a tree,
 * with a set of four edit command buttons just below the menu tree, and a
 * set of dialog control buttons at the bottom.  There are buttons for
 * inserting new commands and cascades, a button to delete a command or
 * cascade, and a button for showing (and editing) the properties of a
 * command or cascade.
 *
 * @subsection Reference2a Item Properties
 * 
 * The two insert buttons and the properites button
 * all pop up a small properties window, show here
 * @image latex CommandPropertiesAnnotated.png "Command Properties window, annotated."
 * @image html CommandPropertiesAnnotated_small.png
 * @image latex CasscadePropertiesAnnotated.png "Casscade Properties window, annotated."
 * @image html CasscadePropertiesAnnotated_small.png
 * In both windows, there is an editable text label and in the case of the
 * command properties window, there is a command path that can be edited.
 * The edits in these windows can be saved by clicking the OK button or the
 * changes can be discarded by clicking the Cancel button.
 *
 * @subsection Reference2ab Rearanging the order of menu items
 * 
 * The order of menu items can be rearanged by draging and dropping them
 * to different locations in the menu tree.
 * 
 * @section Reference3 Configuration
 * 
 * TkSessionManager uses the dconf configuration system. The gsettings
 * command line program and the dconf-editor GUI program can be used to set
 * or display the settings.  The schema used is @c org.tk.sessionmanager.
 *
 * The settable keys are:
 * 
 * @arg main-title Specifies the main title.  The default is ``TK Session
 * Manager''. 
 * @arg main-geometry Specifies the size and placement of the session
 * manager window. The default is to use the natural size and to center the
 * window on the screen.
 * @arg menu-filename Specifies the name of the file containing the
 * commands menu. The default is @c tkSessionManager.menu.
 * @arg print-command Specifies the command to use to print the contents
 * of the session manager's text area.  Should be a command that can take a
 * plain text stream on its stdin. Defaults to lp or lpr. 
 * @arg pipe-name-suffix Specifies the name of the pipe created in the
 * @c /tmp directory. Text written to this pipe is displayed on the session
 * manager's text area.  The default is @c _TkSessionManager.
 * @arg window-manager Specifies the path to the window manager program to
 * start. Defaults to fvwm. 
 * @arg session-script Session startup script to run.  This script
 * contains the commands to start up the initial set of processes for the
 * user's session. The default is @c /bin/true.
 * @arg panel The name of a panel program to run.
 * @arg text-font The text font to use.
 * @arg background-color The background color.
 * @arg foreground-color The foreground color.
 * @arg border-color The border color.
 * @arg icon-name The icon name to use.
 */

