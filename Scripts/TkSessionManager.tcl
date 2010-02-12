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

#puts stderr "***  argv0: $argv0"
#set argv0 [file join [file dirname [info nameofexecutable]] TkSessionManager]
#set argv0 [file dirname [info nameofexecutable]]

set argv0 [info nameofexecutable]

package require Tk

puts stderr "*** toplevel class: [. cget -class]"
puts stderr "*** tk appname:  [tk  appname]"

package require BWidget
package require HTMLHelp
package require BWStdMenuBar
package require TKSessionPreferences
package require TKSessionCommandMenu
package require TKSessionPipeIO

puts stderr "*** Main toplevel's class = [. cget -class]"

# Image Directory setup
global ImageDir 
set ImageDir [file join [file dirname [file dirname [info script]]] \
                        Common]
# Help Directory setup
global HelpDir
set HelpDir [file join [file dirname [file dirname [file dirname \
                                                        [info script]]]] Help]

namespace eval TKSessionManager {

  TKSessionPreferences::Preferences readpreferencesfile  

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
	}
    }]

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
  pack $Text -expand yes -fill both
  $scrollw setwidget $Text
  bind $Text <<Selection>> {TKSessionManager::SelectionChanged %W}
  global env
  if {[catch {set env(TMPDIR} TMPDIR]} {set TMPDIR /tmp}
  set pipename [file join $TMPDIR \
  "[TKSessionPreferences::Preferences get [winfo toplevel $Main] pipeName PipeName]"]
  variable Pipe [TKSessionPipeIO::Pipe %AUTO% -textoutput $Text -name $pipename]
  TKSessionCommandMenu::CommandMenu setpipe $Pipe
  set helpmenu [$Main getmenu help]
  $helpmenu delete "On Keys..."
  $helpmenu delete "Index..."  
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

  ::HTMLHelp::HTMLHelp setDefaults "$::HelpDir" UserManualli1.html
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
  TKSessionPreferences::Preferences set *MainGeometry "+$x+$y" widgetDefault

  variable TextFileTypes {
	{{Text files} {.txt .text} TEXT}
	{{All Files} * TEXT}
  }

  TKSessionPreferences::Preferences configurepreferences
  if {[catch {exec /usr/bin/pm-is-supported --suspend}] == 0} {
    $Main setmenustate actions:suspend normal
  }

  if {[catch {exec /usr/bin/pm-is-supported --hibernate}] == 0} {
    $Main setmenustate actions:hibernate normal
  }
  wm deiconify $w
}

#*************************************
# Careful exit function.
#*************************************
proc TKSessionManager::CareFulExit {} {
  if {[string compare \
	[tk_messageBox -default no -icon question -message {Really Quit?} \
		-title {Careful Exit} -type yesno] {yes}] == 0} {
    variable Pipe
    catch {$Pipe destroy}
    set $Pipe {}
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
		"[TKSessionPreferences::Preferences get [winfo toplevel $Main] \
				menuFilename MenuFilename]"
}

proc TKSessionManager::EditPreferences {} {
  variable Main
  TKSessionPreferences::Preferences edit -parent $Main
}

proc TKSessionManager::EditMenu {} {
  variable Main
  TKSessionCommandMenu::CommandMenu edit \
	-parent $Main \
	-menufile "[TKSessionPreferences::Preferences get [winfo toplevel $Main] \
				menuFilename MenuFilename]"

}

proc TKSessionManager::Suspend {} {
  exec /usr/bin/pm-suspend
}

proc TKSessionManager::Hibernate {} {
  exec /usr/bin/pm-hibernate
}

   
TKSessionManager::ReloadMenu
