#* 
#* ------------------------------------------------------------------
#* TkSessionManager.tcl - Based on Menu Manager II
#* Created by Robert Heller on Sat Mar 17 09:10:04 2007
#* ------------------------------------------------------------------
#* Modification History: $Log: headerfile.text,v $
#* Modification History: Revision 1.1  2002/07/28 14:03:50  heller
#* Modification History: Add it copyright notice headers
#* Modification History:
#* ------------------------------------------------------------------
#* Contents:
#* ------------------------------------------------------------------
#*  
#*     Generic Project
#*     Copyright (C) 2010  Robert Heller D/B/A Deepwoods Software
#* 			51 Locke Hill Road
#* 			Wendell, MA 01379-9728
#* 
#*     This program is free software; you can redistribute it and/or modify
#*     it under the terms of the GNU General Public License as published by
#*     the Free Software Foundation; either version 2 of the License, or
#*     (at your option) any later version.
#* 
#*     This program is distributed in the hope that it will be useful,
#*     but WITHOUT ANY WARRANTY; without even the implied warranty of
#*     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#*     GNU General Public License for more details.
#* 
#*     You should have received a copy of the GNU General Public License
#*     along with this program; if not, write to the Free Software
#*     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#* 
#*  
#* 

## @defgroup TkSessionManager TkSessionManager
# @brief Tk Session Manager -- Manage X11 Sessions
#
# @section SYNOPSIS
# TkSessionManager [X11 Resource Options]
#
# @section DESCRIPTION
# This program is an X11 Session Manager program.  It is started as the
# last or only  command in a .xinitrc or .xsession script file.  It
# provides a user definable menu of commands to be launched.  It also 
# provides a text area that can be used for (electronic) note taking.  
# The contents of the text area can be edited, saved, cleared, copied to
# the X11 copy buffer, and printed.
# 
# It does the following on startup:
# -# Creates a pipe in /tmp that it reads text from.  This text is
#    displayed on the Session Manager's text area. This pipe is also
#    bound to stdout and stderr of the processes launched by from the
#    user defined menu.
# -# Starts up the window manager.
# -# Optionally starts a panel
# -# Runs a session script which launches an initial set of programs.
# .
#
# @section PARAMETERS
# None.
# @section RESOURCES
# The configuration is in the GLIB database.  The Schema is 
# org.tk.sessionmanager.  The preferences keys are:
#
#
# @arg @b main-title
#	Specifies the main title.  The default is "TK Session Manager".
# @arg @b main-geometry
#	Specifies the size and placement of the session manager window.
#	The default is to use the natural size and to center the window
#	on the screen.
# @arg @b menu-filename
#	Specifies the name of the file containing the commands menu.
#	The default is \$HOME/tkSessionManager.menu.
# @arg @b print-command
#	Specifies the command to use to print the contents of the
#	session manager's text area.  Should be a command that can take
#	a plain text stream on its stdin. Defaults to lp or lpr.
# @arg @b pipe-name-suffix
#	Specifies the name of the pipe created in the /tmp directory.
#	Text written to this pipe is displayed on the session manager's
#	text area.  The default is \${USER}_TkSessionManager.
# @arg @b window-manager
#	Specifies the path to the window manager program to start. 
#	Defaults to /usr/bin/fvwm.
# @arg @b session-script
#	Session startup script to run.  This stript contains the
#	commands to start up the initial set of processes for the user's
#	session. The default is \$HOME/tkSessionManager.session.
# @arg @b panel
#       The name of a panel program to run.
# @arg @b text-font
#       The text font to use.
# @arg @b background-color
#       The background color
# @arg @b foreground-color
#       The foreground color
# @arg @b border-color
#       The border color
# @arg @b icon-name
#       The icon name to use
# @section AUTHOR
# Robert Heller \<heller\@deepsoft.com\>
#


#puts stderr "***  argv0: $argv0"
#set argv0 [file join [file dirname [info nameofexecutable]] TkSessionManager]
#set argv0 [file dirname [info nameofexecutable]]

set argv0 [info nameofexecutable]

set progdir [file dirname $argv0]
append ::env(PATH) ":$progdir"
global progdir_TkPanel
set progdir_TkPanel [file join [file dirname [file dirname [file dirname $argv0]]] TkPanel trunk]
global progdir_TkPanelApplets
set progdir_TkPanelApplets [file join [file dirname [file dirname [file dirname $argv0]]] TkPanelApplets trunk]
append ::env(PATH) ":$progdir_TkPanel"
append ::env(PATH) ":$progdir_TkPanelApplets"

#puts stderr "*** ::env(PATH) is $::env(PATH)"

package require Tk

#puts stderr "*** toplevel class: [. cget -class]"
#puts stderr "*** tk appname:  [tk  appname]"

package require BWidget
package require HTMLHelp
package require BWStdMenuBar
package require TKSessionPreferences
package require TKSessionCommandMenu
package require TKSessionPipeIO
package require SigTrap

#puts stderr "*** Main toplevel's class = [. cget -class]"

# Image Directory setup
global ImageDir 
set ImageDir [file join [file dirname [file dirname [file dirname [info script]]]] \
                        Images]
# Help Directory setup
global HelpDir
set HelpDir [file join [file dirname [file dirname [file dirname \
                                                        [info script]]]] Help]

namespace eval TKSessionManager {

  variable CheckScreenSaverCount 0

  #TKSessionPreferences::Preferences readpreferencesfile  
  TKSessionPreferences::Preferences configurepreferences

  # Window manager configurations
  wm positionfrom . user
  wm sizefrom . ""
  wm maxsize . 1265 994
  wm minsize . 1 1
  wm protocol . WM_DELETE_WINDOW {TKSessionManager::CareFulExit}
  wm withdraw .
  variable Menu [StdMenuBar::MakeMenu \
	-file {"&Session" {session} {session} 0 {
		{command "&Clear" {session:clear} "Clear Main Text" {Ctrl c} \
			-command TKSessionManager::ClearMainText}
		{command "&Save As..."    {session:saveas} "Save main window text"
			{Ctrl s} -command TKSessionManager::SaveMainText}
		{command "&Print..." {session:print} "Print main window text"
			{Ctrl p} -command TKSessionManager::PrintMainText}
		{command "&Reload Menu" {session:reload} "Reload User Menu"
			{Ctrl r} -command TKSessionManager::ReloadMenu}
		{command "&Quit" {session:quit} "Quit" {Ctrl q} \
			-command TKSessionManager::CareFulExit}
		}
	} -edit {"&Edit" {edit} {edit} 0 {
	{command "&Undo" {edit:undo} "Undo last change" {Ctrl z} \
							-state disabled}
	{command "Cu&t" {edit:cut edit:havesel} 
		        "Cut selection to the paste buffer" {Ctrl x} 
			-command StdMenuBar::EditCut -state disabled}
	{command "&Copy" {edit:copy edit:havesel} 
			"Copy selection to the paste buffer" {Ctrl c} 
			-command StdMenuBar::EditCopy -state disabled}
	{command "&Paste" {edit:paste} 
			  "Paste in the paste buffer" {Ctrl v} 
			  -command StdMenuBar::EditPaste}
	{command "C&lear" {edit:clear edit:havesel} "Clear selection" {} 
			  -command StdMenuBar::EditClear -state disabled}
	{command "&Delete" {edit:delete edit:havesel} "Delete selection" 
			{Ctrl d} -command StdMenuBar::EditCut -state disabled}
	{separator}
	{command "Select All" {edit:selectall} "Select everything" {} 
			-command TKSessionManager::SelectAll}
	{command "De-select All" {edit:deselectall edit:havesel} 
			"Select nothing" {} -command TKSessionManager::SelectNone
			 -state disabled}
	{separator}
	{command "Preferences" {edit:prefs} "Edit Preferences" {}
			-command TKSessionManager::EditPreferences}
	{command "Menu" {edit:menu} "Edit Menu" {}
			-command TKSessionManager::EditMenu}
	}
    } -commands {"&Commands" {commands} {commands} 0 {
	}
    } -actions {"&Actions" {actions} {actions} 0 {
	{command "Suspend" {actions:suspend} {Suspend to memory} {} 
			-command TKSessionManager::Suspend -state disabled}
	{command "Hibernate" {actions:hibernate} {Hibernate to disk} {} \
                  -command TKSessionManager::Hibernate -state disabled}
        {command "Shutdown" {actions:shutdown} {System Shutdown} {} \
                  -command TKSessionManager::Shutdown -state disabled}
	}
    } -options {} -view {}]

  #parray ::env
  variable Status {}
  variable Main [MainFrame::create .main -menu $Menu \
			-textvariable TKSessionManager::Status]
  pack $Main -expand yes -fill both
  $Main showstatusbar status
  TKSessionCommandMenu::CommandMenu settopmenu [$Main getmenu commands]
  set scrollw [ScrolledWindow::create [$Main getframe].scrollw \
			-auto both -scrollbar  both]
  pack $scrollw -expand yes -fill both
  variable Text [text [$scrollw getframe].text]
  $scrollw setwidget $Text
  bind $Text <<Selection>> {TKSessionManager::SelectionChanged %W}
  set helpmenu [$Main getmenu help]
  $helpmenu delete "On Keys..."
  $helpmenu delete "Index..."  
  $helpmenu delete "On Context..."
  $helpmenu delete "On Window..."
  $helpmenu insert "On Help..." command -label "About TkSessionManager" \
        -underline 0 -command ::TKSessionManager::AboutDialog
  $helpmenu add command -label "Reference Manual" \
		-command [list ::HTMLHelp::HTMLHelp help "Reference Manual"]
  $helpmenu entryconfigure "On Help..." \
		-command "::HTMLHelp::HTMLHelp help Help"
  $helpmenu entryconfigure "On Version" \
		-command "::HTMLHelp::HTMLHelp help Version"
  $helpmenu entryconfigure "Copying" \
	-command "::HTMLHelp::HTMLHelp help Copying"
  $helpmenu entryconfigure "Warranty" \
	-command "::HTMLHelp::HTMLHelp help Warranty"
  $helpmenu entryconfigure "Tutorial..." \
	-command "::HTMLHelp::HTMLHelp help Tutorial"

  ::HTMLHelp::HTMLHelp setDefaults "$::HelpDir" index.html
  # Center window on the screen and map it.
  update idle
  set w [winfo toplevel $Main]
  set x [expr {[winfo screenwidth $w]/2 - [winfo reqwidth $w]/2}]
  set y [expr {[winfo screenheight $w]/2 - [winfo reqheight $w]/2}]
  # Make sure that the window is on the screen and set the maximum
  # size of the window is the size of the screen.
  if {$x < 0} {
    set x 0
  }
  if {$y < 0} {
    set y 0
  }
  wm maxsize $w [winfo screenwidth $w] [winfo screenheight $w]
  #TKSessionPreferences::Preferences set *MainGeometry "+$x+$y" widgetDefault
  wm geometry $w [TKSessionPreferences::Preferences get $w mainGeometry MainGeometry]
  
  variable TextFileTypes {
	{{Text files} {.txt .text} TEXT}
	{{All Files} * TEXT}
  }

  update idle
  global env
  if {[catch {set env(TMPDIR} TMPDIR]} {set TMPDIR /tmp}
  set pipename [file join $TMPDIR \
  "$::tcl_platform(user)[TKSessionPreferences::Preferences get [winfo toplevel $Main] pipeName PipeName]"]
  variable Pipe [TKSessionPipeIO::Pipe %AUTO% -textoutput $Text -name $pipename]
  TKSessionCommandMenu::CommandMenu setpipe $Pipe
  if {[catch {exec /usr/bin/pm-is-supported --suspend}] == 0} {
    $Main setmenustate actions:suspend normal
  }

  if {[catch {exec /usr/bin/pm-is-supported --hibernate}] == 0} {
    $Main setmenustate actions:hibernate normal
  }
  variable ShutdownManager [TKSessionPreferences::Preferences get \
                            [winfo toplevel $Main] \
                            shutdownManager ShutdownManager]
  if {$ShutdownManager ne ""} {
      $Main setmenustate actions:shutdown  normal
  }
                            
  wm deiconify $w
}

package require Version

proc TKSessionManager::AboutDialog {} {
    if {[winfo exists .about]} {return}
    set about [toplevel .about -class About]
    wm overrideredirect .about 1
    wm withdraw .about
    pack [ttk::label .about.header \
          -image [image create photo \
                  -file [file join $::ImageDir DeepwoodsBanner.gif]]] \
    	-side top
    pack [message .about.message -text [subst {
          TkSessionManager, an X11 Session manager
          Version $TkSessionManager::VERSION
          Tcl version $::tcl_patchLevel
          Platform: $::tcl_platform(osVersion) $::tcl_platform(os) $::tcl_platform(machine)
          By Robert Heller}] -aspect 500 \
            -background #242d2b -foreground white] \
         -side bottom -fill both -expand yes
    bind .about <1> {destroy .about}
    update idle
    set width [winfo reqwidth .about]
    set height [winfo reqheight .about]
    set screenwidth [winfo screenwidth .about]
    set screenheight [winfo screenheight .about]
    set xpos [expr {($screenwidth - $width)/2}]
    set ypos [expr {($screenheight - $height)/2}]
    wm geometry .about [format {=%dx%d+%d+%d} $width $height  $xpos $ypos]
    wm deiconify .about
}

#*************************************
# Careful exit function.
#*************************************
proc TKSessionManager::CareFulExit {} {
    variable Main
    if {[string compare \
         [tk_messageBox -default no -icon question \
          -message {Really Quit?} \
          -title {Careful Exit} -type yesno] {yes}] == 0} {
        variable Pipe
        catch {$Pipe destroy}
        set $Pipe {}
        ## kill panels?
        # And exit
        exit
    }
}


proc TKSessionManager::SelectionChanged {w} {
  variable Main

  set selection [$w tag ranges sel]
  if {[llength $selection] == 0} {
    $Main setmenustate edit:havesel disabled
  } else {
    $Main setmenustate edit:havesel normal
  }
}

proc TKSessionManager::SelectAll {} {
  variable Text

  $Text tag remove sel 1.0 end-1c
  $Text tag add sel 1.0 end-1c
}

proc TKSessionManager::SelectNone {} {
  variable Text

  $Text tag remove sel 1.0 end-1c
}

proc TKSessionManager::ClearMainText {} {
  variable Text

  $Text delete 1.0 end-1c
}

proc TKSessionManager::SaveMainText {{outfile {}}} {
  variable Text
  variable Main
  variable TextFileTypes

  if {[string length "$outfile"] == 0} {
    set outfile [tk_getSaveFile -title {File to save text in} \
			      -parent $Main \
			      -initialfile "text.txt" \
			      -initialdir [pwd] \
			      -filetypes $TextFileTypes \
			      -defaultextension .txt]
  }
  if {[string length "$outfile"] > 0} {
    if {[catch {open "$outfile" w} ofp]} {
      tk_messageBox -type ok -icon error -message "Could not open $outfile: $ofp"
    } else {
      puts $ofp "[$Text get 1.0 end-1c]"
      close $ofp
    }
  }
}

proc TKSessionManager::PrintMainText {} {
  variable Main
  set prcommand "[TKSessionPreferences::Preferences get [winfo toplevel $Main] printCommand PrintCommand]"
  if {[string length "$prcommand"] > 0} {
    SaveMainText "|$prcommand"
  } else {
    tk_messageBox -type ok -icon error -message "No print command available"
  }
}

proc TKSessionManager::ReloadMenu {} {
  variable Main
  TKSessionCommandMenu::CommandMenu reload \
        [file join $::env(HOME) \
         "[TKSessionPreferences::Preferences get [winfo toplevel $Main] \
         menuFilename MenuFilename]"]
  variable Text
  $Text insert end "Menu Reloaded\n"
  $Text see end
}

proc TKSessionManager::Startup {} {
  variable Main
  variable Text
  set windowmanager "[TKSessionPreferences::Preferences get \
			[winfo toplevel $Main] \
			windowManager WindowManager]"
  catch {exec $windowmanager &} result
  $Text insert end "exec $windowmanager: $result\n"

  set panelprog [auto_execok [TKSessionPreferences::Preferences get [winfo toplevel $Main] panel Panel]]
  if {$panelprog ne {}} {
      if {[catch {exec $panelprog &} pid]} {
          tk_messageBox -icon error -type ok \
                -message "Failed to start $panelprog: $pid"
      }
  }
  
    
  set sessionScript [file join $::env(HOME) \
                     "[TKSessionPreferences::Preferences get \
                     [winfo toplevel $Main] \
                           sessionScript SessionScript]"]
  if {[catch {open "|$sessionScript" r} pipefp]} {
    $Text insert end "open |$sessionScript r: $pipefp\n"
    return
  }
  fileevent $pipefp readable [list TKSessionManager::readpipe $pipefp]  
  sigtrap_catch $::SIGUSR1
  variable MenuLoadTime
  ReloadMenu
  set MenuLoadTime [clock seconds]
  after 1000 TKSessionManager::CheckUSR1
  
}

proc TKSessionManager::CheckUSR1 {} {
    variable Main
    variable MenuLoadTime
    set menufile [file join $::env(HOME) \
                  "[TKSessionPreferences::Preferences get \
                  [winfo toplevel $Main] \
                        menuFilename MenuFilename]"]
    if {[sigtrap_received $::SIGUSR1]} {
        ReloadMenu
        set MenuLoadTime [clock seconds]
        sigtrap_reset $::SIGUSR1
    } elseif {[file mtime $menufile] > $MenuLoadTime} {
        ReloadMenu
        set MenuLoadTime [clock seconds]
    }
    after 1000 ::TKSessionManager::CheckUSR1
}


proc TKSessionManager::CheckScreenSaver {} {
  variable CheckScreenSaverCount
  incr CheckScreenSaverCount
  if {$CheckScreenSaverCount > 100} {return}
  if {[catch {exec ps ux | grep -v grep | grep -q gnome-screensaver}]} {
    after 1000 TKSessionManager::CheckScreenSaver
  } else {
    catch {exec killall gnome-screensaver}
  }
}

proc TKSessionManager::readpipe {pipefp} {
  variable Text
  if {[gets $pipefp line] < 0} {
    catch {close $pipefp}
  } else {
    $Text insert end "$line\n"
    $Text see end
  }
}

proc TKSessionManager::EditPreferences {} {
  variable Main
  TKSessionPreferences::Preferences edit -parent [winfo toplevel $Main]
}

proc TKSessionManager::EditMenu {} {
  variable Main
  TKSessionCommandMenu::CommandMenu edit \
	-parent $Main \
	-menufile [file join $::env(HOME) \
                   "[TKSessionPreferences::Preferences get [winfo toplevel $Main] \
                   menuFilename MenuFilename]"]

}

proc TKSessionManager::Suspend {} {
  exec /usr/bin/pm-suspend
}

proc TKSessionManager::Hibernate {} {
  exec /usr/bin/pm-hibernate
}

proc TKSessionManager::Shutdown {} {
    variable ShutdownManager
    if {$ShutdownManager ne ""} {
        eval exec $ShutdownManager
    }
}



TKSessionManager::ReloadMenu
TKSessionManager::Startup
