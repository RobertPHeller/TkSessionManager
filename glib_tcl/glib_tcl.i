/* -*- C -*- ****************************************************************
 *
 *  System        : 
 *  Module        : 
 *  Object Name   : $RCSfile$
 *  Revision      : $Revision$
 *  Date          : $Date$
 *  Author        : $Author$
 *  Created By    : Robert Heller
 *  Created       : Sun May 30 18:36:00 2021
 *  Last Modified : <210531.1115>
 *
 *  Description	
 *
 *  Notes
 *
 *  History
 *	
 ****************************************************************************
 *
 *    Copyright (C) 2021  Robert Heller D/B/A Deepwoods Software
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




%module Glibtcl
%{
    static const char rcsid[] = "@(#) : $Id$";
#include <glib/gi18n.h>
#include <glib.h>
#include <gio/gio.h>

#include <dbus/dbus.h>
#include <dbus/dbus-glib.h>
#include <dbus/dbus-glib-bindings.h>
#include <dbus/dbus-glib-lowlevel.h>
    
#undef SWIG_name
#define SWIG_name "GlibTcl"
#undef SWIG_version
#define SWIG_version "1.0"
    typedef int bool;
#define true 1
#define false 0
%}

%include typemaps.i

%apply char * {gchar *};
%apply unsigned int {GType};
%apply long long int {gint64};
%apply unsigned long long int {guint64};
%apply double {gdouble};
%apply int {gint};
%apply unsigned int {guint};
%apply bool {gboolean};

%typemap(in) const gchar * const * {
    Tcl_Obj **objv;
    int objc, i;
    int status = Tcl_ListObjGetElements(interp,$input,&objc,&objv);
    if (status != TCL_OK) return status;
    $1 = (gchar **)g_try_malloc0_n(objc,sizeof(gchar *));
    if ($1 == NULL) {
        Tcl_SetResult(interp,"Out of memory",TCL_STATIC);
        return TCL_ERROR;
    }
    for (i = 0; i < objc; i++) {
        int l;
        char *s = Tcl_GetStringFromObj(objv[i],&l);
        $1[i] = (gchar *)g_try_malloc0((l+1)*sizeof(gchar));
        if ($1[i] == NULL) {
            Tcl_SetResult(interp,"Out of memory",TCL_STATIC);
            g_strfreev($1);
            return TCL_ERROR;
        }
        g_strlcpy($1[i],s,l+i);
    }
}

%typemap(freearg) const gchar * const * {
    g_strfreev($1);
}

%typemap(out) gchar ** {
    Tcl_Obj *element, *listresult = Tcl_NewListObj(0,NULL);
    int i;
    for (i = 0; $1[i]; i++) {
        element = Tcl_NewStringObj($1[i],-1);
        int status = Tcl_ListObjAppendElement(interp,listresult,element);
        if (status != TCL_OK) {
            g_strfreev($1);
            return status;
        }
    }
    Tcl_SetObjResult(interp,listresult);
    g_strfreev($1);
}
    
        

GType                   g_settings_get_type                             (void);

GSettings *             g_settings_new                                  (const gchar        *schema_id);
GSettings *             g_settings_new_with_path                        (const gchar        *schema_id,
                                                                         const gchar        *path);
GSettings *             g_settings_new_with_backend                     (const gchar        *schema_id,
                                                                         GSettingsBackend   *backend);
GSettings *             g_settings_new_with_backend_and_path            (const gchar        *schema_id,
                                                                         GSettingsBackend   *backend,
                                                                         const gchar        *path);
GSettings *             g_settings_new_full                             (GSettingsSchema    *schema,
                                                                         GSettingsBackend   *backend,
                                                                         const gchar        *path);
void                    g_settings_reset                                (GSettings          *settings,
                                                                         const gchar        *key);

gint                    g_settings_get_int                              (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_int                              (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         gint                value);
gint64                  g_settings_get_int64                            (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_int64                            (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         gint64              value);
guint                   g_settings_get_uint                             (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_uint                             (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         guint               value);
guint64                 g_settings_get_uint64                           (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_uint64                           (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         guint64             value);
gchar *                 g_settings_get_string                           (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_string                           (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         const gchar        *value);
gboolean                g_settings_get_boolean                          (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_boolean                          (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         gboolean            value);
gdouble                 g_settings_get_double                           (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_double                           (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         gdouble             value);
gchar **                g_settings_get_strv                             (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_strv                             (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         const gchar *const *value);
gint                    g_settings_get_enum                             (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_enum                             (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         gint                value);
guint                   g_settings_get_flags                            (GSettings          *settings,
                                                                         const gchar        *key);
gboolean                g_settings_set_flags                            (GSettings          *settings,
                                                                         const gchar        *key,
                                                                         guint               value);
GSettings *             g_settings_get_child                            (GSettings          *settings,
                                                                         const gchar        *name);

gboolean                g_settings_is_writable                          (GSettings          *settings,
                                                                         const gchar        *name);

void                    g_settings_delay                                (GSettings          *settings);
void                    g_settings_apply                                (GSettings          *settings);
void                    g_settings_revert                               (GSettings          *settings);
gboolean                g_settings_get_has_unapplied                    (GSettings          *settings);
void                    g_settings_sync                                 (void);

#define gpointer GSettings *

gpointer    g_object_ref                      (gpointer        object);
void        g_object_unref                    (gpointer        object);
