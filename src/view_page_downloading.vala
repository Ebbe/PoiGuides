/*
    poiguides - Download pois, and show distance to them.
    Copyright (C) 2009 Esben Damgaard

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
    
    class PageDownloading {
      Box outer_bx;
      Button btn_ok;
      Label status;
      
      Model.Pois pois;
      ViewMain view_main;
      
      public PageDownloading(ViewMain view, Elm.Object parent, Model.Pois _pois) {
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
        outer_bx.homogenous_set( true );
        outer_bx.show();
        
        status = new Label(parent);
        status.label_set( "Downloaded %i pois.".printf(pois.get_number_of_downloaded()) );
        status.show();
        outer_bx.pack_end(status);
        
        btn_ok = new Button(outer_bx);
        btn_ok.size_hint_weight_set(1.0, 1.0);
        btn_ok.size_hint_align_set(-1, -1);
        btn_ok.label_set("Back");
        btn_ok.show();
        outer_bx.pack_end(btn_ok);
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        btn_ok.smart_callback_add("clicked", view_main.controller.callback_downloading_done );
      }
    }
    
  }
}