import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: kurve
    allowedOrientations: Orientation.All
    onFocusChanged: canvas1.requestPaint()
    backNavigation: true

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageHeaderKurve
            title: werteListe.count + " " + qsTr("values")
        }

        Rectangle {
            id: rectangle1
            //width: 520
//            width: {
//                if (parent.width < parent.height) {
//                    parent.width * 0.9
//                } else {
//                    parent.height * 0.9
//                }
//            }
//            //height: 520
//            height: {
//                if (parent.width < parent.height) {
//                    //parent.width * 0.9
//                    parent.height * 0.9
//                } else {
//                    parent.height * 0.9
//                }
//            }
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.top: pageHeaderKurve.bottom
            anchors.topMargin: 40
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.verticalCenter: parent.verticalCenter
            border {
                width: 1
                color: "blue"
            }

            Label {
                id: lab200
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMaxwert //"200"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                anchors.top: lab200.bottom
                anchors.left: parent.left
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                anchors.leftMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveEinheit //"mmHg"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id: lab170
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1 + (canvas1.height / 5)
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMinwert + ((aktKurveMaxwert - aktKurveMinwert) / 5) * 4 //"170"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id: lab140
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1 + (canvas1.height / 5) * 2
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMinwert + ((aktKurveMaxwert - aktKurveMinwert) / 5) * 3 //"140"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id: lab110
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1 + (canvas1.height / 5) * 3
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMinwert + ((aktKurveMaxwert - aktKurveMinwert) / 5) * 2 //"110"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id: lab80
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1 + (canvas1.height / 5) * 4
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMinwert + ((aktKurveMaxwert - aktKurveMinwert) / 5) * 1 //"80"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id: lab50
                anchors.top: rectangle1.top
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.topMargin: 1 + (canvas1.height / 5) * 5
                anchors.right: canvas1.left
                anchors.rightMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktKurveMinwert //"50"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Canvas {
                id: canvas1
                anchors.left: parent.left
                anchors.leftMargin: 100 * (rectangle1.width / 580)
                anchors.top: parent.top
                anchors.topMargin: 20
                width: rectangle1.width - 120 * (rectangle1.width / 580)
                height: rectangle1.height - 70* (rectangle1.width / 580)
                property real aktX
                property real aktY
                property var werteElement
                property int anzWerte
                property real divAnzahl
                property real divWert
                property bool farbWechsel: false
                property real abstand: (aktKurveMaxwert - aktKurveMinwert) > 0 ? (aktKurveMaxwert - aktKurveMinwert) : 1

                antialiasing: true

                onPaint: {
                    var ctx = getContext('2d')
                    ctx.lineWidth = 2
                    ctx.clearRect(0, 0, canvas1.width, canvas1.height)

                    ctx.strokeStyle = "darkRed"
                    ctx.strokeRect(0, 0, canvas1.width, canvas1.height)

                    var imax = 5
                    ctx.strokeStyle = "lightgrey"
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    for (var i2 = 1; i2 < imax; i2++) {
                        ctx.moveTo(0,(canvas1.height/imax) * i2)
                        ctx.lineTo(canvas1.width,(canvas1.height/imax) * i2)
                    }
                    ctx.stroke()

                    anzWerte = werteListe.count

                    ctx.strokeStyle = "darkMagenta"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    if ((anzWerte - 1) > 0) {
                        divAnzahl = canvas1.width / (anzWerte - 1)
                    } else {
                        divAnzahl = 1
                    }

                    divWert = canvas1.height / abstand //150
                    werteElement = werteListe.get(anzWerte - 1)
                    if ((werteElement.sys - aktKurveMinwert) < 0) {
                        ctx.moveTo(aktX,canvas1.height)
                    } else {
                        ctx.moveTo(aktX,canvas1.height - (werteElement.sys - aktKurveMinwert) * divWert)
                    }
                    for (var i = anzWerte - 2; i >= 0; i--) {
                        aktX = aktX + 1
                        werteElement = werteListe.get(i)
                        if ((werteElement.sys - aktKurveMinwert) < 0) {
                            ctx.lineTo((aktX * divAnzahl),canvas1.height)
                        } else {
                            ctx.lineTo((aktX * divAnzahl),
                                       (canvas1.height - (werteElement.sys - aktKurveMinwert) * divWert))
                        }
                    }

                    ctx.stroke()

                    werteElement = werteListe.get(anzWerte - 1)
                    aktX = 0
                    ctx.strokeStyle = "darkCyan"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    if ((werteElement.dia - aktKurveMinwert) < 0) {
                        ctx.moveTo(aktX,canvas1.height)
                    } else {
                        ctx.moveTo(aktX,canvas1.height - (werteElement.dia - aktKurveMinwert) * divWert)
                    }
                    for (var i = anzWerte - 2; i >= 0; i--) {
                        aktX = aktX + 1
                        werteElement = werteListe.get(i)
                        if ((werteElement.dia - aktKurveMinwert) < 0) {
                            ctx.lineTo((aktX * divAnzahl),canvas1.height)
                        } else {
                            ctx.lineTo((aktX * divAnzahl),
                                       (canvas1.height - (werteElement.dia - aktKurveMinwert) * divWert))
                        }
                    }

                    ctx.stroke()
                }
            }

            Label {
                anchors.bottom: rectangle1.bottom
                anchors.left: canvas1.left
                anchors.bottomMargin: 10
                text: werteListe.count > 0 ? werteListe.ersteDatum() : ""
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }
            Label {
                anchors.bottom: rectangle1.bottom
                anchors.right: canvas1.right
                anchors.bottomMargin: 10
                text: werteListe.count > 0 ? werteListe.letzteDatum() : ""
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Label {
                id:labelSys
                anchors.bottom: rectangle1.bottom
                anchors.left: canvas1.left
                anchors.right: canvas1.right
                anchors.rightMargin: 5 + canvas1.width /2
                anchors.bottomMargin: 10
                horizontalAlignment: Text.AlignRight
                text: aktFeldbezeichner1.substring(0,3)  //"Sys"
                font.pixelSize: Theme.fontSizeSmall
                color: "darkMagenta"
            }

            Label {
                id:labelDia
                anchors.bottom: rectangle1.bottom
                anchors.left: canvas1.left
                anchors.leftMargin: 5 + canvas1.width /2
                anchors.bottomMargin: 10
                horizontalAlignment: Text.AlignLeft
                text: aktFeldbezeichner2.substring(0,3)  //"Dia"
                font.pixelSize: Theme.fontSizeSmall
                color: "darkCyan"
            }

        }
    }

}
