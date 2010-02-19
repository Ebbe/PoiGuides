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

namespace Poiguides.DBusInterfaces {
  class GPS {
    private static MainLoop loop;
    
    public static void* run_thread() {
      loop = new MainLoop(null, false);
      var time = new TimeoutSource(2000);

      time.set_callback(() => {
          //Model.GPS.position.GetPostion(Model.GPS.get_gps_position);
          return true;
      });

      time.attach(loop.get_context());
      
      loop.run();
      time = null;
      return null;
    }

    public static void stop_thread() {
      loop.quit();
    }
    
  }
}