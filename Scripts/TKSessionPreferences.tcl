#* 
#* ------------------------------------------------------------------
#* TKSessionPreferences.tcl - Tk Session Manager Preferences
#* Created by Robert Heller on Sat Mar 17 10:53:02 2007
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

package require snit
package require BWidget
package require TKSessionCommandMenu
#puts stderr "*** tk appname  = [tk appname]"


namespace eval TKSessionPreferences {
  snit::type Preferences {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no

    typevariable _preferences -array {}
    typevariable _preferencesfile 

    typemethod readpreferencesfile {} {
      catch {option readfile $_preferencesfile startupFile}
    }
    typemethod configurepreferences {{window .}} {
      $type _createdialog
      foreach pattern [array names _preferences] {
	foreach {name class default widget configscript} \
				"$_preferences($pattern)" {break}   
	set value [$type get $window $name $class]
	regsub -all {%value} "$configscript" "$value" script
	catch {uplevel #0 $script}
	puts stderr "*** $type configurepreferences: name = '$name', widget = '$widget', value = '$value'"
	$widget configure -text "$value"
      }
    }

    typemethod set {pattern value {priority interactive}} {
      option add "$pattern" "$value" $priority
    }
    typemethod get {window name class} {
      set value "[option get $window $name $class]"
      puts stderr "*** $type get: window = $window, name = $name, class = $class, value = '$value'"
      return "$value"
    }


    typecomponent dialog;#		Edit preferences dialog
    typecomponent  titleLE;#		Window title
    typecomponent  geometryLE;#		Geometry
    typecomponent  menuFilenameLF
    typecomponent    menuFilenameE;#	menu filename	
    typecomponent    menuFilenameB
    typecomponent  printCommandLE;#	print command
    typecomponent  pipeNameLE;#		pipe name
    typecomponent  windowManagerLF
    typecomponent    windowManagerE;#	window manager program
    typecomponent    windowManagerB
    typecomponent  sessionScriptLF
    typecomponent    sessionScriptE;#	session script
    typecomponent    sessionScriptB
    typecomponent  gnomeSettingsDaemonLF
    typecomponent    gnomeSettingsDaemonCB;# gnome-settings-daemon ?
    typecomponent  gnomeScreensaverLF
    typecomponent    gnomeScreensaverCB;#    gnome-screensaver ?
    typevariable _labelWidth 30

    typeconstructor {
      set host_preferencesfile [file join ~ .[string tolower [tk appname]]rc-[exec hostname]]
      if {[file readable $host_preferencesfile]} {
	set _preferencesfile $host_preferencesfile
      } else {
        set _preferencesfile [file join ~ .[string tolower [tk appname]]rc]
      }
      set dialog {}
    }
    typemethod _createdialog {} {
      if {"$dialog" ne "" && [winfo exists $dialog]} {return}
      set dialog [Dialog::create .editPreferencesDialog \
			-title {Preferences} \
			-transient yes -modal none \
			-default 0 -cancel 2 \
			-side bottom]
      $dialog add -name ok     -text OK     -command [mytypemethod _OK]
      $dialog add -name apply  -text Apply  -command [mytypemethod _Apply]
      $dialog add -name cancel -text Cancel -command [mytypemethod _Cancel]
      $dialog add -name help   -text Help   -command [list ::HTMLHelp::HTMLHelp help "Edit Preferences"]
      set frame [$dialog getframe]
      set titleLE [LabelEntry::create $frame.titleLE -label "Window Title:" \
						     -labelwidth $_labelWidth]
      pack $titleLE -fill x
      set _preferences(*MainTitle) [list mainTitle MainTitle {TK Session Manager} \
				$titleLE {wm title . "%value"}]
      set geometryLE [LabelEntry::create $frame.geometryLE \
						     -label "Window Geometry:" \
						     -labelwidth $_labelWidth]
      pack $geometryLE -fill x
      set _preferences(*MainGeometry) [list mainGeometry MainGeometry {} \
						$geometryLE \
						{wm geometry . "%value"}]


      set menuFilenameLF [LabelFrame::create $frame.menuFilenameLF \
						     -text "Menu Filename:" \
						     -width $_labelWidth]
      pack $menuFilenameLF -fill x
      set menuFilenameLFfr [$menuFilenameLF getframe]
      set menuFilenameE [Entry::create $menuFilenameLFfr.menuFilenameE]
      pack $menuFilenameE -side left -fill x -expand yes
      set menuFilenameB [Button::create $menuFilenameLFfr.menuFilenameB \
				-text "Browse" \
				-command [mytypemethod _BrowseMenuFiles]]
      pack $menuFilenameB -side right
      set _preferences(*MenuFilename) [list menuFilename MenuFilename \
				{~/tkSessionManager.menu} $menuFilenameE {}]
      set printCommandLE [LabelEntry::create $frame.printCommandLE \
						-label "Print Command:" \
						-labelwidth $_labelWidth]
      pack $printCommandLE -fill x
      set _preferences(*PrintCommand) [list printCommand PrintCommand \
					[$type _defaultprintcmd] \
					$printCommandLE {}]
      set pipeNameLE  [LabelEntry::create $frame.pipeNameLE \
						-label "Pipe Name:" \
						-labelwidth $_labelWidth]
      pack  $pipeNameLE -fill x
      set _preferences(*PipeName) [list pipeName PipeName \
			$::tcl_platform(user)_TkSessionManager $pipeNameLE {}]


      set windowManagerLF [LabelFrame::create $frame.windowManagerLF \
						     -text "Window Manager:" \
						     -width $_labelWidth]
      pack $windowManagerLF -fill x
      set windowManagerLFfr [$windowManagerLF getframe]
      set windowManagerE [Entry::create $windowManagerLFfr.windowManagerE]
      pack $windowManagerE -side left -fill x -expand yes
      set windowManagerB [Button::create $windowManagerLFfr.windowManagerB \
				-text "Browse" \
				-command [mytypemethod _BrowseWindowManagerFiles]]
      pack $windowManagerB -side right
      set _preferences(*WindowManager) [list windowManager WindowManager \
					/usr/bin/fvwm $windowManagerE {}]
      
      set sessionScriptLF [LabelFrame::create $frame.sessionScriptLF \
						     -text "Session Script:" \
						     -width $_labelWidth]
      pack $sessionScriptLF -fill x
      set sessionScriptLFfr [$sessionScriptLF getframe]
      set sessionScriptE [Entry::create $sessionScriptLFfr.sessionScriptE]
      pack $sessionScriptE -side left -fill x -expand yes
      set sessionScriptB [Button::create $sessionScriptLFfr.sessionScriptB \
				-text "Browse" \
				-command [mytypemethod _BrowseSessionScriptFiles]]
      pack $sessionScriptB -side right
      set _preferences(*SessionScript) [list sessionScript SessionScript \
					{~/tkSessionManager.session} \
					$sessionScriptE {}]
      set gnomeSettingsDaemonLF [LabelFrame::create \
					$frame.gnomeSettingsDaemonLF \
					-text "Run Gnome Settings Daemon?" \
					-width $_labelWidth]
      pack $gnomeSettingsDaemonLF -fill x
      set gnomeSettingsDaemonLFfr [$gnomeSettingsDaemonLF getframe]
      set gnomeSettingsDaemonCB [ComboBox::create \
				$gnomeSettingsDaemonLFfr.gnomeSettingsDaemonCB \
				-editable no -values {yes no}]
      pack $gnomeSettingsDaemonCB -side left -fill x -expand yes
      $gnomeSettingsDaemonCB setvalue first
      set _preferences(*GnomeSettingsDaemon) [list gnomeSettingsDaemon \
						   GnomeSettingsDaemon \
						   yes \
						   $gnomeSettingsDaemonCB {}]

      set gnomeScreensaverLF [LabelFrame::create \
					$frame.gnomeScreensaverLF \
					-text "Run Gnome Screen Saver?" \
					-width $_labelWidth]
      pack $gnomeScreensaverLF -fill x
      set gnomeScreensaverLFfr [$gnomeScreensaverLF getframe]
      set gnomeScreensaverCB [ComboBox::create \
				$gnomeScreensaverLFfr.gnomeScreensaverCB \
				-editable no -values {yes no}]
      pack $gnomeScreensaverCB -side left -fill x -expand yes
      $gnomeScreensaverCB setvalue last
      set _preferences(*GnomeScreensaver) [list gnomeScreensaver \
						   GnomeScreensaver \
						   no \
						   $gnomeScreensaverCB {}]

      foreach pattern [array names _preferences] {
        foreach {name class default widget configscript} \
				"$_preferences($pattern)" {break}
	option add $pattern "$default" widgetDefault
	$widget configure -text "$default"
      }
    }
    typemethod _defaultprintcmd {} {
      set lpr [auto_execok lpr]
      if {[string length "$lpr"] > 0} {return "$lpr"}
      set lp [auto_execok lp]
      if {[string length "$lp"] > 0} {return "$lp"}
      return {}
    }
    typemethod _BrowseMenuFiles {} {
      set newfile [tk_getOpenFile -parent $dialog -title "Menu Filename" \
				  -defaultextension .menu \
				  -filetypes [TKSessionCommandMenu::CommandMenu \
							menufiletypes] \
				  -initialfile "[$menuFilenameE cget -text]"]
      if {[string length "$newfile"] > 0} {
	$menuFilenameE configure -text "$newfile"
      }
    }
    typemethod _BrowseWindowManagerFiles {} {
      set newfile [tk_getOpenFile -parent $dialog -title "Window Manager" \
				  -initialdir /usr/bin
				  -initialfile "[$windowManagerE cget -text]"]
      if {[string length "$newfile"] > 0} {
	$windowManagerE configure -text "$newfile"
      }
    }
    typemethod _BrowseSessionScriptFiles {} {
      set newfile [tk_getOpenFile -parent $dialog -title "Session Script Filename" \
				  -defaultextension {} \
				  -initialdir  "$::env(HOME)" \
				  -initialfile "[$sessionScriptE cget -text]"]
      if {[string length "$newfile"] > 0} {
	$sessionScriptE configure -text "$newfile"
      }
    }
    typemethod _OK {} {
      $type _Apply
      $dialog withdraw
      return [$dialog enddialog ok]
    }
    typemethod _Apply {} {
      foreach pattern [array names _preferences] {
	foreach {name class default widget configscript} \
				"$_preferences($pattern)" {break}
	set value "[$widget cget -text]"
	$type set $pattern "$value"
	regsub -all {%value} "$configscript" "$value" script
	catch {uplevel #0 $script}
      }
      $type updatepreferencesfile
    }
    typemethod updatepreferencesfile {} {
      if {[catch {open $_preferencesfile r} pfp]} {
	set prefs {}
	foreach pattern [array names _preferences] {
	  foreach {name class default widget configscript} \
				"$_preferences($pattern)" {break}
	  lappend prefs "$pattern: [$widget cget -text]"
	}
      } else {
	set prefs {}
	while {[gets $pfp line] >= 0} {
	  foreach {pattern value} [split "$line" ":"] {break}
	  if {[catch {set _preferences($pattern)} _pref]} {
	    lappend prefs "$pattern: $value"
	  } else {
	    foreach {name class default widget configscript} "$_pref" {break}
	    lappend prefs "$pattern: [$widget cget -text]"
	  }
	}
	close $pfp
	file rename -force $_preferencesfile ${_preferencesfile}.bak
      }
      if {[catch {open $_preferencesfile w} pfp]} {
	tk_messageBox -type ok -icon warning -message "Could not save preferences: $pfp"
	return
      }
      foreach pref $prefs {
	puts $pfp "$pref"
      }
      close $pfp
    }
    typemethod _Cancel {} {
      $dialog withdraw
      return [$dialog enddialog cancel]
    }
    typemethod edit {args} {
      $type _createdialog
      set parent [from args -parent .]
      $dialog configure -parent $parent
      wm transient [winfo toplevel $dialog] [winfo toplevel $parent]
      foreach pattern [array names _preferences] {
	foreach {name class default widget configscript} \
				"$_preferences($pattern)" {break}   
	set value [$type get $parent $name $class]
	puts stderr "*** $type edit: name = '$name', widget = '$widget', value = '$value'"
	$widget configure -text "$value"
      }
      return [$dialog draw]
    }
  }
}

package provide TKSessionPreferences 1.0

