#* 
#* ------------------------------------------------------------------
#* TKSessionPipeIO.tcl - Pipe I/O
#* Created by Robert Heller on Sat Mar 17 20:29:16 2007
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
#*     Copyright (C) 2005  Robert Heller D/B/A Deepwoods Software
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

namespace eval TKSessionPipeIO {
  snit::type Pipe {
    option -textoutput -readonly yes -default {}
    option -name -readonly yes -default pipe
    component _pipeFP
    constructor {args} {
      $self configurelist $args
      catch {file delete "$options(-name)"}
      if {[catch "exec mkfifo $options(-name)" error]} {
	#puts stderr "*** $type create $self: mkfifo failed: $error"
	set _pipeFP {}
      } else {
	set _pipeFP [open "$options(-name)" {RDONLY NONBLOCK} 0x006]
	#puts stderr "*** $type create $self: _pipeFP = $_pipeFP"
	fconfigure $_pipeFP -blocking 0
	fileevent $_pipeFP readable [mymethod _ReadMenuPipe]
      }
    }
    method _ReadMenuPipe {} {
      #puts stderr "*** $self _ReadMenuPipe"
      if {[gets $_pipeFP line] >= 0} {
        #puts stderr "*** $self _ReadMenuPipe: line = '$line'"
	if {[winfo exists "$options(-textoutput)"]} {
	  $options(-textoutput) insert end "$line\n"
	  $options(-textoutput) see end
	  update idle
        }
      } else {
	catch {close $_pipeFP}
	set _pipeFP [open "$options(-name)" {RDONLY NONBLOCK} 0x006]
	fconfigure $_pipeFP -blocking 0
	fileevent $_pipeFP readable [mymethod _ReadMenuPipe]
      }
    }
    destructor {
      catch {close $_pipeFP}
      catch {file delete "$options(-name)"}
    }
  }
}



package provide TKSessionPipeIO 1.0
