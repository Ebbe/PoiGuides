/*
    poiguides - Download pois, and show distance to them.
    Copyright (C) 2010 Esben Damgaard

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using Elm;
using DBus;

namespace Poiguides {
  namespace View {
    
    class PagePoi {
      Box outer_bx;
      Label title;
      Elm.List list;
      Button btn_ok;
      Button btn_to_navit;
      Button btn_center_navit;
      Model.PoiNode poi;
      Elm.Entry opening_hour_entry;
      
      
      unowned ViewMain view_main;
      
      public PagePoi(ViewMain view, Model.PoiNode _poi, Elm.Object parent) {
        view_main = view;
        poi = _poi;
        
        generate_view(parent);
      }
      
      public unowned Elm.Object get_content() {
        return outer_bx;
      }
      
      private void generate_view(Elm.Object parent) {
        outer_bx = new Box(parent);
        outer_bx.size_hint_weight_set(1.0, 1.0);
        outer_bx.homogenous_set( false );
        outer_bx.show();
        
        title = new Label(parent);
        title.scale_set( 1 );
        title.label_set(poi.human_name());
        title.show();
        outer_bx.pack_end(title);
        
        outer_bx.pack_end(opening_hours());
        
        btn_ok = new Button(parent);
        btn_ok.size_hint_weight_set(1.0, -1.0);
        btn_ok.size_hint_align_set(-1, -1);
        btn_ok.label_set("Back");
        btn_ok.show();
        outer_bx.pack_end(btn_ok);
        
        btn_to_navit = new Button(parent);
        btn_to_navit.size_hint_weight_set(1.0, -1.0);
        btn_to_navit.size_hint_align_set(-1, -1);
        btn_to_navit.label_set("Send to Navit");
        btn_to_navit.show();
        outer_bx.pack_end(btn_to_navit);
        
        btn_center_navit = new Button(parent);
        btn_center_navit.size_hint_weight_set(1.0, -1.0);
        btn_center_navit.size_hint_align_set(-1, -1);
        btn_center_navit.label_set("Locate in Navit");
        btn_center_navit.show();
        outer_bx.pack_end(btn_center_navit);
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        btn_ok.smart_callback_add("clicked", view_main.controller.callback_poi_back );
        btn_to_navit.smart_callback_add("clicked", to_navit );
        btn_center_navit.smart_callback_add("clicked", center_navit );
      }
      
      private weak Elm.Object opening_hours() {
        opening_hour_entry = new Entry(outer_bx);
        opening_hour_entry.single_line_set(false);
        opening_hour_entry.editable_set(false);
        opening_hour_entry.size_hint_align_set(-1, -1);
        opening_hour_entry.size_hint_weight_set(1.0, 1.0);
        opening_hour_entry.entry_set(poi.opening_hours.replace(";","<br>"));
        opening_hour_entry.show();
        
        return opening_hour_entry;
      }
      
      private void to_navit() {
        DBus.Connection conn;
        dynamic DBus.Object navit;
        
        conn = DBus.Bus.get (DBus.BusType. SESSION);
        navit = conn.get_object("org.navit_project.navit",
                        "/org/navit_project/navit/default_navit",
                        "org.navit_project.navit.navit");
        
        // TODO: Change from dynamic and remove --disable-dbus-transformation from Makefile.am
        navit.set_destination(poi.navit_format(),poi.name);
        //navit.call("set_destination",null,DBus.G_TYPE_STRING,"geo:10.4042 55.3784","hej");
      }
      
      private void center_navit() {
        DBus.Connection conn;
        dynamic DBus.Object navit;
        
        conn = DBus.Bus.get (DBus.BusType. SESSION);
        navit = conn.get_object("org.navit_project.navit",
                        "/org/navit_project/navit/default_navit",
                        "org.navit_project.navit.navit");
        
        // TODO: Change from dynamic and remove --disable-dbus-transformation from Makefile.am
        navit.set_center(poi.navit_format());
        //navit.call("set_destination",null,DBus.G_TYPE_STRING,"geo:10.4042 55.3784","hej");
      }
    }
    
    /*[DBus (name = "org.navit_project.navit.navit")]
    interface Navit : GLib.Object {
      public abstract void set_destination(string location, string name) throws DBus.Error;
      public abstract void set_center(string location) throws DBus.Error;
    }*/
  }
}
