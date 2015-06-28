import QtQuick 2.1
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: kurve
    allowedOrientations: Orientation.All
    onFocusChanged: canvas1.requestPaint()    

    SilicaFlickable {
        anchors.fill: parent

        PageHeader {
            id: pageHeaderKurve
            title: werteListe.count + " " + qsTr("values")
        }

        Rectangle {
            id: rectangle1
            width: 520
            height: 520
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
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
                text: "200"
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
                text: "mmHg"
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
                text: "170"
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
                text: "140"
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
                text: "110"
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
                text: "80"
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
                text: "50"
                font.pixelSize: Theme.fontSizeSmall
                color: "black"
            }

            Canvas {
                id: canvas1
                anchors.left: parent.left
                anchors.leftMargin: 100
                anchors.top: parent.top
                anchors.topMargin: 20
                width: rectangle1.width - 120
                height: rectangle1.height - 70
                property real aktX
                property real aktY
                property var werteElement
                property int anzWerte
                property real divAnzahl
                property real divWert
                property bool farbWechsel: false

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

                    divWert = canvas1.height / 150
                    werteElement = werteListe.get(anzWerte - 1)
                    ctx.moveTo(aktX,canvas1.height - (werteElement.sys - 50) * divWert)
                    for (var i = anzWerte - 2; i >= 0; i--) {
                        aktX = aktX + 1
                        werteElement = werteListe.get(i)
                        ctx.lineTo((aktX * divAnzahl),
                                   (canvas1.height - (werteElement.sys - 50) * divWert))
                    }

                    ctx.stroke()

                    werteElement = werteListe.get(anzWerte - 1)
                    aktX = 0
                    ctx.strokeStyle = "darkCyan"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.moveTo(aktX,canvas1.height - (werteElement.dia - 50) * divWert)
                    for (var i = anzWerte - 2; i >= 0; i--) {
                        aktX = aktX + 1
                        werteElement = werteListe.get(i)
                        ctx.lineTo((aktX * divAnzahl),
                                   (canvas1.height - (werteElement.dia - 50) * divWert))
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
                text: "Sys"
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
                text: "Dia"
                font.pixelSize: Theme.fontSizeSmall
                color: "darkCyan"
            }

        }
    }

}
