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

using Gee;


namespace Poiguides {
  namespace Model {
    
    const string[] list_of_allowed_categories = {"amenity"};
    const string[] list_of_allowed_type = {
      "restaurant|fast_food" //Amenities
    };
    
    private struct Node {
      public double lat;
      public double lon;
      public int id;
      public string category;
      public string type;
      public string name;
      public string description;
      
      public void pretty_print() {
        string show_name = name;
        if( name==null || name=="" )
          show_name = "No name";
        stdout.printf("id:%i type:%s lat:%f lon:%f name:%s\n",id,type,lat,lon,show_name);
        if( description!=null )
          stdout.printf("    %s\n",description);
      }
    }
    
    class Pois {
      int number_downloaded = 0;
      //HashTable<int, Node> hash_of_id;
      HashMap<string, ArrayList<Node?>> hash_of_type;
      
      public Pois() {
        hash_of_type = new HashMap<string, ArrayList<Node?>> (GLib.str_hash, GLib.str_equal);
      }
      
      public void download_new(BoundingBox bb) {
        string uri = "http://xapi.openstreetmap.org/api/0.6/node[amenity=restaurant|fast_food][bbox=%s]".printf(bb.to_string());
        stdout.printf("Downloading file:\n%s\n", uri);
        number_downloaded = 0;
        try {
          File file = File.new_for_uri(uri);
          // Open file for reading and wrap returned FileInputStream into a
          // DataInputStream, so we can read line by line
          var in_stream = new DataInputStream (file.read (null));
          
          Regex re_key_value = new Regex("<tag k='(.+)' v='(.+)'/>");
          Regex re_start_node = new Regex("<node id='(.+)' lat='(.+)' lon='(.+)'");
          Regex re_end = new Regex("</node>");
          // Read lines
          Node current_node = Node();
          string line;
          MatchInfo result;
          while( (line=in_stream.read_line (null, null))!=null ) {
            if( re_start_node.match(line,0, out result) ) { // Node start
              current_node = Node() {
                name = "",
                id = result.fetch(1).to_int(),
                lat = result.fetch(2).to_double(),
                lon = result.fetch(3).to_double()
              };
            } else if( re_end.match(line,0, out result) ) { // Node end
              if(!hash_of_type.contains(current_node.type)) {
                hash_of_type.set(current_node.type, new ArrayList<Node?>());
              }
              
              hash_of_type.get(current_node.type).add(current_node);
              
              number_downloaded ++;
            } else if(re_key_value.match(line,0, out result)) { // key - value
              if(result.fetch(1)=="name") {
                current_node.name = result.fetch(2);
              } else if(result.fetch(1)=="amenity") {
                current_node.category = result.fetch(1);
                current_node.type = result.fetch(2);
              } else if(result.fetch(1)=="description") {
                current_node.description = result.fetch(2);
              }
            }
          }
        } catch (Error e) {
          // Couldn't download file
        }
        
        // Try to print all the nodes
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
    }
    
  }
}
