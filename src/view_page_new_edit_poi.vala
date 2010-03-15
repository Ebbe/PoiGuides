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

namespace Poiguides.View {
  
  const string CLICK_TO_SET = "Click to set";
  
  class PageNewEditPoi {
    Box box;
    Elm.Object[] gui_elements = {};
    Label lat;
    Label lon;
    public Model.PoiGroup poigroup;
    Evas.Callback signalback;
    ValueKeyView[] value_keys_view = {};
    weak Pager pager;
    
    public PageNewEditPoi(Model.PoiGroup _poigroup, Model.PoiNode? poi, Elm.Object parent, Evas.Callback _signalback, Pager _pager) {
      poigroup = _poigroup;
      signalback = _signalback;
      pager = _pager;
      
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
      l.label_set("New Poi");
      l.scale_set( 2 );
      l.show();
      box.pack_end(l);
      gui_elements += (owned) l;
      
      Scroller s = new Scroller(parent);
      s.policy_set(ScrollerPolicy.OFF,ScrollerPolicy.AUTO);
      s.size_hint_weight_set(1.0,1.0);
      s.size_hint_align_set(-1, -1);
      Box sb = new Box(parent);
      sb.size_hint_weight_set(1.0, 1.0);
      sb.homogenous_set( false );
      sb.show();
      s.show();
      generate_scroller_content(sb,parent);
      s.content_set(sb);
      box.pack_end(s);
      gui_elements += (owned) s;
      gui_elements += (owned) sb;
      
      Box btn_bx = new Box(parent);
      btn_bx.horizontal_set(true);
      btn_bx.homogenous_set(false);
      btn_bx.size_hint_weight_set(1,-1);
      btn_bx.size_hint_align_set(-1, -1);
      btn_bx.show();
      box.pack_end(btn_bx);
      
      Button btn = new Button(parent);
      btn.size_hint_weight_set(-1, -1);
      btn.size_hint_align_set(-1, -1);
      btn.label_set("Back");
      btn.show();
      btn_bx.pack_end(btn);
      btn.smart_callback_add("clicked", this.signalback );
      gui_elements += (owned) btn;
      
      btn = new Button(parent);
      btn.size_hint_weight_set(1, -1);
      btn.size_hint_align_set(-1, -1);
      btn.label_set("Save");
      btn.smart_callback_add("clicked", this.save_poi );
      btn.show();
      btn_bx.pack_end(btn);
      gui_elements += (owned) btn;
      gui_elements += (owned) btn_bx;
      
      update_gps_position();
    }
    
    private void save_poi() {
      /*string savable_string = "-1 %s %s".printf(lat.label_get(),lon.label_get());
      foreach(ValueKeyView key_value in value_keys_view) {
        savable_string += key_value.to_string();
      }
      debug(savable_string);*/
      
      Model.PoiNode tmp_poinode = new Model.PoiNode(-1, lat.label_get().to_double(), lon.label_get().to_double());
      foreach(ValueKeyView key_value in value_keys_view) {
        if( key_value.value_key()!=null )
          tmp_poinode.add_attribute(key_value.value_key()[0],key_value.value_key()[1]);
      }
      debug(tmp_poinode.saveable_string());
      Model.DownloadHelp.save_node((owned) tmp_poinode);
      
      signalback(null, null);
    }
    
    private void generate_scroller_content(Box container_box,Elm.Object parent) {
      // Show location
      Box bx = new Box(parent);
      bx.horizontal_set(true);
      bx.homogenous_set(false);
      //bx.size_hint_weight_set(1,-1);
      //bx.size_hint_align_set(-1, -1);
      bx.show();
      container_box.pack_end(bx);
      Label l = new Label(parent);
      l.label_set("Location:");
      l.show();
      bx.pack_end(l);
      gui_elements += (owned) l;
      Box bx2 = new Box(parent);
      bx2.show();
      lat = new Label(parent);
      lat.show();
      bx2.pack_end(lat);
      lon = new Label(parent);
      lon.show();
      bx2.pack_end(lon);
      bx.pack_end(bx2);
      
      Button btn = new Button(parent);
      btn.size_hint_weight_set(1, -1.0);
      btn.size_hint_align_set(-1, -1);
      btn.label_set("Update");
      btn.show();
      bx.pack_end(btn);
      btn.smart_callback_add("clicked", this.update_gps_position );
      gui_elements += (owned) btn;
      gui_elements += (owned) bx2;
      
      generate_type_selection(container_box,parent);
      generate_rest_selection(container_box,parent);
      gui_elements += (owned) bx;
    }
    private void generate_type_selection(Box container_box, Elm.Object parent) {
      ValueKeyView vkv = new ValueKeyView("Type","TYPE",poigroup,parent, pager, this);
      container_box.pack_end(vkv.get_content());
      value_keys_view += (owned) vkv;
    }
    
    private void generate_rest_selection(Box container_box, Elm.Object parent) {
      string[] attrs = poigroup.get_possible_attr().split_set("|");
      foreach(string attr in attrs) {
        if( attr=="" )
          continue;
        string[] key_value = attr.split_set("=");
        ValueKeyView vkv = new ValueKeyView(key_value[0],key_value[1],poigroup,parent, pager, this);
        container_box.pack_end(vkv.get_content());
        value_keys_view += vkv;
      }
    }
    
    private void update_gps_position() {
      Model.GPS.Coordinate c = Model.GPS.get_current_position();
      lat.label_set("%f".printf(c.lat));
      lon.label_set("%f".printf(c.lon));
    }
  }
  
  class ValueKeyView {
    weak Elm.Object parent;
    PageNewEditPoi origin;
    
    Box box;
    Button button;
    Label label;
    Model.PoiGroup poigroup;
    public string key;
    public string value;
    string value_type;
    weak Pager pager;
    
    public ValueKeyView(string _key, string _value_type,
            Model.PoiGroup _poigroup, Elm.Object _parent, Pager _pager,
            PageNewEditPoi _origin) {
      poigroup = _poigroup;
      key = _key;
      value_type = _value_type;
      pager = _pager;
      parent = _parent;
      origin = _origin;
      
      generate_view();
    }
    
    public bool has_been_set() {
      return (label.label_get() != CLICK_TO_SET);
    }
    public string[]? value_key() {
      if( has_been_set()==false )
        return null;
      if( value_type=="TYPE" )
        return label.label_get().split("=");
      return {key,label.label_get()};
    }
    
    public weak Elm.Object get_content() {
      return box;
    }
    
    private void generate_view() {
      box = new Box(parent);
      box.horizontal_set(true);
      box.homogenous_set(false);
      box.size_hint_weight_set(1, -1.0);
      box.size_hint_align_set(-1, -1);
      box.show();
      button = new Button(parent);
      button.label_set(key);
      button.show();
      button.smart_callback_add("clicked", view_set_value_page );
      box.pack_end(button);
      
      label = new Label(parent);
      label.show();
      if( value_type=="TYPE" )
        label.label_set(poigroup.get_leaf_types()[0]);
      else
        label.label_set(CLICK_TO_SET);
      box.pack_end(label);
    }
    
    private void view_set_value_page() {
      string current_value = label.label_get();
      if( current_value == CLICK_TO_SET )
        current_value = "";
      Model.PoiAttributes.attr_values.get(value_type).show_content(
            parent,key,get_value,pager,current_value,
            origin.poigroup.get_leaf_types() );
    }
    
    private void get_value() {
      value = Model.PoiAttributes.attr_values.get(value_type).value;
      if( (value==null || value=="") ) {
        if( value_type!="TYPE" ) // Don't blank if it is type
          label.label_set(CLICK_TO_SET);
      }else
        label.label_set(value);
      pager.content_promote(origin.get_content());
    }
    
  }
}
