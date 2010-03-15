AM_VALAFLAGS = --vapidir=libeflvala/vapi \
	--pkg "gio-2.0"  --pkg "glib-2.0" --pkg "dbus-glib-1" --pkg "elm" --pkg "gee-1.0" \
	--disable-dbus-transformation \
	--thread

AM_CFLAGS = $(DEPS_CFLAGS)
AM_LIBS = $(DEPS_LIBS) $(DEPS_LIBS)

bin_PROGRAMS = poiguides

poiguides_SOURCES = controller.vala model_pois.vala view_page_about.vala \
    view_page_downloading.vala  view_page_main.vala main.vala \
    model_bounding_box.vala view_main.vala view_page_categories.vala \
    view_page_download.vala config.vala model_gps.vala view_page_poi.vala \
    dbus_interfaces.vala helper_opening_hours.vala view_page_config.vala \
    model_pois_attr.vala view_page_new_edit_poi.vala

poiguides_LDFLAGS = $(AM_LIBS)

clean:
	rm -f *.c *.o *.stamp
