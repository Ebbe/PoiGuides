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
      
      unowned ViewMain view_main;
      
      public PageCategories(ViewMain view, Model.Pois _pois, Elm.Object parent) {
        view_main = view;
        pois = _pois;
        
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
        
        title = new Label(outer_bx);
        title.label_set("Categories");
        title.scale_set( 2 );
        title.show();
        outer_bx.pack_end(title);
        
        list = new Elm.List(outer_bx);
        list.horizontal_mode_set(ListMode.SCROLL);
        list.multi_select_set(false);
        list.size_hint_weight_set(1.0, 1.0);
        list.size_hint_align_set(-1, -1);
        list.show();
        outer_bx.pack_end(list);
        fill_list();
        
        btn_ok = new Button(outer_bx);
        btn_ok.size_hint_weight_set(1.0, -1.0);
        btn_ok.size_hint_align_set(-1, -1);
        btn_ok.label_set("Back");
        btn_ok.show();
        outer_bx.pack_end(btn_ok);
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        btn_ok.smart_callback_add("clicked", view_main.controller.callback_categories_back );
      }
      
      private void fill_list() {
        items = new ListItem[Model.list_of_allowed_categories.length];
        int i = 0;
        foreach( string category in Model.list_of_allowed_categories ) {
          stdout.printf("* %s\n",category);
          items[i++] = list.append(category, null, null, null);
        }
        list.go();
      } 
    }
    
  }
}
