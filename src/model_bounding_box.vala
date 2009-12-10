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

using GLib;

namespace Poiguides {
  namespace Model {
    
    class BoundingBox {
      double top = 0;
      double right = 0;
      double bottom = 0;
      double left = 0;
      
      public BoundingBox() {
        load_settings();
      }
      
      public string[] get_boundingbox() {
        string[] str = new string[4];
        str[0] = "%f".printf(top);
        str[1] = "%f".printf(right);
        str[2] = "%f".printf(bottom);
        str[3] = "%f".printf(left);
        return str;
      }
      
//      public double[] get_boundingbox_double() {
//        double[] ret = new double[4];
//        ret[0] = top;
//        ret[1] = right;
//        ret[2] = bottom;
//        ret[3] = left;
//        return ret;
//      }
      
      public string to_string() {
        return "%f,%f,%f,%f".printf(left,bottom,right,top);
      }
      
      public void set_boundingbox_a(string[] str) {
        set_boundingbox(str[0],str[1],str[2],str[3]);
      }
      public void set_boundingbox(string t, string r, string b, string l) {
        top = t.to_double();
        right = r.to_double();
        bottom = b.to_double();
        left = l.to_double();
        
        save_settings();
      }
      
      private void load_settings() {
        string folder = "%s/.poiguides".printf( Environment.get_home_dir() );
        File f = File.new_for_path(folder);
        try {
          f.make_directory(null);
          return;
        } catch(GLib.Error e) {}
        
        string filename = "%s/boundingbox".printf(folder);
        File file = File.new_for_path(filename);
        try {
          // Open file for reading and wrap returned FileInputStream into a
          // DataInputStream, so we can read line by line
          var in_stream = new DataInputStream (file.read (null));
          // Read lines
          top = in_stream.read_line (null, null).to_double();
          right = in_stream.read_line (null, null).to_double();
          bottom = in_stream.read_line (null, null).to_double();
          left = in_stream.read_line (null, null).to_double();
        } catch (Error e) {}
      }
      
      private void save_settings() {
        var filename = "%s/.poiguides/boundingbox".printf(Environment.get_home_dir());
        var file = File.new_for_path (filename);
        try {
          file.delete(null);
        } catch (Error e) {}
        
        try {
          var file_stream = file.create (FileCreateFlags.REPLACE_DESTINATION, null);
          var data_stream = new DataOutputStream (file_stream);
          
          foreach(string x in get_boundingbox() ) {
            data_stream.put_string(x+"\n", null);
          }
        } catch (Error e) {
          stdout.printf("Couldn't save settings. No more disk space?\n");
        }
      }
    }
    
  }
}