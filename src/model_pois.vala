/*
    poiguides - Download pois, and show distance to them.
    Copyright (C) 2009-2010 Esben Damgaard

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


namespace Poiguides {
  namespace Model {
    
    public class PoiNode {
      public double lat;
      public double lon;
      public int id;
      public string name = "";
      public string type = "";
      public HashMap<string, string> attributes;
      /*public string category;
      public string description;
      public string opening_hours;*/
      public int dist;
      string open_closed_str = "";
      
      public PoiNode(int _id = 0, double _lat = 0, double _lon = 0) {
        id = _id;
        lat = _lat;
        lon = _lon;
        
        attributes = new HashMap<string,string>(GLib.str_hash, GLib.str_equal);
        
        /*Helper.OpeningHours.Status open_now = Helper.OpeningHours.open_now(_opening_hours);
        open_closed_str = "";
        if( open_now==Helper.OpeningHours.Status.OPEN )
          open_closed_str = " (O)";
        if( open_now==Helper.OpeningHours.Status.CLOSED )
          open_closed_str = " (C)";
        if( open_now==Helper.OpeningHours.Status.ERROR )
          open_closed_str = " (!)";*/
      }
      
      public void add_attribute(string key, string val) {
        attributes.set(key,val);
        
        if( key=="name" )
          name = val;
      }
      
      /*public void pretty_print() {
        string show_name = attributes.get("name");
        if( name==null || name=="" )
          show_name = "No name";
        stdout.printf("id:%i %s=%s lat:%f lon:%f name:%s dist:%i\n",id,category,type,lat,lon,show_name,dist);
        if( description!=null )
          stdout.printf("    %s\n",description);
      }*/
      
      /*
       * Make a one line string that will save this node in a way that
       * it is easily parsed again. 
       */
      public string saveable_string() {
        string returnable_string = "%i %f %f".printf(id,lat,lon);
        foreach(string key in attributes.keys)
          returnable_string += " \""+key+"\"=\""+ attributes.get(key) +"\"";
        return returnable_string;
      }
      
      public string navit_format() {
        return "geo:%f %f".printf(lon, lat);
      }
      
      public string human_name() {
        return "%im ".printf(dist) + type + " - " + name.
                              replace("&amp;","&").
                              replace("&apos;","'") +
                              open_closed_str;
      }
      public int calculate_dist(double _lat, double _lon) {
        dist = GPS.dist(lat, lon, _lat, _lon);
        return dist;
      }
      
      public string as_osm() {
        string returnable_string = "<node id='%i' lat='%f' lon='%f' visible='true'>".printf(id,lat,lon);
        foreach(string key in attributes.keys)
          returnable_string += "<tag k='"+key+"' v='"+ attributes.get(key) +"' />";
        returnable_string += "</node>";
        return returnable_string;
      }
    }
    
    public class PoiGroup {
      public PoiGroup? parent;
      HashMap<string, PoiGroup> children;
      ArrayList<PoiNode?> leafs;
      string[] leaf_types = {};
      public bool top_level;
      public bool contain_leafs;
      private string name;
      private string possible_attr = "";
      
      public PoiGroup(PoiGroup? _parent, string _name = " ") {
        parent = _parent;
        name = _name;
        children = new HashMap<string,PoiGroup>(GLib.str_hash, GLib.str_equal);
        if(parent==null)
          top_level = true;
        else
          top_level = false;
      }
      
      public void load_config(string filename) {
        var in_stream = FileStream.open(filename, "r");
        string line;
        PoiGroup current_group = this;
        PoiGroup last_added_child = null;
        int current_depth = 0;
        
        try {
          Regex line_regex = new Regex("""^[*]([*]*)(-?) ([^\[]+)( \[(.*)\])?$""");
          Regex line_regex_attr_top_level = new Regex("""^\[(.*)\]$""");
          MatchInfo result;
          
          while( (line=in_stream.read_line())!=null ) {
            
            if( line_regex.match(line,0,out result) ) {
              //stdout.printf("  Depth:%li Leaf:%li String:%s Attr:%s\n",result.fetch(1).len(),result.fetch(2).len(),result.fetch(3),result.fetch(5));
              if(result.fetch(1).len() > current_depth) {
                current_group = last_added_child;
                current_depth++;
              } else if(result.fetch(1).len() < current_depth) {
                for(int i=current_depth; i>result.fetch(1).len(); i--)
                  current_group = current_group.parent;
                current_depth = (int)result.fetch(1).len();
              }
              bool is_leaf = (result.fetch(2).len()==1);
              if(is_leaf)
                last_added_child.add_child(result.fetch(3),is_leaf);
              else
                last_added_child = current_group.add_child(result.fetch(3),is_leaf);
              
              if(result.fetch(5)!=null)
                last_added_child.add_possible_attr(result.fetch(5));
              //stdout.printf("attr: %s\n",current_group.get_possible_attr());
            } else if( line_regex_attr_top_level.match(line,0,out result) ) {
              // We match the top level attributes
              if(top_level)
                add_possible_attr(result.fetch(1));
              else
                debug("Error syntax in file: %s",filename);
            }
          }
        } catch (Error e) {
          // Couldn't parse file
          debug("Couldn't parse the file %s",filename);
        }
      }
      
      public int number_of_children() {
        if( contain_leafs )
          return leafs.size;
        else
          return children.size;
      }
      public Set<string> get_children() {
        return children.keys;
      }
      public ArrayList<PoiNode?> get_pois(bool sort=true) {
        if( sort )
          sort_leafs();
        return leafs;
      }
      
      public PoiGroup get_child(string child_name) {
        return children.get(child_name);
      }
      
      public PoiGroup add_child(string child_text,bool _leaf) {
        this.contain_leafs = _leaf;
        if(_leaf) {
          if(leafs==null) leafs = new ArrayList<PoiNode?>();
          DownloadHelp.add(child_text, leafs);
          leaf_types += child_text;
        } else {
          children.set(child_text, new PoiGroup(this, child_text));
        }
        return children.get(child_text);
      }
      
      public string human_readable_path() {
        if(top_level || parent.top_level)
          return name;
        else
          return "%s - %s".printf(parent.human_readable_path(),name);
      }
      
      public string get_possible_attr() {
        if(top_level)
          return possible_attr;
        else
          return parent.get_possible_attr()+"|"+possible_attr;
      }
      
      public string[] get_leaf_types() {
        return leaf_types;
      }
      
      // Sort the leaf according to their distance
      // Uses some sort of insertion sort
      private void sort_leafs() {
        if( !contain_leafs )
          return;
        
        PoiNode p;
        GPS.Coordinate c = GPS.get_current_position();
        var leaf_size = leafs.size;
        int x;
        for( int i=0; i<leaf_size; i++ ) {
          p = leafs.get(i);
          p.calculate_dist(c.lat, c.lon);
          if( i==0 )
            continue;
          x = i;
          while( p.dist < leafs.get(--x).dist && x>0 ) {}
          // This didn't really check number 0. Do this manually
          if( x==0 && p.dist < leafs.get(0).dist )
            x = -1;
          
          if(i!=x+1) {
            leafs.remove_at(i);
            leafs.insert(x+1, (owned) p);
          }
        }
      }
      
      private void add_possible_attr(string attr) {
        possible_attr = attr;
      }
    }
    
    
    
    class Pois {
      int number_downloaded = 0;
      HashMap<string, ArrayList<PoiNode?>> hash_of_type;
      public PoiGroup top_level_poi_group;
      
      public Pois() {
        hash_of_type = new HashMap<string, ArrayList<PoiNode?>> (GLib.str_hash, GLib.str_equal);
        top_level_poi_group = new PoiGroup(null);
        top_level_poi_group.load_config(Config.global_config_dir+"poi_groups");
        
        load_saved_pois();
      }
      
      public void load_saved_pois() {
        var in_stream = FileStream.open(Config.saved_pois_filename, "r");
        string line;
        string[] attrs;
        string[] key_value_array;
        PoiNode tmp_poinode;
        
        try {
          Regex line_regex = new Regex("""^([\-]?\d+) (\d+[.]\d+) (\d+[.]\d+) \"(.+)\"$""");
          MatchInfo result;
          
          while( (line=in_stream.read_line())!=null ) {
            if( line_regex.match(line,0, out result) ) {
              tmp_poinode = new PoiNode(
                result.fetch(1).to_int(),
                result.fetch(2).to_double(),
                result.fetch(3).to_double()
              );
              
              // Parse attributes
              // Split at " " in "name"="My cafe" "opening_hours"="24/7"
              attrs = result.fetch(4).split("\" \"");
              foreach(string key_value in attrs) {
                key_value_array = key_value.split("\"=\"");
                tmp_poinode.add_attribute(key_value_array[0],key_value_array[1]);
              }
              DownloadHelp.save_node((owned) tmp_poinode);
            } else // We didn't match anything!
              debug("Syntax error when parsing saved pois.\nLine: %s",line);
          }
        } catch (Error e) {
          debug("Couldn't parse file");
        }
      }
      
      public void download_new(BoundingBox bb) {
        // http://www.informationfreeway.org/api/0.6
        // http://osmxapi.hypercube.telascience.org/api/0.6
        // http://xapi.openstreetmap.org/api/0.6
        string base_uri = "http://xapi.openstreetmap.org/api/0.6/node[%s=%s][bbox="+bb.to_string()+"]";
        
        number_downloaded = 0;
        foreach(string key in DownloadHelp.get_keys()) {
          split_and_download(base_uri,key,DownloadHelp.get(key));
        }
        
        DownloadHelp.save_nodes_to_file();
      }
      // Function to keep trac not to download to many values at a time
      private void split_and_download(string base_uri,string key,string values) {
        string[] values_array = values.split("|",20);
        if( values_array.length==20 ) {
          values = values_array[19];
          string first_elements = values_array[0];
          for(int i=1;i<19;i++)
            first_elements += "|"+values_array[i];
          split_and_download(base_uri,key,first_elements);
        }
        parse_uri(base_uri.printf(key,values));
      }
       
      private void parse_uri(string uri) {
        string template = "/tmp/poiguides-XXXXXX";
        string dir = DirUtils.mkdtemp(template);
        string file = dir + "/downloaded";
        try {
          debug("Downloading file: %s", uri);
          /*File file = File.new_for_uri(uri);
          var file_stream = file.read (null);
          var in_stream = new DataInputStream (file_stream);*/
          
          Process.spawn_sync(null, {"/usr/bin/wget", uri, "--output-document="+file}, null,
            GLib.SpawnFlags.STDERR_TO_DEV_NULL, null);
          var in_stream = FileStream.open(file, "r");
          
          
          Regex re_key_value = new Regex("<tag k='(.+)' v='(.+)'/>");
          Regex re_start_PoiNode = new Regex("<node id='(.+)' lat='(.+)' lon='(.+)'");
          Regex re_end = new Regex("</node>");
          
          // Read lines
          PoiNode current_PoiNode = new PoiNode();
          string line;
          MatchInfo result;
          //while( (line=in_stream.read_line (null, null))!=null ) {
          while( (line=in_stream.read_line ())!=null ) {
            if( re_start_PoiNode.match(line,0, out result) ) { // Node start
              current_PoiNode = new PoiNode(
                result.fetch(1).to_int(),
                result.fetch(2).to_double(),
                result.fetch(3).to_double()
              );
            } else if( re_end.match(line,0, out result) ) { // Node end
              this.add_poi(current_PoiNode);
            } else if(re_key_value.match(line,0, out result)) { // key - value
              /*if(result.fetch(1)=="name") {
                current_PoiNode.name = result.fetch(2);
              } else if(result.fetch(1)=="description") {
                current_PoiNode.description = result.fetch(2);
              } else if(result.fetch(1)=="opening_hours") {
                current_PoiNode.opening_hours = result.fetch(2);
              } else if(DownloadHelp.download_strings.contains(result.fetch(1))) {
                current_PoiNode.category = result.fetch(1);
                current_PoiNode.type = result.fetch(2);
              }*/
              if( result.fetch(1)!="created_by" ) {
                current_PoiNode.add_attribute(result.fetch(1),result.fetch(2));
              }
            }
          }
        } catch (Error e) {
          // Couldn't download file
          debug("Couldn't download or parse the file.\nMessage: %s", e.message);
        } finally {
          // Remove tmp file
          FileUtils.remove(file);
          DirUtils.remove(dir);
        }
      }
      
      public int get_number_of_downloaded() {
        return number_downloaded;
      }
      
      private void add_poi(PoiNode new_poi) {
        DownloadHelp.save_node(new_poi);
        
        number_downloaded ++;
      }
    }
    
    static class DownloadHelp {
      public static HashMap<string, string> download_strings;
      static HashMap<string, ArrayList<PoiNode?>> where_to_save;
      static HashMap<int, weak PoiNode?> id_hash;
      public static int number_of_own_nodes;
      
      // Expects "amenity=fast_food" and the likes
      public static void add(string line, ArrayList<PoiNode?> _where_to_save) {
        if(download_strings==null)
          download_strings = new HashMap<string, string>(GLib.str_hash, GLib.str_equal);
        string[] key_value = line.split("=");
        string set_string = key_value[1];
        if(download_strings.contains(key_value[0]))
          set_string = download_strings.get(key_value[0])+"|"+set_string;
        download_strings.set(key_value[0], set_string );
        
        if(where_to_save==null)
          where_to_save = new HashMap<string, ArrayList<PoiNode?>>(GLib.str_hash, GLib.str_equal);
        where_to_save.set(line, _where_to_save);
      }
      
      public static Set<string> get_keys() {
        return download_strings.keys;
      }
      public static string get(string key) {
        return download_strings.get(key);
      }
      public static void save_node(PoiNode node) {
        bool added_node = false;
        if(id_hash==null) id_hash = new HashMap<int, weak PoiNode?>();
        //if( number_of_own_nodes==null ) number_of_own_nodes = 0;
        if(node.id<0) {
          number_of_own_nodes++;
          node.id = 0-number_of_own_nodes;
        }
        foreach( string key in node.attributes.keys ) {
          string key_value = key +"="+ node.attributes.get(key);
          if( where_to_save.has_key(key_value) ) {
            node.type = node.attributes.get(key);
            where_to_save.get(key_value).add(node);
            id_hash.set(node.id, node);
            added_node = true;
          }
        }
        if (added_node = false) {
          debug("Couldn't find a place for node with id %i",node.id);
          id_hash.set(node.id, node); // Save it anyway (but don't display it)
        }
      }
      
      public static PoiNode get_from_id(int id) {
        return id_hash.get(id);
      }
      
      public static void save_nodes_to_file() {
        var stream = FileStream.open(Config.saved_pois_filename, "w");
        
        int i=0;
        foreach(PoiNode poi in id_hash.values) {
          stream.puts( poi.saveable_string()+"\n" );
          i++;
        }
        stdout.printf("Saved %i pois.\n",i);
      }
      
      public static void export_new_pois() {
        var stream = FileStream.open(Config.get_new_pois_filename(), "w");
        stream.puts("<?xml version='1.0' encoding='UTF-8'?>\n<osm version='0.6' generator='Poiguides'>\n");
        int[] removed_ids = {};
        foreach(PoiNode poi in id_hash.values)
          if( poi.id<0 ) {
            stream.puts( "  "+poi.as_osm()+"\n" );
            removed_ids += poi.id;
          }
        stream.puts("</osm>\n");
        foreach(int id in removed_ids) {
          id_hash.unset(id);
        }
        number_of_own_nodes = 0;
      }
    }
  }
}
