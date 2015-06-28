import QtQuick 2.1
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs
import "helper/db.js" as DB

Page {
    id: nachfrageAllesLoeschenPage
    allowedOrientations: Orientation.All
    onFocusChanged: canvas1.requestPaint()

    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            spacing: 8

            PageHeader {
                id: pageHeaderExport
                title: qsTr("Warning !")
            }
            Label {
                text: qsTr("Delete all values? Sure?")
                color: "red"
            }
            Button {
                text: qsTr("No")
                onClicked: {
                    pageStack.pop()
                }
            }
            Button {
                text: qsTr("Yes! Delete all values!")
                color: "red"
                onClicked: {
                    DB.dropTableWert()
                    pageStack.pop()
                }
            }
        }
    }
}
