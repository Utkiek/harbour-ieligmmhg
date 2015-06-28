# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-ieligmmhg

CONFIG += sailfishapp

SOURCES += \
    src/fileio.cpp \
    src/harbour-ieligmmhg.cpp

OTHER_FILES += qml/harbour-ieligmmhg.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-ieligmmhg.changes.in \
    rpm/harbour-ieligmmhg.spec \
    rpm/harbour-ieligmmhg.yaml \
    translations/*.ts \
    harbour-ieligmmhg.desktop \
    qml/pages/Wertliste.qml \
    qml/pages/NachfrageAllesLoeschen.qml \
    qml/pages/Kurve.qml \
    qml/pages/Export.qml \
    qml/pages/Einstellungen.qml \
    qml/pages/Eingabe.qml \
    qml/pages/About.qml \
    qml/pages/helper/db.js \
    qml/pages/helper/globs.js

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-ieligmmhg-de.ts

HEADERS += \
    src/fileio.h

