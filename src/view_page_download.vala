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
    
    class PageDownload {
      Box outer_bx;
      TitleEntry[] entries;
      Elm.Object[] gui_elements = {};
      
      unowned ViewMain view_main;
      Model.BoundingBox bounding_box;
      
      public PageDownload(ViewMain view, Elm.Object parent, Model.BoundingBox bb) {
        view_main = view;
        bounding_box = bb;
        
        generate_view(parent);
      }
      
      public unowned Elm.Object get_content() {
        return outer_bx;
      }
      
      public string[] get_boundingbox() {
        string[] str = new string[4];
        for(int i=0; i<4; i++) {
          str[i] = entries[i].get_text();
        }
        return str;
      }
      
      private void generate_view(Elm.Object parent) {
        outer_bx = new Box(parent);
        outer_bx.size_hint_weight_set(1.0, 1.0);
        outer_bx.homogenous_set( false );
        
        Label l = new Label(outer_bx);
        l.label_set("Download");
        l.scale_set( 2 );
        l.show();
        outer_bx.pack_end(l);
        gui_elements += (owned) l;
        
        Scroller s = new Scroller(parent);
        s.policy_set(ScrollerPolicy.OFF,ScrollerPolicy.ON);
        s.size_hint_weight_set(1.0,1.0);
        s.bounce_set(false, true);
        s.size_hint_align_set(-1, -1);
        Box sb = new Box(parent);
        sb.size_hint_weight_set(1.0, 1.0);
        sb.homogenous_set( false );
        
        Toggle t = new Toggle(parent);
        t.label_set("Download from");
        t.states_labels_set("radius","box");
        
        sb.pack_end(t);
        t.show();
        gui_elements += (owned) t;
        
        // Entries
        string[] bb = bounding_box.get_boundingbox();
        entries = new TitleEntry[4];
        entries[0] = new TitleEntry(outer_bx, "Top", bb[0]);
        entries[1] = new TitleEntry(outer_bx, "Right", bb[1]);
        entries[2] = new TitleEntry(outer_bx, "Bottom", bb[2]);
        entries[3] = new TitleEntry(outer_bx, "Left", bb[3]);
        sb.pack_end(entries[0].get_content());
        
        Box b = new Box(outer_bx);
        b.horizontal_set( true );
        b.homogenous_set( true );
        b.pack_end(entries[3].get_content());
        b.pack_end(entries[1].get_content());
        b.show();
        sb.pack_end(b);
        gui_elements += (owned) b;
        
        sb.pack_end(entries[2].get_content());
        
        sb.show();
        s.content_set(sb);
        s.show();
        outer_bx.pack_end(s);
        gui_elements += (owned) sb;
        gui_elements += (owned) s;
        
        Button btn_download_pois = new Button(parent);
        btn_download_pois.size_hint_weight_set(1.0, -1.0);
        btn_download_pois.size_hint_align_set(-1, -1);
        btn_download_pois.label_set("Download/Update pois");
        btn_download_pois.show();
        outer_bx.pack_end(btn_download_pois);
        btn_download_pois.smart_callback_add("clicked", view_main.controller.callback_download_pois );
        gui_elements += (owned) btn_download_pois;
        
        Button btn_back = new Button(outer_bx);
        btn_back.size_hint_weight_set(1.0, -1.0);
        btn_back.size_hint_align_set(-1, -1);
        btn_back.label_set("Back");
        btn_back.show();
        outer_bx.pack_end(btn_back);
        btn_back.smart_callback_add("clicked", view_main.controller.callback_download_back );
        gui_elements += (owned) btn_back;
      }
    }
    
    
    private class TitleEntry {
      Entry entry;
      Frame f;
      
      public TitleEntry(Elm.Object? parent, string _title, string _default_value) {
        f = new Frame(parent);
        f.size_hint_weight_set(1.0, 1.0);
        f.label_set( _title );
        f.show();
        
        entry = new Entry(parent);
        entry.entry_set(_default_value);
        entry.show();
        
        f.content_set(entry);
      }
      
      public unowned Elm.Object get_content() {
        return f;
      }
      
      public string get_text() {
        return entry.entry_get();
      }
    }
    
  }
}