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

namespace Poiguides {
  
  class Controller {
    View.ViewMain view_main;
    
    Model.BoundingBox bounding_box;
    Model.Pois pois;
    
    /* Constructor */
    public Controller() {
      // Initialize model
      bounding_box = new Model.BoundingBox();
      pois = new Model.Pois();
      
      // Initialize view
      view_main = new View.ViewMain(this);
    }
    
    public void run_program() {
      view_main.show_main_window();
      Elm.run();
    }
    
    //--- Callbacks ---
    public void callback_close_window() {
      Elm.exit();
    }
    public void callback_show_categories() {
      view_main.show_categories_window();
    }
    public void callback_show_download() {
      view_main.show_download_window(bounding_box);
    }
    public void callback_show_about() {
      view_main.show_about_window();
    }
    
    public void callback_download_back() {
      bounding_box.set_boundingbox_a(view_main.download_window.get_boundingbox());
      view_main.show_main_window();
    }
    public void callback_download_pois() {
      bounding_box.set_boundingbox_a(view_main.download_window.get_boundingbox());
      pois.download_new(bounding_box);
      view_main.show_downloading_window(pois);
    }
    public void callback_downloading_done() {
      view_main.show_main_window();
    }
    
    public void callback_about_back() {
      view_main.pager.content_pop();
      view_main.about_window=null;
    }
    
    public void callback_categories_back() {
      view_main.show_main_window();
    }
  }
  
}
