import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs
import "helper/db.js" as DB

Page {
    id: nachfrageAllesLoeschenPage
    allowedOrientations: Orientation.All
    onFocusChanged: canvas1.requestPaint()

    property string modus: ""

    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            anchors.leftMargin: Theme.horizontalPageMargin
            spacing: Theme.paddingLarge
            visible: modus !== ""

            PageHeader {
                id: pageHeaderExport
                title: qsTr("Warning !")
            }
            Label {
                text: {
                    "--undef"
                    if (modus === "loeschenWerte") qsTr("Delete all values? Sure?")
                    if (modus === "standardeinstellungen") qsTr("Reset all settings? Sure?")
                }
            }
            Button {
                text: qsTr("No")
                onClicked: {
                    pageStack.pop()
                }
            }
            Button {
                text: qsTr("Yes! Delete all values!")
                visible: modus === "loeschenWerte"
                onClicked: {
                    DB.dropTableWert()
                    werteListe.clear()
                    pageStack.pop()
                }
            }
            Button {
                text: qsTr("Yes! Reset all settings!")
                visible: modus === "standardeinstellungen"
                onClicked: {
                    DB.dropTableEinstellung()
                    haupt.resetEinstellungen()
                    pageStack.pop()
                }
            }
        }
    }
}
