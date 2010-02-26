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

namespace Poiguides {
  namespace Model.GPS {
    
    public struct Coordinate {
      double lat;
      double lon;
    }
    
    [DBus (name = "org.freesmartphone.Usage")]
    interface Usage : GLib.Object {
      public abstract void RequestResource(string resource) throws DBus.Error;
    }
    [DBus (name = "org.freedesktop.Gypsy.Device")]
    interface Device : GLib.Object {
      //public abstract int GetFixStatus() throws DBus.Error;
      public signal void FixStatusChanged( int new_status );
    }
    [DBus (name = "org.freedesktop.Gypsy.Position")]
    public interface Position : GLib.Object {
      public abstract void GetPosition(out int fields, out int tstamp, out double lat, out double lon, out double alt) throws DBus.Error;
      public signal void position_changed(int fields, int tstamp, double lat, double lon, double alt);
    }
    
    DBus.Connection conn;
    Usage fso;
    Position position;
    bool gps_running;
    void init() {
      gps_running = true;  // Hopefully..
      try {
        conn = DBus.Bus.get (DBus.BusType.SYSTEM);
        
        fso = (Usage) conn.get_object("org.freesmartphone.ousaged",
                              "/org/freesmartphone/Usage",
                              "org.freesmartphone.Usage");
        fso.RequestResource("GPS"); // Turn on gps

        position = (Position) conn.get_object("org.freesmartphone.ogpsd",
                               "/org/freedesktop/Gypsy",
                               "org.freedesktop.Gypsy.Position");
      } catch(DBus.Error e) {
        // No Dbus!?
        debug("No DBus!");
      }
    }
    
    // Retrieve current position from gps device
    Coordinate get_current_position() {
      int a, b;
      double lat, lon, alt;
      try {
        if(position==null)
          throw new DBus.Error.FAILED("");
        position.GetPosition(out a,out b,out lat,out lon,out alt);
        return Coordinate() {
          lat = lat,
          lon = lon
        };
      } catch( DBus.Error e ) {
        return Coordinate() { lat = 1.0, lon = 1.0 };
      }
    }
    
    // Calculate distance between two points in meters
    /*int dist_coord(Coordinate c1, Coordinate c2) {
      return dist(c1.lat,c1.lon,c2.lat,c2.lon);
    }*/
    
    // Calculate distance between two points in meters
    // Algorithm taken from http://www.movable-type.co.uk/scripts/latlong.html
    int dist(double lat1, double lon1, double lat2, double lon2) {
      double R = 6371000; // m
      var dLat = to_rad(lat2-lat1);
      var dLon = to_rad(lon2-lon1);
      var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(to_rad(lat1)) * Math.cos(to_rad(lat2)) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
      var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
      var d = R * c;
      return (int)d;
    }
    
    private double to_rad(double num) {
      return num * Math.PI / 180; 
    }
  }
}