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

using Gee;
using Elm;

namespace Poiguides.Model.PoiAttributes {
  private bool is_init;
  public HashMap<string,AttributeValues> attr_values;
  
  public class AttributeValues {
    string[] options = {};
    string[] options_description = {};
    string input;
    bool made_view = false;
    
    Box box_set;
    Box btn_bx;
    Elm.List list_set;
    ListItem[] items;
    Button btn_cancel;
    Button btn_ok;
    Label label_set;
    Label description;
    Frame frame_set;
    Entry entry_set;
    string key;
    Evas.Callback signalback;
    public string value;
    
    public AttributeValues() {}
    
    public string get_input() {
      return input;
    }
    public void set_input(string _input) {
      input = _input;
    }
    
    public void add_option(string option, string desc="") {
      options += option;
      options_description += desc;
    }
    
    public string[] get_options() {
      return options;
    }
    
    public int number_of_options() {
      return options.length;
    }
    
    public void show_content(Elm.Object parent, string _title, Evas.Callback _signalback, Pager pager, string default="", string[]? types=null) {
      key = _title;
      signalback = _signalback;
      value = default;
      if( input=="TYPE" )
        options = types;
      
      if( !made_view ) {
        generate_view(parent);
        pager.content_push(box_set);
      } else {
        entry_set.entry_set(value);
        label_set.label_set(key);
        //if( input=="TYPE" )
        if( list_set!=null )
          fill_list();
        pager.content_promote(box_set);
      }
    }
    private void generate_view(Elm.Object parent) {
      box_set = new Box(parent);
      box_set.homogenous_set(false);
      box_set.show();
      
      label_set = new Label(parent);
      label_set.show();
      label_set.label_set(key);
      box_set.pack_end(label_set);
      
      if( input !="STRING" ) {
        generate_list(parent);
      }
      
      frame_set = new Frame(parent);
      frame_set.size_hint_weight_set(1, -1);
      frame_set.size_hint_align_set(-1, -1);
      frame_set.label_set( "Custom" );
      frame_set.show();
      
      entry_set = new Entry(parent);
      entry_set.entry_set(value);
      entry_set.show();
      frame_set.content_set(entry_set);
      box_set.pack_end(frame_set);
      
      btn_bx = new Box(parent);
      btn_bx.horizontal_set(true);
      btn_bx.show();
      
      btn_cancel = new Button(parent);
      btn_cancel.label_set("Cancel");
      btn_cancel.smart_callback_add("clicked", cancel_callback );
      btn_cancel.show();
      btn_bx.pack_end(btn_cancel);
      btn_ok = new Button(parent);
      btn_ok.label_set("Select");
      btn_ok.smart_callback_add("clicked", ok_callback );
      btn_ok.show();
      btn_bx.pack_end(btn_ok);
      
      box_set.pack_end(btn_bx);
      
      made_view = true;
    }
    private void generate_list(Elm.Object parent) {
      list_set = new Elm.List(parent);
      list_set.horizontal_mode_set(ListMode.SCROLL);
      list_set.multi_select_set(false);
      list_set.size_hint_weight_set(1.0, 1.0);
      list_set.size_hint_align_set(-1, -1);
      list_set.show();
      list_set.smart_callback_add("selected", list_click );
      box_set.pack_end(list_set);
      
      fill_list();
    }
    private void fill_list() {
      items = new ListItem[number_of_options()+1];
      items += list_set.append("*custom*", null, null, null);
      foreach( string attribute_possible_value in get_options() ) {
        if( attribute_possible_value=="" )
          continue;
        items += list_set.append(attribute_possible_value, null, null, null);
      }
      list_set.go();
    }
    private void list_click() {
      string clicked = list_set.selected_item_get().label_get();
      if( clicked=="*custom*" ) {
        entry_set.entry_set("");
        //entry_set.disabled_set(false);
      } else {
        entry_set.entry_set(clicked);
        //entry_set.disabled_set(true);
      }
    }
    private void cancel_callback() {
      value = null;
      signalback(box_set, null);
      //box_set = null;
    }
    private void ok_callback() {
      value = entry_set.entry_get();
      signalback(box_set, null);
      //box_set = null;
    }
    
  }
  
  public void init() {
    if(is_init)
      return;
    
    attr_values = new HashMap<string,AttributeValues>(GLib.str_hash, GLib.str_equal);
    load_attr_file(Config.global_config_dir+"poi_attributes");
    is_init = true;
  }
  
  private void load_attr_file(string filename) {
    var in_stream = FileStream.open(filename, "r");
    string line;
    
    // First create "TYPE"
    AttributeValues current_attribute_values = new AttributeValues();
    attr_values.set("TYPE",current_attribute_values);
    current_attribute_values.set_input("TYPE");
    
    try {
      Regex regex_new_value = new Regex("""^\[(\w+)\]$""");
      Regex regex_possible_types = new Regex("""^(\w+)$""");
      Regex regex_option = new Regex("""^\s*\* (\w+)\s*(- (.*))?$""");
      MatchInfo result;
      
      while( (line=in_stream.read_line())!=null ) {
        
        if( regex_option.match(line,0,out result) ) { // Parse option
          current_attribute_values.add_option(result.fetch(1), result.fetch(3));
        } else if( regex_new_value.match(line,0,out result) ) {
          current_attribute_values = new AttributeValues();
          attr_values.set(result.fetch(1),current_attribute_values);
        } else if( regex_possible_types.match(line,0,out result) ) {
          current_attribute_values.set_input(result.fetch(1));
        }
      }
    } catch (Error e) {
      // Couldn't parse file
      debug("Couldn't parse the file %s",filename);
    }
  }
  
}