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

namespace Poiguides.View {
    
  class PageConfig {
    Box box;
    Elm.Object[] gui_elements = {};
    
    unowned ViewMain view_main;
    
    public PageConfig(ViewMain view, Elm.Object parent) {
      view_main = view;
      
      generate_view(parent);
    }
    
    public unowned Elm.Object get_content() {
      return box;
    }
    
    private void generate_view(Elm.Object parent) {
      box = new Box(parent);
      box.size_hint_weight_set(1.0, 1.0);
      box.homogenous_set( false );
      box.show();
      
      Label l = new Label(parent);
      l.label_set("Configuration");
      l.scale_set( 2 );
      l.show();
      box.pack_end(l);
      gui_elements += (owned) l;
      
      Button btn = new Button(parent);
      btn.size_hint_weight_set(1.0, -1.0);
      btn.size_hint_align_set(-1, 1);
      btn.label_set("Save");
      btn.show();
      box.pack_end(btn);
      btn.smart_callback_add("clicked", view_main.controller.callback_config_save );
      gui_elements += (owned) btn;
      
    }
  }
  
}