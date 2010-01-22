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

namespace Poiguides {
  namespace View {
    
    class PageCategories {
      Box outer_bx;
      Label title;
      
      Button btn_ok;
      
      unowned ViewMain view_main;
      
      public PageCategories(ViewMain view, Elm.Object parent) {
        view_main = view;
        
        generate_view(parent);
      }
      
      public unowned Elm.Object get_content() {
        return outer_bx;
      }
      
      public void generate_view(Elm.Object parent) {
        outer_bx = new Box(parent);
        outer_bx.size_hint_weight_set(1.0, 1.0);
        outer_bx.homogenous_set( false );
        outer_bx.show();
        
        title = new Label(outer_bx);
        title.label_set("Categories");
        title.scale_set( 2 );
        title.show();
        outer_bx.pack_end(title);
        
        
        
        btn_ok = new Button(outer_bx);
        btn_ok.size_hint_weight_set(1.0, 1.0);
        btn_ok.size_hint_align_set(-1, -1);
        btn_ok.label_set("Back");
        btn_ok.show();
        outer_bx.pack_end(btn_ok);
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        btn_ok.smart_callback_add("clicked", view_main.controller.callback_categories_back );
      }
    }
    
  }
}
