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
using Gee;

namespace Poiguides {
  namespace View {
    
    class PageCategories {
      Box outer_bx;
      Label title;
      Elm.List list;
      ListItem[] items;
      Button btn_ok;
      Model.Pois pois;
      
      Model.PoiGroup current_poi_group;
      
      unowned ViewMain view_main;
      
      public PageCategories(ViewMain view, Model.Pois _pois, Elm.Object parent) {
        view_main = view;
        pois = _pois;
        
        current_poi_group = pois.top_level_poi_group;
        
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
        title.show();
        outer_bx.pack_end(title);
        
        list = new Elm.List(parent);
        list.horizontal_mode_set(ListMode.SCROLL);
        list.multi_select_set(false);
        list.size_hint_weight_set(1.0, 1.0);
        list.size_hint_align_set(-1, -1);
        list.show();
        outer_bx.pack_end(list);
        fill_list();
        
        btn_ok = new Button(parent);
        btn_ok.size_hint_weight_set(1.0, -1.0);
        btn_ok.size_hint_align_set(-1, -1);
        btn_ok.label_set("Back");
        btn_ok.show();
        outer_bx.pack_end(btn_ok);
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        btn_ok.smart_callback_add("clicked", back_click );
        list.smart_callback_add("clicked", list_click );
      }
      
      private void fill_list() {
        items = new ListItem[current_poi_group.number_of_children()];
        int i = 0;
        foreach( string category in current_poi_group.get_children() ) {
          items[i++] = list.append(category, null, null, null);
        }
        list.go();
        title.label_set(current_poi_group.human_readable_path());
      }
      
      private void list_click() {
        if(current_poi_group.contain_leafs)
          return; // TODO!
        else
          current_poi_group = current_poi_group.get_child(list.selected_item_get().label_get());
        fill_list();
      }
      private void back_click() {
        if(current_poi_group.top_level)
          view_main.controller.callback_categories_back();
        else {
          current_poi_group = current_poi_group.parent;
          fill_list();
        }
      }
      
      private string get_selection() {
        string returned_str = "";
        //bool first = true;
        //foreach(string s in current_poi_group) {
        //  if(first)
        //    returned_str += "|";
        //  returned_str += s;
        //  first = false;
        //}
        return returned_str;
      }
    }
    
  }
}