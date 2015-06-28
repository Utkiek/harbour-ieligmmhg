import QtQuick 2.1
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: exportPage
    allowedOrientations: Orientation.All

    property bool abgeschlossen: false


    SilicaFlickable {
        anchors.fill: parent

        Column {
            anchors.fill: parent
            spacing: 12

            PageHeader {
                id: pageHeaderExport
                title: qsTr("Export")
            }

            //FileIO {
            //    id: aktDatei
            //    source: "mmHg.csv"
            //    //onError: console.log(msg)
            //}



            Button {
                id: exportButton
                text: qsTr("Create 'mmHg.csv'")
                onClicked: {
                    var s
                    var werteElement
                    s = qsTr("date;")+qsTr("time;")+qsTr("sys;")+qsTr("dia;")+qsTr("comment")+"\n"
                    for (var i = 0; i < werteListe.count; i++) {
                        werteElement = werteListe.get(i)
                        if (werteElement.privat != "true") {
                            s = s + werteElement.datum+";"+werteElement.uhrzeit+";"+werteElement.sys+";"+werteElement.dia+";"+werteElement.bemerkung+"\n"
                        }
                    }
                    console.log("Schreibe" + s)
                    //aktDatei.write(s)
                    _dateiio.source = StandardPaths.documents+"/mmHg.csv"
                    _dateiio.write(s)
                    abgeschlossen = true
                }

                anchors.horizontalCenter: parent.horizontalCenter
            }

            //Button {
            //    id: importButton
            //    text: qsTr("Read 'mmHg.csv'")
            //    onClicked: {
            //        console.log("Lese")
            //        //aktText.text = aktDatei.read()
            //        _dateiio.source = StandardPaths.documents+"/mmHg.csv"
            //        aktText.text = _dateiio.read()
            //        abgeschlossen = true
            //    }

            //    anchors.horizontalCenter: parent.horizontalCenter
            //}

            Label {
                anchors.topMargin: 200
                text: qsTr("Path: ") + StandardPaths.documents
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Label {
                anchors.topMargin: 200
                text: qsTr("... finished ...")
                visible: abgeschlossen
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

}
