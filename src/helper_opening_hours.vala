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

/*
  Look here for inspiration:
  http://wiki.openstreetmap.org/wiki/Opening_hours
  PHP implementation. Not complete.
  http://svn.openstreetmap.org/applications/mobile/healthwhere/inc_openclosed.php
  
  Examples:
  opening_hours = 24/7
  opening_hours = Mo-Su 08:00-18:00; Apr 10-15 off; Jun 08:00-14:00; Aug off; Dec 25 off
  opening_hours = Mo 10:00-12:00,12:30-15:00; Tu-Fr 08:00-12:00,12:30-15:00; Sa 08:00-12:00
  opening_hours = Mo,We,Fr 10:00-12:00
  opening_hours = Mo-Fr 10:00-12:00,13:00-15:00
  opening_hours = Mo-Su 08:00-18:00; Dec 25-Jan 06 off
  opening_hours = 10:00-18:00      // This could happen, right? 
  opening_hours = sunrise-sunset   // Don't want to support this yet
  
    Syntax

    * wd weekday, available: Mo · Tu · We · Th · Fr · Sa · Su (e.g.> Fr 08:30-20:00)
    * hh hour, always two digits number in 24h basis (no am/pm), in the format "hh:mm" · (e.g.> Fr 08:30-20:00)
    * mm minute, always two digits number in the format "hh:mm" (e.g.> Fr 08:30-20:00)
    * mo month, available: Jan · Feb · Mar · Apr · May · Jun · Jul · Aug · Sep · Oct · Nov · Dec · "mo md" (e.g.> Dec 25)
    * md monthday, always two digits number in the format · "mo md" (e.g.> Dec 25) 

  the general syntax for the value is: hh:mm-hh:mm (e.g.> 08:30-20:00)
  the general syntax for the value is: wd hh:mm-hh:mm (e.g.> Fr 08:30-20:00)
  the general syntax for the value is: mo md hh:mm-hh:mm (e.g.> Dec 25 08:30-20:00) 
*/

namespace Poiguides.Helper.OpeningHours {
  public enum Status {
    OPEN,
    OPEN_SOON,
    CLOSED,
    UNKNOWN,
    ERROR
  }
  
  public Status open_now(string _opening_hours) {
    // The easy ones first:
    if( _opening_hours=="" )
      return Status.UNKNOWN;
    if( _opening_hours=="24/7" )
      return Status.OPEN;
    
    string opening_hours = _opening_hours.up();
    
    Status current_status = Status.UNKNOWN;
    string digit_str = "[0-9]";
    string timespan_str = @"$digit_str{1,2}:$digit_str{2}-$digit_str{1,2}:$digit_str{2}";
    Regex timespan_only_reg = new Regex("^(%s)$".printf(timespan_str));
    string weekday_str = "(MO|TU|WE|TH|FR|SA|SU|-)";
    Regex weekday_reg = new Regex("^(%s{0,3}) (?<timespan>%s)".printf(weekday_str,timespan_str));
    MatchInfo result;
    string[] rules = opening_hours.split_set(";");
    foreach( string rule in rules ) {
      rule = rule.strip();
      if( rule=="24/7" ) {
        current_status = Status.OPEN;
        continue;
      }
      if( timespan_only_reg.match(rule,0, out result) ) {
        current_status = check_time(result.fetch(1));
        continue;
      }
      if( weekday_reg.match(rule,0, out result) ) {
        if( inside_weekday_span(result.fetch(1)) )
          current_status = check_time(result.fetch_named("timespan"));
        else if( current_status==Status.UNKNOWN )
          current_status = Status.CLOSED;
        continue;
      }
    }
    
    return current_status;
  }
  
  /* Function to test/debug this helper */
  public void test() {
    string[] test_material = {
                "24/7", 
                "10:15-15:30",
                "20:00-01:00",
                "9:00-24:00",
                "13-24",
                "Mo-We 10:00-18:00",
                "Mo-We 10:00-10:00",
                "Fr-Sa 10:00-18:00"
              };
    var enum_class = (EnumClass) typeof (Status).class_ref ();
    
    stdout.printf("Testing opening_hours\n");
    foreach(string test in test_material) {
      stdout.printf(" * \"%s\" is %s\n", test, enum_class.get_value(open_now(test)).value_name );
    }
    stdout.printf("Testing completed\n");
  }
  
  Time? tt;
  private Time current_time() {
    if( tt==null )
      tt = Time().local(time_t());
    
    return tt;
  }
  
  /* Checks a hh:mm-hh:mm to see if we are within that span */
  private Status check_time(string time) {
    string[] time_split = time.split_set("-");
    int time_open = time_split[0].replace(":","").to_int();
    if( time_open<25 ) time_open = time_open*100;
    int time_close = time_split[1].replace(":","").to_int();
    if( time_close<25 ) time_close = time_close*100;
    int now = current_time().hour*100 + current_time().minute;
    
    if( time_open < now && now < time_close )
      return Status.OPEN;
    else if( time_close < time_open ) { // Eg "18:00-02:00"
      if( now < time_close )
        return Status.OPEN;
      if( time_open < now )
        return Status.OPEN;
    }
    
    return Status.CLOSED;
  }
  
  /* Checks a weekday or weekday span and tells us if we are in it */
  private bool inside_weekday_span(string span) {
    string[] days = span.split_set("-");
    int start = weekday_as_int(days[0]);
    int today = current_time().weekday;
    
    if(days.length == 1) {
      if(today==start)
        return true;
    } else {
      int end = weekday_as_int(days[1]);
      if(start<=today && today<=end)
        return true;
    }
    return false;
  }
  
  private int weekday_as_int(string weekday) {
    switch (weekday) {
      case "MO":
        return 1;
      case "TU":
        return 2;
      case "WE":
        return 3;
      case "TH":
        return 4;
      case "FR":
        return 5;
      case "SA":
        return 6;
      case "SU":
        return 7;
    }
    
    return -1;
  }
  
  private int month_as_int(string month) {
    switch (month.up()) {
      case "JAN":
        return 0;
      case "FEB":
        return 1;
      case "MAR":
        return 2;
      case "APR":
        return 3;
      case "MAY":
        return 4;
      case "JUN":
        return 5;
      case "JUL":
        return 6;
      case "AUG":
        return 7;
      case "SEP":
        return 8;
      case "OCT":
        return 9;
      case "NOW":
        return 10;
      case "DEC":
        return 11;
    }
    
    return -1;
  }
}


