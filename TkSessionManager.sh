#!/bin/bash
dir=`dirname $0`
prog=`basename $0 .sh`
xrdb .Xresources
dbus-launch --exit-with-session $dir/$prog $* >>.xsession-errors 2>&1
