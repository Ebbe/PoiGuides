DESCRIPTION = "Poi Guides"
HOMEPAGE = "http://github.com/Ebbe/PoiGuides"
LICENSE = "GPLv3"
AUTHOR = "Esben Damgaard <ebbe@hvemder.dk>"
MAINTAINER = "Esben Damgaard <ebbe@hvemder.dk>"
DEPENDS = "vala-native glib-2.0 dbus dbus-glib libgee"

SRCREV = "${AUTOREV}"
PV = "0.0.1+gitr${SRCREV}"

SRC_URI = "file://poiguides-${PV}.tar.gz"

SRC_URI = "git://github.com/Ebbe/poiguides.git;protocol=git;branch=master"
S = "${WORKDIR}/git/"

do_compile() {
  cd ${S}
  ./compile
}

do_install() {
  install -d ${D}/usr/share/sounds/
  install -d ${D}/usr/share/pixmaps/
  install -d ${D}/usr/share/applications/
  install -d ${D}/usr/bin
  
  install -m 0755 ${S}/bin/timeoko ${D}/usr/bin
  install -m 0755 ${S}/data/timeoko.desktop ${D}/usr/share/applications/
  install -m 0755 ${S}/data/timeoko.png ${D}/usr/share/pixmaps/
  install -m 0755 ${S}/data/timeoko_ring.wav ${D}/usr/share/sounds/
}


do_compile() {
	valac --vapidir=libeflvala/vapi \
    --pkg "glib-2.0" --pkg "dbus-glib-1" --Xcc=-lelementary --pkg "elm" \
    src/*.vala -o "/home/ebbe/neosshfs/home/root/poiguides"
}

