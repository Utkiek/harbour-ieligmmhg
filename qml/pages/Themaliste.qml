import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: themaListe
    allowedOrientations: Orientation.All

    property real breite: width

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentWidth: {
            if (pdmenu.active) {
                parent.width
            } else {
                if (themenListe.count === 0) {
                    parent.width
                } else {
                    breite
                }
            }
        }



        PullDownMenu {
            id: pdmenu
            MenuItem {
                text: qsTr("New theme")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Themaeingabe.qml"), {
                                              themenListe: themenListe
                                          })
                }
            }
        }

        SilicaListView {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            id: auflistung
            anchors.leftMargin: Theme.horizontalPageMargin
            model: themenListe
            spacing: 0

            ScrollDecorator {
                //flickable: flick
            }

            header: Rectangle {
                height: pageHeaderThemaListe.height * 2
                Label {
                    id: pageHeaderThemaListe
                    anchors.verticalCenter: parent.verticalCenter
                    x: flick.visibleArea.xPosition * (auflistung.width)
                    width: flick.width - Theme.horizontalPageMargin
                    text: themenListe.count + " " + qsTr("themes")
                    font.pixelSize: Theme.fontSizeLarge
                    font.family: Theme.fontFamily
                    color: Theme.highlightColor
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.bottomMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingLarge
                    horizontalAlignment: TextEdit.AlignRight
                    visible: themenListe.count !== 0
                }
            }

            TextArea {
                anchors.fill: parent
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Add your theme.")
                visible: themenListe.count === 0
                onClicked: pageStack.push(Qt.resolvedUrl("Themaeingabe.qml"))
            }

            delegate: ListItem {
                id: listItem1
                Label {
                    id: label1
                    text: {
                        wert === aktThema ? wert + " *" : wert
                    }
                    font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)                    
                }

                onClicked: {
                    auswahl()
                }

                function aktualisiere() {
                    onClicked: pageStack.push(Qt.resolvedUrl("Themaeingabe.qml"), {
                                                  akteingabethemawert: wert, aktualisiereModus: true
                                              })
                }

                function auswahl() {
                    wechsleThema(wert)
                }

                function loesche() {
                    var idx = index
                    remorse.execute(listItem1, qsTr("Deleting"), function () {
                        themenListe.loescheWert(wert)
                    })
                }

                RemorseItem {
                    id: remorse
                }

                menu: Component {
                    ContextMenu {
                        id: menu
                        width: flick.width
                        MenuItem {
                            text: qsTr("Select")
                            onClicked: {
                                menu.parent.auswahl()
                            }
                        }
                        MenuItem {
                            text: qsTr("Edit")
                            onClicked: {
                                menu.parent.aktualisiere()
                            }
                        }
                        MenuItem {
                            text: qsTr("Delete")
                            onClicked: {
                                menu.parent.loesche()
                            }
                        }
                    }
                }

                Component.onCompleted: {
                    breite: {
                        if (breite < label1.contentWidth) {
                            breite = label1.contentWidth
                        } else {
                            breite = breite
                        }
                    }
                }
            }
        }
    }
}
