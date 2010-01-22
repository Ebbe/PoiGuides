/**
* Copyright (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
*
* This library is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or ( at your option ) any later version.

* This library is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.

* You should have received a copy of the GNU Lesser General Public
* License along with this library; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
*
*/
[CCode (cprefix = "Elm_", lower_case_cprefix = "elm_", cheader_filename = "Elementary.h")]
namespace Elm
{
public void init( [CCode(array_length_pos = 0.9)] string[] args );
public void shutdown();
public void run();
public void exit();

//=======================================================================
namespace Scale
{
    public double get();
    public void set( double scale );
}

//=======================================================================
namespace Finger
{
    public Evas.Coord size_get();
    public void size_set( Evas.Coord size );
}

//=======================================================================
namespace Policy
{
    [CCode (cname = "ELM_POLICY_QUIT")]
    public const uint QUIT;

    [CCode (cprefix = "ELM_POLICY_QUIT_")]
    public enum Quit
    {
        NONE,
        LAST_WINDOW_CLOSED,
    }

    public bool set( uint policy, int value );
    public int get( uint policy );
}


//=======================================================================
namespace Theme
{
    public void overlay_add( string item );
    public void extension_add( string item );
}


//=======================================================================
namespace Coords
{
    public void finger_size_adjust( int times_w, out Evas.Coord w, int times_h, out Evas.Coord h );
}


//=======================================================================
namespace Quicklaunch
{
    public static delegate void Postfork_Func ( void* data );
    public void init( [CCode(array_length_pos = 0.9)] string[] args );
    public void sub_init( [CCode (array_length_pos = 0.9)] string[] args );
    public void sub_shutdown();
    public void shutdown();
    public void seed();
    public bool prepare( [CCode (array_length_pos = 0.9)] string[] args );
    public bool fork( [CCode (array_length_pos = 0.9)] string[] args, string cwd, Postfork_Func postfork_func, void *postfork_data );
    public void cleanup();
    public int fallback( [CCode (array_length_pos = 0.9)] string[] args );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public abstract class Object : Evas.Object
{
    public void scale_set( double scale );
    public double scale_get();
    public void style_set( string style );
    public string style_get();
    public void disabled_set( bool disabled );
    public bool disabled_get();

    public void focus();
    public void focus_allow_set( bool enable );
    public bool focus_allow_get();

    public void scroll_hold_push();
    public void scroll_hold_pop();
    public void scroll_freeze_push();
    public void scroll_freeze_pop();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Win : Elm.Object
{
    [CCode (cname = "elm_win_add")]
    public Win( Elm.Object? parent, string name, WinType t );

    public void resize_object_add( Elm.Object subobj );
    public void resize_object_del( Elm.Object subobj );
    public void title_set( string title );
    public void autodel_set( bool autodel );
    public void activate();
    public void borderless_set( bool borderless );
    public bool borderless_get();
    public void shaped_set( bool shaped );
    public bool shaped_get();
    public void alpha_set( bool alpha );
    public bool alpha_get();
    public void override_set( bool override_ );
    public bool override_get();
    public void fullscreen_set( bool fullscreen );
    public bool fullscreen_get();
    public void maximized_set( bool maximized );
    public bool maximized_get();
    public void iconified_set( bool iconified );
    public bool iconified_get();
    public void layer_set( int layer );
    public int layer_get();
    public void rotation_set( int rotation );
    public int rotation_get();

    public void keyboard_mode_set( WinKeyboardMode mode );
    public void keyboard_win_set( bool is_keyboard );

    public Elm.Win inwin_add();
    public void inwin_style_set( string style );
    public void inwin_activate();
    public void inwin_content_set( Elm.Object content );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Bg : Elm.Object
{
    [CCode (cname = "elm_bg_add")]
    public Bg( Elm.Object? parent );

    public void file_set( string file, string? group=null );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Icon : Elm.Object
{
    [CCode (cname = "elm_icon_add")]
    public Icon( Elm.Object? parent );

    public void file_set( string file, string? group=null );
    public void standard_set( string name );
    public void smooth_set( bool smooth );
    public void no_scale_set( bool no_scale );
    public void scale_set( bool scale_up, bool scale_down );
    public void fill_outside_set( bool fill_outside );
    public void prescale_set( int size );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Box : Elm.Object
{
    [CCode (cname = "elm_box_add")]
    public Box( Elm.Object? parent );

    public void horizontal_set( bool horizontal );
    public void homogenous_set( bool homogenous );
    public void pack_start( Elm.Object subobj );
    public void pack_end( Elm.Object subobj );
    public void pack_before( Elm.Object subobj, Elm.Object before );
    public void pack_after( Elm.Object subobj, Elm.Object after );
    public void unpack( Elm.Object subobj );
    public void unpack_all();
    public void clear();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Button : Elm.Object
{
    [CCode (cname = "elm_button_add")]
    public Button( Elm.Object? parent );

    public void label_set( string label );
    public Elm.Object icon_get();
    public void icon_set( Elm.Object icon );
    public void style_set( string style );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Label : Elm.Object
{
    [CCode (cname = "elm_label_add")]
    public Label( Elm.Object? parent );

    public void label_set( string label );
    public void line_wrap_set( bool wrap );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Index : Elm.Object
{
    [CCode (cname = "elm_index_add")]
    public Index( Elm.Object? parent );
    public void active_set( bool active );
    public void item_level_set( int level );
    public int item_level_get();
    public void* item_selected_get( int level );
    public void item_append( string letter, void* item );
    public void item_prepend( string letter, void* item );
    public void item_append_relative( string letter, void *item, void *relative );
    public void item_prepend_relative( string letter,void *item, void *relative );
    public void item_del( void *item );
    public void item_clear();
    public void item_go( int level );

}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Scroller : Elm.Object
{
    [CCode (cname = "elm_scroller_add")]
    public Scroller( Elm.Object? parent );

    public void content_set( Elm.Object child );
    public void content_min_limit( bool w, bool h );
    public void region_show( Evas.Coord x, Evas.Coord y, Evas.Coord w, Evas.Coord h );
    public void region_get( out Evas.Coord x, out Evas.Coord y, out Evas.Coord w, out Evas.Coord h );
    public void policy_set(ScrollerPolicy h_policy, ScrollerPolicy v_policy);
    public void child_size_get( out Evas.Coord w, out Evas.Coord h );
    public void bounce_set( bool h_bounce, bool v_bounce );
    public void page_relative_set( double h_pagerel, double v_pagerel );
    public void page_size_set( Evas.Coord h_pagesize, Evas.Coord v_pagesize );
    public void region_bring_in( Evas.Coord x, Evas.Coord y, Evas.Coord w, Evas.Coord h );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Toggle : Elm.Object
{
    [CCode (cname = "elm_toggle_add")]
    public Toggle( Elm.Object? parent );

    public void label_set( string label );
    public Elm.Object icon_get();
    public void icon_set( Elm.Object icon );
    public void states_labels_set( string onlabel, string offlabel );
    public void state_set( bool state );
    public bool state_get();
    public void state_pointer_set( bool* statep );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Frame : Elm.Object
{
    [CCode (cname = "elm_frame_add")]
    public Frame( Elm.Object? parent );

    public void label_set( string label );
    public string label_get();
    public void content_set( Elm.Object content );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Table : Elm.Object
{
    [CCode (cname = "elm_table_add")]
    public Table( Elm.Object? parent );

    public void homogenous_set( bool homogenous );
    public void pack( Elm.Object subobj, int x, int y, int w, int h );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Clock : Elm.Object
{
    [CCode (cname = "elm_clock_add")]
    public Clock( Elm.Object? parent );

    public void time_set( int hrs, int min, int sec );
    public void time_get( out int hrs, out int min, out int sec );
    public void edit_set( bool edit );
    public void show_am_pm_set( bool am_pm );
    public void show_seconds_set( bool seconds );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Layout : Elm.Object
{
    [CCode (cname = "elm_layout_add")]
    public Layout( Elm.Object? parent );

    public void file_set( string file, string group );
    public void content_set( string swallow, Elm.Object content );
    public weak Elm.Object edje_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Hover : Elm.Object
{
    [CCode (cname = "elm_hover_add")]
    public Hover( Elm.Object? parent );

    public void target_set( Elm.Object target );
    public void parent_set( Elm.Object parent );
    public void content_set( string swallow, Elm.Object content );
    public void style_set( string style );
    public string best_content_location_get( HoverAxis pref_axis );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Entry : Elm.Object
{
    [CCode (cname = "elm_entry_add")]
    public Entry( Elm.Object? parent );

    public void single_line_set( bool single_line );
    public void password_set( bool password );
    public void entry_set( string entry );
    public unowned string entry_get();
    public string selection_get();
    public void entry_insert( string entry );
    public void line_wrap_set( bool wrap );
    public void editable_set( bool editable );
    public void select_none();
    public void select_all();
    public static string markup_to_utf8( string s );
    public static string utf8_to_markup( string s );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Notepad : Elm.Object
{
    [CCode (cname = "elm_notepad_add")]
    public Notepad( Elm.Object? parent );

    public void file_set( string file, TextFormat format );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Anchorview : Elm.Object
{
    [CCode (cname = "elm_anchorview_add")]
    public Anchorview( Elm.Object? parent );

    public void text_set( string text );
    public void hover_parent_set( Elm.Object parent );
    public void hover_style_set( string style );
    public void hover_end();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Anchorblock : Elm.Object
{
    [CCode (cname = "elm_anchorblock_add")]
    public Anchorblock( Elm.Object? parent );

    public void text_set( string text );
    public void hover_parent_set( Elm.Object parent );
    public void hover_style_set( string style );
    public void hover_end();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Bubble : Elm.Object
{
    [CCode (cname = "elm_bubble_add")]
    public Bubble( Elm.Object? parent );

    public void label_set( string label );
    public Elm.Object icon_get();
    public void info_set( string info );
    public void content_set( Elm.Object content );
    public void icon_set( Elm.Object icon );
    public void corner_set( string corner );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Photo : Elm.Object
{
    [CCode (cname = "elm_photo_add")]
    public Photo( Elm.Object? parent );

    public void file_set( string file );
    public void size_set( int size );
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class ProgressBar : Elm.Object
{
    [CCode (cname = "elm_progressbar_add")]
    public ProgressBar( Elm.Object? parent );

    public void label_set( string label );
    public void icon_set( Elm.Object icon );
    public void span_size_set( Evas.Coord size );
    public void horizontal_set( bool horizontal );
    public void inverted_set( bool inverted );
    public void pulse_set( bool pulse );
    public void pulse( bool state);
    public void unit_format_set( string format );
    public void value_set( double val );
    public double value_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Hoversel : Elm.Object
{
    [CCode (cname = "elm_hoversel_add")]
    public Hoversel( Elm.Object? parent );

    public void hover_parent_set( Elm.Object parent );
    public void label_set( string label );
    public Elm.Object icon_get();
    public void icon_set( Elm.Object icon );
    public void hover_end();
    public unowned HoverselItem item_add( string label, string? icon_file, IconType icon_type, Evas.SmartCallback? func );
    public Eina.List items_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Toolbar : Elm.Object
{
    [CCode (cname = "elm_toolbar_add")]
    public Toolbar( Elm.Object? parent );

    public void scrollable_set( bool scrollable );
    public void homogenous_set( bool homogenous );

    public ToolbarItem item_add( Elm.Object icon, string label, Evas.SmartCallback func );
    public void unselect_all();
    public int icon_size_get();
    public void icon_size_set( int icon_size );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class List : Elm.Object
{
    [CCode (cname = "elm_list_add")]
    public List( Elm.Object? parent );
    [CCode (cname = "elm_list_item_append")]
    public ListItem append( string label, Elm.Object? icon, Elm.Object? end, Evas.SmartCallback? func);
    [CCode (cname = "elm_list_item_prepend")]
    public ListItem prepend( string label, Elm.Object? icon, Elm.Object? end, Evas.SmartCallback? func );
    public ListItem insert_before( ListItem before, string label, Elm.Object? icon, Elm.Object? end, Evas.SmartCallback? func );
    public ListItem insert_after( ListItem after, string label, Elm.Object? icon, Elm.Object? end, Evas.SmartCallback? func );

    public void go();
    public void multi_select_set( bool multi );
    public void horizontal_mode_set( ListMode mode );
    public void always_select_mode_set( bool always_select );

    public weak ListItem selected_item_get();
    public weak Eina.List<ListItem> selected_items_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Carousel : Elm.Object
{
    [CCode (cname = "elm_carousel_add")]
    public Carousel( Elm.Object? parent );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Separator : Elm.Object
{
    [CCode (cname = "elm_separator_add")]
    public Separator( Elm.Object? parent );
    public void horizontal_set( bool horizontal );
    public bool horizontal_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Slider : Elm.Object
{
    [CCode (cname = "elm_slider_add")]
    public Slider( Elm.Object? parent );

    public void label_set( string label );
    public Elm.Object icon_get();
    public void icon_set( Elm.Object icon );
    public void span_size_set( Evas.Coord size );
    public void unit_format_set( string format );
    public void indicator_format_set( string indicator );
    public void horizontal_set( bool horizontal );
    public void min_max_set( double min, double max );
    public void value_set( double val );
    public double value_get();
    public void inverted_set( bool inverted );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Spinner : Elm.Object
{
    [CCode (cname = "elm_spinner_add")]
    public Spinner( Elm.Object? parent );
    public void label_format_set( string format );
    public string label_format_get();
    public void min_max_set( double min, double max );
    public void step_set( double step );
    public void value_set( double val );
    public double value_get();
    public void wrap_set( bool wrap );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Genlist : Elm.Object
{
    [CCode (cname = "elm_genlist_add")]
    public Genlist( Elm.Object? parent );
    public GenlistItem item_append( GenlistItemClass itc, void *data, GenlistItem? parent, GenlistItemFlags flags, Evas.SmartCallback callback );
    public GenlistItem item_prepend( GenlistItemClass itc, void *data, GenlistItem? parent, GenlistItemFlags flags, Evas.SmartCallback callback );
    public GenlistItem item_insert_before( GenlistItemClass itc, void *data, GenlistItem before, GenlistItemFlags flags, Evas.SmartCallback callback );
    public GenlistItem item_insert_after( GenlistItemClass itc, void *data, GenlistItem after, GenlistItemFlags flags, Evas.SmartCallback callback );

    public void clear();
    public void multi_select_set( bool multi );
    public void horizontal_mode_set( ListMode mode );
    public void always_select_mode_set( bool always_select );
    public void no_select_mode_set( bool no_select );

    public GenlistItem at_xy_item_get( Evas.Coord x, Evas.Coord y, out int posret );
    public GenlistItem selected_item_get();
    public Eina.List<GenlistItem> selected_items_get();
    public GenlistItem first_item_get();
    public GenlistItem last_item_get();
}


//=======================================================================
[Compact]
[CCode (cname = "Elm_Genlist_Item", free_function = "") /* Caution! Genlist items are owned by the list. */ ]
public class GenlistItem
{
   public GenlistItem next_get();
   public GenlistItem prev_get();
   public Genlist genlist_get();
   public void subitems_clear();

   public void selected_set( bool selected );
   public bool selected_get();
   public void expanded_set( bool expanded );
   public bool expanded_get();
   public void disabled_set( bool disabled );
   public bool disabled_get();

   public void show();
   public void bring_in();
   public void top_show();
   public void top_bring_in();
   public void middle_show();
   public void middle_bring_in();
   public void del();

   // FIXME: Caution: Do we really have access to the data field or is it used by Vala?
   public void* data_get();
   public void data_set( void* data );
   public void update();

   public Elm.Genlist object_get();
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Check : Elm.Object
{
    [CCode (cname = "elm_check_add")]
    public Check( Elm.Object? parent );

    public void label_set( string label );
    public void icon_set( Elm.Object icon );
    public void state_set( bool state );
    public bool state_get();
    public void state_pointer_set( bool* statep );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Radio : Elm.Object
{
    [CCode (cname = "elm_radio_add")]
    public Radio( Elm.Object? parent );

    public void label_set( string label );
    public void icon_set( Elm.Object icon );
    public void group_add( Elm.Object group );
    public void state_value_set( int value );
    public void value_set( int value );
    public int value_get();
    public void value_pointer_set( out int valuep );
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Menu : Elm.Object
{
    [CCode (cname = "elm_menu_add")]
    public Menu( Elm.Object? parent );

    public void move( Evas.Coord x, Evas.Coord y );
    public void parent_set( Elm.Object parent );
    //public MenuItem item_add( Elm.Object icon, string label, callback );
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Notify : Elm.Object
{
    [CCode (cname = "elm_notify_add")]
    public Notify( Elm.Object? parent );

    public void content_set( Evas.Object content );
    public void orient_set( NotifyOrient orient );
    public void timeout_set( int timeout );
    public void timer_init();
}

//=======================================================================
[CCode (cprefix = "ELM_NOTIFY_ORIENT_")]
public enum NotifyOrient
{
    TOP,
    BOTTOM,
    LEFT,
    RIGHT,
    TOP_LEFT,
    TOP_RIGHT,
    BOTTOM_LEFT,
    BOTTOM_RIGHT
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Pager : Elm.Object
{
    [CCode (cname = "elm_pager_add")]
    public Pager( Elm.Object? parent );

    public void content_push( Elm.Object content );
    public void content_pop();
    public void content_promote( Elm.Object content );
    public Elm.Object content_bottom_get();
    public Elm.Object content_top_get();

    public void style_set( string style );
}


//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Photocam : Elm.Object
{
    [CCode (cname = "elm_photocam_add")]
    public Photocam( Elm.Object? parent );

    public int file_set( string file );
    public void image_size_get( out int w, out int h );
    public void image_region_show( int x, int y, int w, int h );
    public void image_region_bring_in( int x, int y, int w, int h );

    public void zoom_set( double zoom );
    public double zoom_get();
    public void zoom_mode_set( PhotocamZoomMode mode );
    public PhotocamZoomMode zoom_mode_get();

    public void paused_set( bool paused );
    public bool paused_get();
}

//=======================================================================
[CCode (cprefix = "ELM_PHOTOCAM_ZOOM_MODE_")]
public enum PhotocamZoomMode
{
    MANUAL,
    AUTO_FIT,
    AUTO_FILL,
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Slideshow : Elm.Object
{
    [CCode (cname = "elm_slideshow_add")]
    public Slideshow( Elm.Object? parent );

    public SlideshowItem item_add( SlideshowItemClass itc, void* data );
    public SlideshowItem item_current_get();
    public Eina.List<SlideshowItem> items_get();
    public void item_del( SlideshowItem item );


    public void goto( int pos );
    public void show();
    public void next();
    public void previous();

    public Eina.List transitions_get();
    public void transition_set( string transitions );

    public void timeout_set( int timeout );
    public int timeout_get();
    public void loop_set( int loop );
    public void clear();
}

//=======================================================================
[CCode (cname = "Evas_Object", free_function = "evas_object_del")]
public class Image : Elm.Object
{
    [CCode (cname = "elm_image_add")]
    public Image( Elm.Object? parent );

    public void file_set( string file, string? group=null );
    public void smooth_set( bool smooth );
    public void no_scale_set( bool no_scale );
    public void object_size_get( out int w, out int h );
    public void scale_set( bool scale_up, bool scale_down );
    public void fill_outside_set( bool fill_outside );
    public void prescale_set( int size );
    public void orient_set( ImageOrient orient );
}


//=======================================================================
[CCode (cprefix = "ELM_IMAGE_")]
public enum ImageOrient
{
    ORIENT_NONE,
    ROTATE_90_CW,
    ROTATE_180_CW,
    ROTATE_90_CCW,
    FLIP_HORIZONTAL,
    FLIP_VERTICAL,
    FLIP_TRANSPOSE,
    FLIP_TRANSVERSE
}


//=======================================================================
[CCode (cprefix = "ELM_WIN_")]
public enum WinType
{
    BASIC,
    DIALOG_BASIC,
}


//=======================================================================
[CCode (cprefix = "ELM_WIN_KEYBOARD_")]
public enum WinKeyboardMode
{
    UNKNOWN,
    OFF,
    ON,
    ALPHA,
    NUMERIC,
    PIN,
    PHONE_NUMBER,
    HEX,
    TERMINAL,
    PASSWORD,
}


//=======================================================================
[CCode (cprefix = "ELM_HOVER_AXIS_")]
public enum HoverAxis
{
    NONE,
    HORIZONTAL,
    VERTICAL,
    BOTH,
}


//=======================================================================
[CCode (cprefix = "ELM_SCROLLER_AXIS_")]
public enum ScrollerAxis
{
    HORIZONTAL,
    VERTICAL,
}

public enum ScrollerPolicy
{
    AUTO,
    ON,
    OFF
}

//=======================================================================
[CCode (cprefix = "ELM_TEXT_FORMAT_")]
public enum TextFormat
{
    PLAIN_UTF8,
    MARKUP_UTF8,
}


//=======================================================================
[CCode (cprefix = "ELM_ICON_")]
public enum IconType
{
    NONE,
    FILE,
    STANDARD,
}


//=======================================================================
[CCode (cprefix = "ELM_LIST_")]
public enum ListMode
{
    COMPRESS,
    SCROLL,
    LIMIT,
}


//=======================================================================
[CCode (cprefix = "ELM_GENLIST_ITEM_")]
public enum GenlistItemFlags
{
    NONE,
    SUBITEMS,
}


//=======================================================================
[CCode (cname = "Elm_Entry_Anchor_Info")]
public struct EntryAnchorInfo
{
    string name;
    int button;
    Evas.Coord x;
    Evas.Coord y;
    Evas.Coord w;
    Evas.Coord h;
}


//=======================================================================
[CCode (cname = "Elm_Entry_Anchorview_Info")]
public struct EntryAnchorviewInfo
{
    string name;
    int button;
    Elm.Object hover;
    Evas.Coord x;
    Evas.Coord y;
    Evas.Coord w;
    Evas.Coord h;
}

//=======================================================================
[CCode (cname = "Elm_Entry_Anchorblock_Info")]
public struct EntryAnchorblockInfo
{
    string name;
    int button;
    Elm.Object hover;
    Evas.Coord x;
    Evas.Coord y;
    Evas.Coord w;
    Evas.Coord h;
}

public delegate string GenlistItemLabelGetFunc( Elm.Object obj, string part );
public delegate Elm.Object? GenlistItemIconGetFunc( Elm.Object obj, string part );
public delegate bool GenlistItemStateGetFunc( Elm.Object obj, string part );
public delegate void GenlistItemDelFunc( Elm.Object obj );

//=======================================================================
[CCode (cname = "Elm_Genlist_Item_Class_Func", copy_function = "", destroy_function = "")]
public struct GenlistItemClassFunc
{
    [CCode (delegate_target = false)]
    public GenlistItemLabelGetFunc label_get;
    [CCode (delegate_target = false)]
    public GenlistItemIconGetFunc icon_get;
    [CCode (delegate_target = false)]
    public GenlistItemStateGetFunc state_get;
    [CCode (delegate_target = false)]
    public GenlistItemDelFunc del;
}

//=======================================================================
[CCode (cname = "Elm_Genlist_Item_Class", destroy_function = "")]
public struct GenlistItemClass
{
    public string item_style;
    public GenlistItemClassFunc func;
}

//=======================================================================
[Compact]
[CCode (cname = "Elm_Hoversel_Item", free_function = "")]
public class HoverselItem
{
}

//=======================================================================
[Compact]
[CCode (cname = "Elm_List_Item", free_function = "elm_list_item_del")]
public class ListItem
{
    public void selected_set( bool selected );
    public void show();
    public void* data_get();
    public unowned string label_get();
    public void label_set( string label );
    public Elm.Object icon_get();
    public void icon_set( Elm.Object icon );
    public Elm.Object end_get();
    public void end_set( Elm.Object end );
}

//=======================================================================
[Compact]
[CCode (cname = "Elm_Slideshow_Item", free_function = "elm_slideshow_item_del")]
public class SlideshowItem
{
    public Slideshow object_get();
}

public delegate Evas.Object? SlideshowItemGetFunc( Elm.Object obj );
public delegate void SlideshowItemDelFunc( Elm.Object obj );

//=======================================================================
[CCode (cname = "Elm_Slideshow_Item_Class_Func", copy_function = "", destroy_function = "")]
public struct SlideshowItemClassFunc
{
    [CCode (delegate_target = false)]
    public SlideshowItemGetFunc get;
    [CCode (delegate_target = false)]
    public SlideshowItemDelFunc del;
}

//=======================================================================
[CCode (cname = "Elm_Slideshow_Item_Class", destroy_function = "")]
public struct SlideshowItemClass
{
    public SlideshowItemClassFunc func;
}

//=======================================================================
[Compact]
[CCode (cname = "Elm_Toolbar_Item", free_function = "elm_toolbar_item_del")]
public class ToolbarItem
{
    public Elm.Object icon_get();
    public string label_get();
    public void label_set( string label );
    public void select();
    public bool disabled_get();
    public void disabled_set( bool disabled );
    public bool separator_get();
    public void separator_set( bool separator );
}



}


