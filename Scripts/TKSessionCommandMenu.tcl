#* 
#* ------------------------------------------------------------------
#* TKSessionCommandMenu.tcl - Command Menu procedures
#* Created by Robert Heller on Sat Mar 17 13:39:36 2007
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
package require Tk
package require BWidget

namespace eval TKSessionCommandMenu {
  snit::widgetadaptor MenuItemProperties {
    typevariable _labelWidth 10
    typevariable _AvailableWindows {}
    component itemlabelLE
    component commandLE
    option -treeid -default {}
    option -tree   -default {}
    option -isnew  -default no
    delegate option -parent to hull
    constructor {args} {
      installhull using Dialog::create -title "Properties" -transient yes \
				       -modal none -default 0 -cancel 1 \
				       -side bottom
      $hull add -name ok     -text OK     -command [mymethod _OK]
      $hull add -name cancel -text Cancel -command [mymethod _Cancel]
      $hull add -name help   -text Help   -command [list ::HTMLHelp::HTMLHelp help "Item Properties"]
      set frame [$hull getframe]
      $self configurelist $args
      switch $options(-isnew) {
	no {
	  set itemLabel "[$options(-tree) itemcget $options(-treeid) -text]"
	  set itemData  "[$options(-tree) itemcget $options(-treeid) -data]"
	}
	newcommand {
	  set itemLabel "New Command"
	  set itemData  [list {} 0]
	}
	newcascade {
	  set itemLabel "New Cascade"
	  set itemData  [list {} 1]
	}
      }
      install itemlabelLE using LabelEntry::create $frame.itemlabelLE \
					-label "Item Label:" \
					-labelwidth $_labelWidth \
					-text "$itemLabel"
      pack $itemlabelLE -fill x
      install commandLE using LabelEntry::create $frame.commandLE \
					-label "Command:" \
					-labelwidth $_labelWidth \
					-text "[lindex $itemData 0]"
      if {![lindex $itemData 1]} {
	pack $commandLE -fill x
      }
      set parent [$hull cget -parent]
      if {[string equal "$parent"  {}]}  {set parent .}
      wm transient [winfo toplevel $win] [winfo toplevel $parent]
      $hull draw
    }
    method draw {args} {
      $self configurelist $args
      catch {pack forget $commandLE}
      switch $options(-isnew) {
	no {
	  set itemLabel "[$options(-tree) itemcget $options(-treeid) -text]"
	  set itemData  "[$options(-tree) itemcget $options(-treeid) -data]"
	}
	newcommand {
	  set itemLabel "New Command"
	  set itemData  [list {} 0]
	}
	newcascade {
	  set itemLabel "New Cascade"
	  set itemData  [list {} 1]
	}
      }
      $itemlabelLE configure -text "$itemLabel"
      $commandLE   configure -text "[lindex $itemData 0]"
      if {![lindex $itemData 1]} {
	pack $commandLE -fill x
      }
      
      set parent [$hull cget -parent]
      if {[string equal "$parent"  {}]}  {set parent .}
      wm transient [winfo toplevel $win] [winfo toplevel $parent]
      set index [lsearch $_AvailableWindows $self]
      if {$index == 0} {
	set _AvailableWindows [lrange $_AvailableWindows 1 end]
      } elseif {$index > 0} {
	set _AvailableWindows [lreplace $_AvailableWindows $index $index]
      }
      $hull draw
    }           
    method _OK {} {
      switch $options(-isnew) {
	no {
	  $options(-tree) itemconfigure $options(-treeid) -text \
			"[$itemlabelLE cget -text]"
	  set itemData  "[$options(-tree) itemcget $options(-treeid) -data]"
	  if {![lindex $itemData 1]} {
	    $options(-tree) itemconfigure $options(-treeid) -data \
		[list "[$commandLE cget -text]" 0]
	  }
	}
	newcommand {
	  if {"$options(-treeid)" eq "root"} {
	    set iscascade yes
	  } else {
	    set iscascade [lindex [$options(-tree) itemcget $options(-treeid) -data] 1]
	  }
	  if {$iscascade} {
	    set parent $options(-treeid)
	    set index end
	  } else {
	    set parent [$options(-tree) parent $options(-treeid)]
	    set index [$options(-tree) index $options(-treeid)]
	  }
	  $options(-tree) insert $index $parent #auto \
		-text "[$itemlabelLE cget -text]" \
		-data [list "[$commandLE cget -text]" 0]
	}
	newcascade {
	  if {"$options(-treeid)" eq "root"} {
	    set iscascade yes
	  } else {
	    set iscascade [lindex [$options(-tree) itemcget $options(-treeid) -data] 1]
	  }
	  if {$iscascade} {
	    set parent $options(-treeid)
	    set index end
	  } else {
	    set parent [$options(-tree) parent $options(-treeid)]
	    set index [$options(-tree) index $options(-treeid)]
	  }
	  $options(-tree) insert $index $parent #auto \
		-text "[$itemlabelLE cget -text]" \
		-data [list {} 1]
	}
      }
      $hull withdraw
      $hull enddialog ok
      lappend _AvailableWindows $self		
    }
    method _Cancel {} {
      $hull withdraw
      $hull enddialog cancel
      lappend _AvailableWindows $self		
    }
    typemethod showproperties {args} {
      if {[llength $_AvailableWindows] == 0} {
	eval [list $type create .itemProperties%AUTO%] $args
      } else {
	eval [list [lindex $_AvailableWindows 0] draw] $args
      }
    }
  }
  snit::type CommandMenu {
    pragma -hastypeinfo    no
    pragma -hastypedestroy no
    pragma -hasinstances   no

    typecomponent _topmenu
    typemethod settopmenu {menu} {set _topmenu $menu}
    typecomponent _pipe
    typemethod setpipe {pipe} {set _pipe $pipe}
    typemethod reload {menufile} {
      $type unload
      $type load "$menufile"
    }
    typemethod unload {} {
      catch {$type _unload $_topmenu}
    }
    typemethod _unload {menu} {
      for {set i [$menu index end]} {$i >= 0} {incr i -1} {
	if {![catch "$menu entrycget $i -menu" submenu]} {
	  catch {$type _unload $submenu}
	  catch {destroy $submenu}
	}
	catch {$menu delete $i}
      }
    }
    typemethod load {menufile} {
      if {[catch {open "$menufile" r} fp]} {
	tk_messageBox -type ok -icon error -message "Could not open $menufile: $fp"
	return
      }
      set parentStack {}
      set parent $_topmenu
      while {[gets $fp line] >= 0} {
	if {[string index $line 0] == "\{"} {
	  set parentStack [linsert $parentStack 0 $parent]
	  set label [string range $line 1 end]
	  set newmenu [join [list $parent [$type _fixlabel $label]] "."]
	  $parent add cascade -label $label  -menu  $newmenu
	  menu $newmenu -tearoff 0
	  set parent $newmenu
        } elseif {[string index $line 0] == "\}"} {
	  if {[llength $parentStack] > 0} {
	    set parent [lindex $parentStack 0]
	    set parentStack [lrange $parentStack 1 end]
	  }
	} elseif {[string index $line 0] != "!"} {
	  set label $line
	  if {[gets $fp line] >= 0} {
	    set command [split $line]
	    $parent add command -label $label \
				-command [mytypemethod _run "$command"]
	  }
	}
      }
    }
    typemethod _fixlabel {label} {
      set label [join [split $label " "] "_"]
      set label [join [split $label "\t"] "_"]
      set c1 [string tolower [string range $label 0 0]]
      set label [join [list $c1 [string range $label 1 end]] ""]
      return $label
    } 
    typecomponent dialog;#	Edit menu dialog
    typecomponent  menuFilenameLF
    typecomponent    menuFilenameE;#	menu filename	
    typecomponent    menuFilenameB
    typecomponent  menuTF;#		the menu title frame
    typecomponent    menuTRscroll;#	the menu tree scroll window
    typecomponent      menuTR;#		the menu tree
    typecomponent  menuElementButtons;#	menu element buttons
    typevariable _labelWidth 15
    typevariable _menuFileTypes {
	{{Menu Files} .menu TEXT}
	{{All Files} * TEXT}
    }
    typemethod menufiletypes {} {return $_menuFileTypes}
    typeconstructor {
      set dialog {}
    }
    typemethod _createdialog {} {
      if {"$dialog" ne "" && [winfo exists $dialog]} {return}
      set dialog [Dialog::create .editMenuDialog \
			-title {Menu} \
			-transient yes -modal none \
			-default 0 -cancel 2 \
			-side bottom]
      $dialog add -name ok     -text OK     -command [mytypemethod _OK]
      $dialog add -name apply  -text Save   -command [mytypemethod _Save]
      $dialog add -name cancel -text Cancel -command [mytypemethod _Cancel]
      $dialog add -name help   -text Help   -command [list ::HTMLHelp::HTMLHelp help "Edit Command Menu"]
      set frame [$dialog getframe]
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
      set menuTF [TitleFrame::create $frame.menuTF -text "Menu Tree" \
						   -side center]
      pack $menuTF -expand yes -fill both
      set menuTRscroll [ScrolledWindow::create [$menuTF getframe].menuTRscroll \
				-auto both -scrollbar both]
      pack $menuTRscroll -expand yes -fill both
      set menuTR [Tree::create [$menuTRscroll getframe].menuTR \
			-selectfill yes \
			-dragevent 1 \
			-dragenabled yes \
			-dropenabled yes \
			-dropovermode  np \
			-dropovercmd [mytypemethod _DropOver] \
			-dropcmd [mytypemethod _Drop] \
			-draginitcmd [mytypemethod _DragInit] \
			-dragendcmd [mytypemethod _DragEnd] \
			-selectcommand [mytypemethod _MenuSelectChanged]]
      

      pack $menuTR -expand yes -fill both
      $menuTRscroll setwidget $menuTR
      set menuElementButtons [ButtonBox::create $frame.menuElementButtons \
					-homogeneous yes -orient horizontal]
      pack $menuElementButtons -fill x
      $menuElementButtons add -name insert -text {Insert Command} \
					   -command [mytypemethod _InsertCommand]
      $menuElementButtons add -name insert -text {Insert Cascade} \
					   -command [mytypemethod _InsertCascade]
      $menuElementButtons add -name delete -text {Delete} \
					   -command [mytypemethod _Delete] \
					   -state disabled
      $menuElementButtons add -name properties -text {Properties} \
					   -command [mytypemethod _Properties] \
					   -state disabled
    }
    typemethod _InsertCommand {} {
      set sel [$menuTR selection get]
      if {[llength $sel] == 0} {
	set id root
      } else {
	set id [lindex $sel 0]
      }
      TKSessionCommandMenu::MenuItemProperties showproperties \
		-tree $menuTR -treeid $id -isnew newcommand \
		-parent $dialog
    }
    typemethod _InsertCascade {} {
      set sel [$menuTR selection get]
      if {[llength $sel] == 0} {
	set id root
      } else {
	set id [lindex $sel 0]
      }
      TKSessionCommandMenu::MenuItemProperties showproperties \
		-tree $menuTR -treeid $id -isnew newcascade \
		-parent $dialog
    }
    typemethod _Delete {} {
      set sel [$menuTR selection get]
      if {[llength $sel] == 0} {return}
      $menuTR delete $sel
    }
    typemethod _Properties {} {
      set sel [$menuTR selection get]
      if {[llength $sel] == 0} {return}
      set id [lindex $sel 0]
      TKSessionCommandMenu::MenuItemProperties showproperties -tree $menuTR \
			-treeid $id -isnew no -parent $dialog
    }
    typemethod _DragInit {tree identifier toplevel} {
      pack [Label::create $toplevel.id -text "[$tree itemcget $identifier -text]" -background yellow]
      return [list TREE_NODE [list move] $identifier]
    }
    typemethod _DragEnd {dragsource droptarget op datatype data result} {
#      puts stderr "*** $type _DragEnd: op = $op, datatype = $datatype, data = '$data', result = '$result'"
      if {$result == 0} {
	return
      } else {
        $menuTR delete $data
      }
    }
    typemethod _Drop {dest source target op datatype data} {
#      puts stderr "*** $type _Drop: dest = $dest, source = $source, target = '$target', op = $op datatype = $datatype, data = $data"
      if {[string equal "$dest" "$menuTR"] &&
	  [string equal [winfo parent "$source"] "$menuTR"]} {
	switch [lindex $target 0] {
	  node {
	    set targetid [lindex $target 1]
	    set targetdata [$menuTR itemcget $targetid -data]
	    set iscascade  [lindex $targetdata 1]
	    if {!$iscascade} {
	      $type _CopyItemTo $data [$menuTR parent $targetid] [$menuTR index $targetid]
	    } else {
	      $type _CopyItemTo $data $targetid end
	    }
            return 1
	  }
	  position {
	    $type _CopyItemTo $data [lindex $target 1] [lindex $target 2]
	    return 1
	  }
        }
      } else {
	return 0
      }
    }
    typemethod  _CopyItemTo {sourceID parent index} {
      set sourceText [$menuTR itemcget $sourceID -text]
      set sourceData [$menuTR itemcget $sourceID -data]
      
      set sourceIsCascade [lindex $sourceData 1]
      set newId [$menuTR insert $index $parent #auto \
			-text "$sourceText" -data $sourceData]
      if {$sourceIsCascade} {
	foreach child [$menuTR nodes $sourceID] {
	  $type _CopyItemTo $child $newId end
	}
      }
    }
    typemethod _DropOver {dest source target op datatype data} {
#      puts stderr "*** $type _DropOver: target = '$target', op = $op datatype = $datatype, data = $data"
      set prefered position
      foreach {widget targetednode nodewithposition prefered} "$target" {break}
      return [list 3 $prefered]
    }
    typemethod _run {commandlist} {
      #puts stderr "*** $type _run $commandlist"
      if {![catch {$_pipe cget -name} pipename]} {
        #puts stderr "*** $type _run: have pipe"
	eval exec $commandlist >& $pipename &
      } else {
        #puts stderr "*** $type _run: don't have pipe"
	eval exec $commandlist >@ stdout 2>@ stderr &
      }
    }
    typemethod _BrowseMenuFiles {} {
      set newfile [tk_getSaveFile -parent $dialog -title "Menu Filename" \
				  -defaultextension .menu \
				  -filetypes [TKSessionCommandMenu::CommandMenu \
							menufiletypes] \
				  -initialfile "[$menuFilenameE cget -text]"]
      if {[string length "$newfile"] > 0} {
	$menuFilenameE configure -text "$newfile"
      }
    }
    typemethod _OK {} {
      if {![$type _Save]} {
	if {![tk_messageBox -type yesno -icon question -message "Menu not save, close anyway?"]} {
	  return
	}
      }
      $dialog withdraw
      return [$dialog enddialog ok]
    }
    typemethod _Save {} {
      set menufile "[$menuFilenameE cget -text]"
      if {[string length "$menufile"] ==  0} {
	tk_messageBox -type ok -icon warning  -message "Please select a file first!"
	return 0
      }
      if {[catch {open "$menufile" w} fp]} {
	tk_messageBox -type ok -icon error -message "Cannot open $menufile: $fp"
	return 0
      }
      $type _WriteMenuFile root $fp
      close $fp
      return 1
    }
    typemethod _WriteMenuFile {parent fp} {
      foreach node [$menuTR nodes $parent] {
	set label "[$menuTR itemcget $node -text]"
	set data   [$menuTR itemcget $node -data]
	if {[lindex $data 1]} {
	  puts $fp "\{$label"
	  $type _WriteMenuFile $node $fp
	  puts $fp "\}"
	} else {
	  puts $fp "$label"
	  puts $fp "[lindex $data 0]"
        }
      }
    }
    typemethod _Cancel {} {
      $dialog withdraw
      return [$dialog enddialog cancel]
    }
    typemethod edit {args} {
      $type _createdialog
      set parent [from args -parent .]
      $dialog configure -parent $parent
      wm transient [winfo  toplevel $dialog] [winfo toplevel $parent]
      $menuTR delete [$menuTR  nodes root]
      $type _menuToTree $_topmenu $menuTR root
      return [$dialog draw]
    }
    typemethod _menuToTree {menu tree parent} {
      set last [$menu index last]
      if {[string equal $last none]} {return}
      for {set i 0} {$i <= $last} {incr i} {
	set itemid [$tree insert end $parent #auto \
			-text [$menu entrycget $i -label]]
	if {[catch "$menu entrycget $i -menu" submenu]} {
	  set tclcommand [$menu entrycget $i -command]
	  set shellcommand "[lindex $tclcommand end]"
	  $tree itemconfigure $itemid -data [list "$shellcommand" 0]
	} else {
	  $type _menuToTree $submenu $tree $itemid
	  $tree itemconfigure $itemid -data [list {} 1]
	}
      }
    }
    typemethod _MenuSelectChanged {args} {
      set selection [$menuTR selection get]
      if {[llength $selection] == 0} {
	$menuElementButtons itemconfigure delete -state disabled
	$menuElementButtons itemconfigure properties -state disabled
      } else {
	$menuElementButtons itemconfigure delete -state normal
	$menuElementButtons itemconfigure properties -state normal
      }
    }
  }  
}



package provide TKSessionCommandMenu 1.0
