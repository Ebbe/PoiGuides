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

namespace Poiguides.Config {
  string config_dir;
  string saved_pois_filename;
  
  string global_config_dir;
  
  /* Find the directories and files to use 
  */
  public void init() {
    config_dir = Environment.get_user_config_dir() + "/poiguides/";
    saved_pois_filename = config_dir + "saved_pois";
    DirUtils.create_with_parents(config_dir,0755);
    
    foreach( string possible_dir in Environment.get_system_data_dirs() ) {
      if( (File.new_for_path(possible_dir + "/poiguides")).query_exists(null) ) {
        global_config_dir = possible_dir + "/poiguides/";
        break;
      }
    }
  }
  
  public string get_new_pois_filename() {
    string new_pois_filename = Environment.get_home_dir() + "/poiguides_poi";
    int i = 1;
    while(FileUtils.test(new_pois_filename+"%i.osm".printf(i),FileTest.EXISTS))
      i++;
    new_pois_filename = new_pois_filename+"%i.osm".printf(i);
    return new_pois_filename;
  }
}