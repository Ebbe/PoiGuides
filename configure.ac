AC_INIT([poiguides],0.0.1)
AM_INIT_AUTOMAKE
AC_CONFIG_SRCDIR([src/main.vala])


AC_PROG_CC
m4_pattern_allow
AM_PROG_VALAC([0.7.4])

# --pkg "gio-2.0"  --pkg "glib-2.0" --pkg "dbus-glib-1" --Xcc=-lelementary --pkg "elm" --pkg "gee-1.0"
PKG_CHECK_MODULES([DEPS], [glib-2.0 gio-2.0 dbus-glib-1 elementary gee-1.0])
#PKG_CHECK_MODULES([GOBJECT], [gobject-2.0])

AC_CHECK_LIB(gthread-2.0, g_thread_init)

AC_OUTPUT([Makefile
	 src/Makefile
	 data/Makefile])
