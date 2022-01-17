import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: wertListe
    allowedOrientations: Orientation.All

    property date aktDatum: new Date()
    property var locale: Qt.locale()
    property real breite: width

    backNavigation: false

    SilicaFlickable {
        id: flick
        anchors.fill: parent
        contentWidth: {
            if (pdmenu.active) {
                parent.width
            } else {
                if (werteListe.count === 0) {
                    parent.width
                } else {
                    breite
                }
            }
        }


        PullDownMenu {
            id: pdmenu
            MenuItem {
                text: qsTr("Settings & About")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Einstellungen.qml"), {
                                              werteListe: werteListe
                                          })
                }
            }
            MenuItem {
                text: {
                    if (werteListe.count > 0) {
                        qsTr("Export & Import")
                    } else {
                        qsTr("Import")
                    }
                }
                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("Export.qml"), {
//                                              werteListe: werteListe
//                                          })
                    pageStack.push(Qt.resolvedUrl("Export.qml"))
                }
            }
            MenuItem {
                text: qsTr("Graph")
                onClicked: {
//                    pageStack.push(Qt.resolvedUrl("Kurve.qml"), {
//                                              werteListe: werteListe
//                                          })
                    pageStack.push(Qt.resolvedUrl("Kurve.qml"))

                }
                visible: werteListe.count > 1
            }
            MenuItem {
                text: qsTr("New value")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Eingabe.qml"), {
                                              werteListe: werteListe
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
            model: werteListe
            spacing: 0

            ScrollDecorator {
            }

            header: Rectangle {
                height: pageHeaderWertListe.height * 2
                Label {
                    id: pageHeaderWertListe
                    anchors.verticalCenter: parent.verticalCenter
                    x: flick.visibleArea.xPosition * (auflistung.width)
                    width: flick.width - Theme.horizontalPageMargin
                    text: werteListe.count + " " + qsTr("values")
                    font.pixelSize: Theme.fontSizeLarge
                    font.family: Theme.fontFamily
                    color: Theme.highlightColor
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.bottomMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingLarge
                    horizontalAlignment: TextEdit.AlignRight
                    visible: werteListe.count != 0
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
                text: qsTr("Add your data.\nFor chart or export you need 2 (or more) values.")
                visible: werteListe.count === 0
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Eingabe.qml"))
                }
            }

            delegate: ListItem {
                id: listItem1
                Label {
                    id: label1
                    text: {
                        var s
                        s = datum + "  " + uhrzeit + "  " + sys
                        if (aktFeldbezeichner2 !== "") {
                            s = s + " / " + dia
                        }
                        if (aktFeldbezeichner3 !== "") {
                            s = s + " / " + puls
                        }
                        if (aktFeldbezeichner4 !== "") {
                            s = s + " / " + bemerkung
                        }

                        return s
                    }

                    font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                }

                function aktualisiere() {
                        var neuesDatum
                        var tempstringGueltigbis
                        var neuesDatumGueltigbis

                        neuesDatumGueltigbis = Date.fromLocaleDateString(locale,werteListe.gueltigbis,"yyyyMMdd")
                        tempstringGueltigbis = neuesDatumGueltigbis.toLocaleDateString(locale,"dd.MM.yy")

                        pageStack.push(Qt.resolvedUrl("Eingabe.qml"), {
                                                  aktualisiereModus: true,
                                                  datumButton: datum,
                                                  uhrzeitButton: uhrzeit,
                                                  aktsystolic: sys,
                                                  aktdiastolic: dia,
                                                  aktbemerkung: bemerkung,
                                                  aktPrivat: privat,
                                                  aktpuls: puls,
                                                  gueltigkeitButton: tempstringGueltigbis
                                              })
                }

                function loesche() {
                    var idx = index
                    remorse.execute(listItem1, qsTr("Deleting"), function () {
                        werteListe.loescheWert(datumzeit)
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
