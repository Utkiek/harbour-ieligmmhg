import QtQuick 2.1
import Sailfish.Silica 1.0

Page {
    id: page
    allowedOrientations: Orientation.All

    SilicaFlickable {
        id: aboutFlickable

        anchors.fill: parent
        contentHeight: about1.height + about2.height + about3.height + about4.height + about5.height

        VerticalScrollDecorator {
            flickable: aboutFlickable
        }
        HorizontalScrollDecorator {
            flickable: aboutFlickable
        }


        TextArea {
            id: about1
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            readOnly: true
            wrapMode: TextEdit.Wrap
            text: qsTr("Ielig: mmHg\nSave your bloodpressure values")
        }

        TextArea {
            id: about2
            anchors {
                top: about1.bottom
                left: parent.left
                right: parent.right
            }
            readOnly: true
            wrapMode: TextEdit.Wrap
            text: qsTr("Export\nYou can export in a CSV-File. Path and filename is hardcoded to\n") + StandardPaths.documents + qsTr("/mmHg.csv")
        }

        TextArea {
            id: about3
            anchors {
                top: about2.bottom
                left: parent.left
                right: parent.right
            }
            readOnly: true
            wrapMode: TextEdit.Wrap
            text: qsTr("Privacy\nThe values marked as private will not be exported.")
        }


        TextArea {
            id: about4
            anchors {
                top: about3.bottom
                left: parent.left
                right: parent.right
            }
            readOnly: true
            wrapMode: TextEdit.Wrap
            text: qsTr("Senior\nThis app address the demands of elderly jolla users. If you like to talk about this demands send me a mail: utkiek@public-files.de or lets drink a beer here in Bremen.")
        }

        TextArea {
            id: about5
            anchors {
                top: about4.bottom
                left: parent.left
                right: parent.right
            }
            readOnly: true
            wrapMode: TextEdit.Wrap
            text: qsTr("Open source\nThis app is QML and a litte C++.\nGithub: https://github.com/Utkiek/IeligmmHg\nLicense: GPLv3")
        }
    }
}
