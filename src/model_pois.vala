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
      public string category;
      public string type;
      public string name;
      public string description;
      public int dist;
      
      public PoiNode(int _id, double _lat, double _lon, string _category = "",
                  string _type = "", string _name = "", string _description = "") {
        id = _id;
        lat = _lat;
        lon = _lon;
        category = _category;
        type = _type;
        name = _name;
        description = _description;
      }
      
      public void pretty_print() {
        string show_name = name;
        if( name==null || name=="" )
          show_name = "No name";
        stdout.printf("id:%i type:%s lat:%f lon:%f name:%s dist:%i\n",id,type,lat,lon,show_name,dist);
        if( description!=null )
          stdout.printf("    %s\n",description);
      }
      /*
       * Make a one line string that will save this node in a way that
       * it is easily parsed again. 
       */
      public string saveable_string() {
        return "%i %f %f %s '%s' %s".printf(id,lat,lon,cat_type(),name,description);
      }
      
      public string cat_type() {
        return category+"="+type;
      }
      
      public string human_name() {
        return "%im ".printf(dist) + type + " - " + name;
      }
      public int calculate_dist(double _lat, double _lon) {
        dist = GPS.dist(lat, lon, _lat, _lon);
        return dist;
      }
    }
    
    class PoiGroup {
      public PoiGroup? parent;
      HashMap<string, PoiGroup> children;
      ArrayList<PoiNode?> leafs;
      public bool top_level;
      public bool contain_leafs;
      private string name;
      
      public PoiGroup(PoiGroup? _parent, string _name = "Categories") {
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
          Regex line_regex = new Regex("[*]([*]*)(-?) (.+)$");
          MatchInfo result;
          
          while( (line=in_stream.read_line())!=null ) {
            
            if( line_regex.match(line,0,out result) ) {
              //stdout.printf("  Depth:%li Leaf:%li String:%s\n",result.fetch(1).len(),result.fetch(2).len(),result.fetch(3));
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
        } else {
          children.set(child_text, new PoiGroup(this, child_text));
        }
        return children.get(child_text);
      }
      
      public string human_readable_path() {
        if(top_level)
          return name;
        else
          return "%s - %s".printf(parent.human_readable_path(),name);
      }
      
      // Sort the leaf according to their distance
      // Uses some sort of insertion sort
      private void sort_leafs() {
        if( !contain_leafs )
          return;
        
        PoiNode p;
        GPS.Coordinate c = GPS.current_position();
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
          } else
            stdout.printf("-");
        }
        stdout.printf("\n");
      }
    }
    
    
    
    class Pois {
      int number_downloaded = 0;
      //HashTable<int, PoiNode> hash_of_id;
      HashMap<string, ArrayList<PoiNode?>> hash_of_type;
      public PoiGroup top_level_poi_group;
      
      public Pois() {
        hash_of_type = new HashMap<string, ArrayList<PoiNode?>> (GLib.str_hash, GLib.str_equal);
        top_level_poi_group = new PoiGroup(null);
        top_level_poi_group.load_config("/home/ebbe/Projects/valide/poiguides/data/poi_groups");
        
        load_saved_pois();
      }
      
      public void load_saved_pois() {
        var in_stream = FileStream.open(Config.saved_pois_filename, "r");
        string line;
        
        try {
          Regex line_regex = new Regex("^(.+) (.+[.].+) (.+[.].+) (.+)=(.+) '(.*)' (.*)$");
          MatchInfo result;
          
          while( (line=in_stream.read_line())!=null ) {
            if( line_regex.match(line,0, out result) ) {
              DownloadHelp.save_node(new PoiNode(
                  result.fetch(1).to_int(),
                  result.fetch(2).to_double(),
                  result.fetch(3).to_double(),
                  result.fetch(4),
                  result.fetch(5),
                  result.fetch(6),
                  result.fetch(7)
                ));
            }
          }
        } catch (Error e) {
          debug("Couldn't parse file");
        }
      }
      
      public void download_new(BoundingBox bb) {
        // http://www.informationfreeway.org/api/0.6
        // http://osmxapi.hypercube.telascience.org/api/0.6
        // http://xapi.openstreetmap.org/api/0.6
        string base_uri = "http://osmxapi.hypercube.telascience.org/api/0.6/node[%s=%s][bbox="+bb.to_string()+"]";
        
        number_downloaded = 0;
        foreach(string key in DownloadHelp.get_keys()) {
          parse_uri(base_uri.printf(key,DownloadHelp.get(key)));
        }
        
        DownloadHelp.save_nodes_to_file();
      }
       
      private void parse_uri(string uri) {
        try {
          debug("Downloading file: %s", uri);
          File file = File.new_for_uri(uri);
          // Open file for reading and wrap returned FileInputStream into a
          // DataInputStream, so we can read line by line
          var in_stream = new DataInputStream (file.read (null));
          
          Regex re_key_value = new Regex("<tag k='(.+)' v='(.+)'/>");
          Regex re_start_PoiNode = new Regex("<node id='(.+)' lat='(.+)' lon='(.+)'");
          Regex re_end = new Regex("</node>");
          // Read lines
          PoiNode current_PoiNode = new PoiNode(1,1.1,1.1); //Dummy start
          string line;
          MatchInfo result;
          while( (line=in_stream.read_line (null, null))!=null ) {
            if( re_start_PoiNode.match(line,0, out result) ) { // Node start
              current_PoiNode = new PoiNode(
                result.fetch(1).to_int(),
                result.fetch(2).to_double(),
                result.fetch(3).to_double()
              );
            } else if( re_end.match(line,0, out result) ) { // Node end
              this.add_poi(current_PoiNode);
            } else if(re_key_value.match(line,0, out result)) { // key - value
              if(result.fetch(1)=="name") {
                current_PoiNode.name = result.fetch(2);
              } else if(result.fetch(1)=="description") {
                current_PoiNode.description = result.fetch(2);
              } else if(DownloadHelp.download_strings.contains(result.fetch(1))) {
                current_PoiNode.category = result.fetch(1);
                current_PoiNode.type = result.fetch(2);
              }
            }
          }
        } catch (Error e) {
          // Couldn't download file
        }
        
        // Try to print all the PoiNodes
        //foreach( string s in hash_of_type.get_keys() ) {
        //  stdout.printf("key: %s\n",s);
        //  foreach( var n in hash_of_type.get(s) ) {
        //    n.pretty_print();
        //  }
        //}
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
        if(id_hash==null) id_hash = new HashMap<int, weak PoiNode?>();
        where_to_save.get(node.cat_type()).add(node);
      }
      
      public static void save_nodes_to_file() {
        var stream = FileStream.open(Config.saved_pois_filename, "w");
        
        foreach(string key in where_to_save.keys) {
          foreach(PoiNode poi in where_to_save.get(key)) {
            stream.puts( poi.saveable_string()+"\n" );
          }
        }
      }
    }
  }
}
