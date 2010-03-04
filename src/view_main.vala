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
      public Pager pager;
      PageMain main_window;
      public PageCategories? categories_window = null;
      public PageDownload? download_window = null;
      public PagePoi? poi_window = null;
      public PageAbout about_window;
      public PageConfig? config_window = null;
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
      
      public void show_categories_window() {
        poi_window = null;
        if( categories_window == null ) {
          categories_window = new PageCategories(this, controller.pois, pager);
          pager.content_push(categories_window.get_content());
        } else {
          pager.content_promote( categories_window.get_content() );
        }
      }
      
      public void show_poi_window(Model.PoiNode poi) {
        poi_window = new PagePoi(this,poi,win);
        pager.content_push( poi_window.get_content() );
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
      
      public void show_config_window() {
        if( config_window == null ) {
          config_window = new PageConfig(this, pager);
          pager.content_push(config_window.get_content());
        } else {
          pager.content_promote( config_window.get_content() );
        }
      }
      
      public void show_about_window() {
        about_window = new PageAbout(this,win);
        pager.content_push( about_window.get_content() );
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
