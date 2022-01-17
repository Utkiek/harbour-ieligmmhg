import QtQuick 2.4
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: aboutFlickable

        anchors.fill: parent

        VerticalScrollDecorator {
            flickable: aboutFlickable
        }
        HorizontalScrollDecorator {
            flickable: aboutFlickable
        }

        Column {
            anchors.fill: parent
            anchors.topMargin: Theme.paddingLarge * 3
            anchors.horizontalCenter: parent.horizontalCenter

            TextArea {
                id: ta1
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Welcome to Ielig:mmhg")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }

            TextArea {
                id: updateText1
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeLarge
                color: Theme.errorColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                //textFormat: Text.StyledText
                text: qsTr("[First start after update? Please restart this app]")
            }

            TextArea {
                id: ta11
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Your first action:")
            }

            TextArea {
                id: ta3
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Config your data fields and the chart..")
                onClicked: pageStack.push(Qt.resolvedUrl("Einstellungen.qml"))
            }
            TextArea {
                id: ta4
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Or save your blood pressure values..")
                onClicked: pageStack.push(Qt.resolvedUrl("Eingabe.qml"))
            }
            TextArea {
                id: ta45
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Check your data values..")
                onClicked: pageStack.push(Qt.resolvedUrl("Wertliste.qml"))
                visible: werteListe.count > 0
            }
            TextArea {
                id: ta5
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Little help..")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            TextArea {
                id: ta6
                width: parent.width
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Show this page not again!")
                onClicked: {
                    aktKeinstartbild = true
                    editEinstellung(aktUrl,"keinStartbild",aktKeinstartbild.toString(),aktThema);
                    pageStack.clear()
                    pageStack.push(Qt.resolvedUrl(programmInit()))
                }
            }

        }
    }
}
