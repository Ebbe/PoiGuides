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
    
    class ViewMain {
      Win win;
      Bg bg;
      Pager pager;
      PageMain main_window;
      public PageDownload? download_window = null;
      PageDownloading pd;
      
      public Controller controller;
      
      public ViewMain(Controller con) {
        controller = con;
        generate_window();
        
        main_window = new PageMain(this,win);
        pager.content_push( main_window.get_content() );
      }
      
      public void show_main_window() {
        pager.content_promote( main_window.get_content() );
      }
      
      public void show_download_window(Model.BoundingBox bounding_box) {
        if( download_window == null ) {
          download_window = new PageDownload(this, pager, bounding_box);
          pager.content_push(download_window.get_content());
        } else {
          pager.content_promote( download_window.get_content() );
        }
        
      }
      public void show_downloading_window(Model.Pois pois) {
        pd = new PageDownloading(this,win,pois);
        pager.content_push(pd.get_content());
      }
      
      private void generate_window() {
        win = new Win(null, "main", WinType.BASIC);
        win.title_set("PoiGuides");
        
        bg = new Bg(win);
        bg.size_hint_weight_set(1.0, 1.0);
        bg.show();
        win.resize_object_add(bg);
        
        pager = new Pager(win);
        pager.size_hint_weight_set(1.0, 1.0);
        pager.show();
        win.resize_object_add(pager);
        
        win.show();
        
        set_callbacks();
      }
      
      private void set_callbacks() {
        win.smart_callback_add("delete-request", controller.callback_close_window );
      }
    }
    
  }
}