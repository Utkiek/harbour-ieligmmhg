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
//        contentWidth: {
//            if (pdmenu.active) {
//                parent.width
//            } else {
//                if (themenListe.count === 0) {
//                    parent.width
//                } else {
//                    breite
//                }
//            }
//        }


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
                text: qsTr("Themes")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Themaliste.qml"), {
                                              themenListe: themenListe
                                          })
                }
            }
        }

        Label {
            id: pageHeaderThemaAuswahlAkt
            anchors.top: parent.top
            //anchors.verticalCenter: parent.verticalCenter
            x: flick.visibleArea.xPosition * (auflistung.width)
            width: flick.width - Theme.horizontalPageMargin
            //text: themenListe.count + " " + qsTr("themes")
            text: "Welcome to theme " + aktThema
            font.pixelSize: Theme.fontSizeLarge
            font.family: Theme.fontFamily
            color: Theme.highlightColor
            anchors.rightMargin: Theme.horizontalPageMargin
            anchors.bottomMargin: Theme.paddingLarge
            anchors.topMargin: Theme.paddingLarge
            horizontalAlignment: TextEdit.AlignRight
            visible: themenListe.count != 0
            wrapMode: Text.WordWrap
        }

        Button {
            id: pageHeaderButNeuerWert
            anchors.top: pageHeaderThemaAuswahlAkt.bottom
            anchors.topMargin: Theme.paddingLarge *2
            anchors.bottomMargin: Theme.paddingLarge
            text: "New Value" //" for " + aktThema
            onClicked: {
                pageStack.push(Qt.resolvedUrl("Eingabe.qml"), {
                                          werteListe: werteListe
                                      })
            }
        }

        Button {
            id: pageHeaderBut
            anchors.top: pageHeaderThemaAuswahlAkt.bottom //pageHeaderButNeuerWert.bottom
            anchors.left: pageHeaderButNeuerWert.right
            anchors.leftMargin: Theme.paddingLarge  *2
            anchors.topMargin: Theme.paddingLarge *2
            anchors.bottomMargin: Theme.paddingLarge
            text: "List"//"Values of " + aktThema
            onClicked: {
                //wechsleThema(aktThema)
                pageStack.push(Qt.resolvedUrl("Wertliste.qml"), {
                                                                  //akteingabethemawert: wert
                                                              })
            }
        }

        SilicaListView {
            id: auflistung
            //anchors.fill: parent
            anchors.top: pageHeaderBut.bottom
            anchors.topMargin: Theme.paddingLarge * 2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            //anchors.centerIn: parent
            //anchors.leftMargin: Theme.horizontalPageMargin
            model: themenListe
            spacing: 30

            ScrollDecorator {
                flickable: auflistung
            }

            header: Rectangle {
                height: (pageHeaderThemaListe.height * 2)
                Label {
                    id: pageHeaderThemaListe
                    //anchors.verticalCenter: parent.verticalCenter
                    x: flick.visibleArea.xPosition * (auflistung.width)
                    width: flick.width - Theme.horizontalPageMargin
                    //text: themenListe.count + " " + qsTr("themes")
                    text: "or choose your theme"
                    //font.pixelSize: Theme.fontSizeLarge
                    font.family: Theme.fontFamily
                    color: Theme.highlightColor
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.bottomMargin: Theme.paddingLarge
                    anchors.topMargin: Theme.paddingLarge
                    horizontalAlignment: TextEdit.AlignRight
                    visible: themenListe.count != 0
                }
            }

            delegate: Button {
                id: listButton
                anchors.bottomMargin: 30
                //horizontalCenter: parent.horizontalCenter
                text: wert === aktThema ? wert + " *" : wert
                //font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                //visible: wert != aktThema


                onClicked: {
                    auswahl()
                    pageStack.push(Qt.resolvedUrl("Wertliste.qml"), {
                                                                      //akteingabethemawert: wert
                                                                  })
                }

                function auswahl() {
                    wechsleThema(wert)

//                Component.onCompleted: {
//                    breite: {
//                        if (breite < label1.contentWidth) {
//                            breite = label1.contentWidth
//                        } else {
//                            breite = breite
//                        }
//                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (werteListe.count === 0) {
            pageStack.push(Qt.resolvedUrl("Themaliste.qml"), {
                                      themenListe: themenListe
                                  })
        }
    }
}

