import QtQuick 2.1
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: wertListe
    allowedOrientations: Orientation.All

    property date aktDatum: new Date()
    property var locale: Qt.locale()

    property bool aktPrivat: false

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings & About")
                onClicked: pageStack.push(Qt.resolvedUrl("Einstellungen.qml"), {
                                              werteListe: werteListe
                                          })
            }
            MenuItem {
                text: qsTr("Export")
                onClicked: pageStack.push(Qt.resolvedUrl("Export.qml"), {
                                              werteListe: werteListe
                                          })
                visible: werteListe.count > 0
            }
            MenuItem {
                text: qsTr("Chart")
                onClicked: pageStack.push(Qt.resolvedUrl("Kurve.qml"), {
                                              werteListe: werteListe
                                          })
                visible: werteListe.count > 1
            }
            MenuItem {
                text: qsTr("New value")
                onClicked: pageStack.push(Qt.resolvedUrl("Eingabe.qml"), {
                                              werteListe: werteListe
                                          })
            }
        }

        PageHeader {
            id: pageHeaderWertListe
            title: werteListe.count + " " + qsTr("values")
        }

        SilicaListView {
            anchors.top: pageHeaderWertListe.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            id: auflistung
            anchors.leftMargin: 10
            VerticalScrollDecorator {
                flickable: auflistung
            }
            model: werteListe
            spacing: 0
            //update:

            TextArea {
                anchors.fill: parent
                horizontalAlignment: TextEdit.AlignHCenter
                font.pixelSize: Theme.fontSizeHuge
                color: Theme.highlightColor
                font.family: Theme.fontFamily
                readOnly: true
                wrapMode: TextEdit.Wrap
                text: qsTr("Add your data.\nFor chart or export you need 2 (or more) values.")
                visible: werteListe.count == 0
                onClicked: pageStack.push(Qt.resolvedUrl("Eingabe.qml"))
            }

            delegate: ListItem {
                id: myListItem
                property bool menuOpen: contextMenu != null
                                        && contextMenu.parent === myListItem
                property Item contextMenu

                height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height

                function aktualisiere() {
                    onClicked: pageStack.push(Qt.resolvedUrl("Eingabe.qml"), {
                                                  aktualisiereModus: true,
                                                  datumButton: datum,
                                                  uhrzeitButton: uhrzeit,
                                                  systolic: sys,
                                                  diastolic: dia,
                                                  bemerkung: bemerkung,
                                                  aktPrivat: privat
                                              })
                }

                function loesche() {
                    var idx = index
                    remorse.execute(myListItem, qsTr("Deleting"),
                                                     function () {
                                                        werteListe.loescheWert(datumzeit)
                                    })
                }


                BackgroundItem {
                    id: contentItem1
                    Column {
                        Label {
                            text: {
                                if (privat === "true") {
                                    datum + "  " + uhrzeit + "     " + sys
                                            + " / " + dia + " *   " + bemerkung
                                } else {
                                    datum + "  " + uhrzeit + "     " + sys
                                            + " / " + dia + "     " + bemerkung
                                }
                            }
                        }
                    }
                    onPressAndHold: {
                        if (!contextMenu)
                            contextMenu = contextMenuComponent.createObject(
                                        auflistung)
                        contextMenu.show(myListItem)
                    }
                }
            }

            RemorseItem {
                id: remorse
            }


            Component {
                id: contextMenuComponent
                ContextMenu {
                    id: menu
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
        }
    }
}
