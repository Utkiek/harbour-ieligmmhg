import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Page {
    id: exportPage
    allowedOrientations: Orientation.All

    property bool abgeschlossen: false
    property string importText
    property string version: "V002"

    SilicaFlickable {
        anchors.fill: parent

        Column {
            id: col1
            anchors.fill: parent
            spacing: 50

            PageHeader {
                id: pageHeaderExport
                title: qsTr("Export & Import")
            }

            Button {
                id: exportButton
                anchors.topMargin: 300
                text: qsTr("Create 'mmHg.csv'")
                visible: werteListe.count > 0
                property date aktDatum: new Date()
                property string zeitstempel

                onClicked: {
                    var s
                    var sdatum = ""
                    var suhrzeit = ""
                    var ssys = ""
                    var sdia = ""
                    var sbemerkung = ""
                    var sprivat = ""
                    var spuls = ""
                    var sthema = ""
                    var sgueltigbis = ""
                    var werteElement

                    fortbalken.maximumValue = werteListe.count
                    fortbalken.visible = true

                    zeitstempel = aktDatum.toLocaleString(Qt.locale("de_DE"))

                    s = qsTr("Date") + ";" + qsTr("Time") + ";" + qsTr("Sys")
                            + ";" + qsTr("Dia") + ";" + qsTr("Pulse") + ";" + qsTr(
                                "Comment") + ";" + qsTr("Private")
                            + ";" + qsTr("Theme") + ";" + qsTr("Valid to") + ";#\n"
                    s = s + aktTitel + ";" + version + ";" + qsTr("Created:") + ";" + zeitstempel + ";" + ""
                            + ";" + "" + ";" + "" + ";" + "" + ";" + "" + ";#\n"
                    for (var i = 0; i < werteListe.count; i++) {
                        fortbalken.value = i + 1

                        //if ((aktPrivatexport) || (werteElement.privat !== "true")) {
                        werteElement = werteListe.get(i)
                        try {
                            sdatum = (werteElement.datum || '')
                        } catch (e) {
                            sdatum = ""
                        }
                        try {
                            suhrzeit = (werteElement.uhrzeit || '')
                        } catch (e) {
                            suhrzeit = ""
                        }
                        try {
                            ssys = (werteElement.sys || "")
                        } catch (e) {
                            ssys = ""
                        }
                        try {
                            sdia = (werteElement.dia || "")
                        } catch (e) {
                            sdia = ""
                        }
                        try {
                            sbemerkung = (werteElement.bemerkung || "")
                        } catch (e) {
                            sbemerkung = ""
                        }
                        try {
                            sprivat = (werteElement.privat || "")
                        } catch (e) {
                            sprivat = "false"
                        }
                        try {
                            spuls = (werteElement.puls || "")
                        } catch (e) {
                            spuls = ""
                        }
                        try {
                            sthema = (werteElement.thema || "")
                        } catch (e) {
                            sthema = ""
                        }
                        try {
                            sgueltigbis = (werteElement.gueltigbis || "")
                        } catch (e) {
                            sgueltigbis = ""
                        }

                        if ((aktPrivatexport) || (sprivat !== "true")) {
                            s = s + sdatum + ";" + suhrzeit + ";" + ssys + ";" + sdia
                                    + ";" + spuls + ";" + sbemerkung + ";" + sprivat
                                    + ";" + sthema + ";" + sgueltigbis + ";#\n"
                        }
                    }
                    _dateiio.source = StandardPaths.documents + "/mmHg.csv"
                    _dateiio.write(s)
                    abgeschlossen = true
                    //fortbalken.visible = false
                }

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: importButton
                text: qsTr("Read 'mmHg.csv'")
                anchors.topMargin: 300

                onClicked: {
                    var importDatei
                    var importSatz
                    var indDatum = 0
                    var indUhrzeit = 1
                    var indSys = 2
                    var indDia = 3
                    var indPuls = 4
                    var indBemerkung = 5
                    var indPrivat = 6
                    var indThema = 7
                    var indGueltigbis = 8
                    var starti = 1

                    _dateiio.source = StandardPaths.documents + "/mmHg.csv"
                    importText = _dateiio.read()
                    importDatei = importText.split('#')

                    importSatz = importDatei[1].split(';')
                    importSatz[1] === version ? starti = 2 : starti
                                                = 1 //2=diese Version, 1=alte Version

                    fortbalken.maximumValue = importDatei.length - starti
                    fortbalken.visible = true
                    fortbalken.value = 0

                    for (var i = starti; i < importDatei.length; i++) {
                        //console.log(importDatei[i])
                        importSatz = importDatei[i].split(';')
                        //for (var j = 0; j < importSatz.length; j++) {
                            if (importSatz[0].length > 0) {
                                neuesDatum = Date.fromLocaleDateString(
                                            locale, importSatz[0], "dd.MM.yy")
                                tempstring = neuesDatum.toLocaleDateString(
                                            locale, "yyyyMMdd")
                                tempstring = Globs.jahrhundert4zeitstempel(tempstring)

                                if (starti == 1) { //alte Version

                                    indPuls = 5
                                    indBemerkung = 4
                                    schreibeWert(tempstring + importSatz[indUhrzeit],
                                                 importSatz[indDatum],
                                                 importSatz[indUhrzeit],
                                                 importSatz[indSys],
                                                 importSatz[indDia],
                                                 importSatz[indBemerkung],
                                                 importSatz[indPrivat], "0",
                                                 haupt.aktThema, "")

                                    fortbalken.value = fortbalken.value + 1

                                } else {
                                    schreibeWert(tempstring + importSatz[indUhrzeit],
                                                 importSatz[indDatum],
                                                 importSatz[indUhrzeit],
                                                 importSatz[indSys],
                                                 importSatz[indDia],
                                                 importSatz[indBemerkung],
                                                 importSatz[indPrivat],
                                                 importSatz[indPuls],
                                                 importSatz[indThema],
                                                 importSatz[indGueltigbis])

                                    fortbalken.value = fortbalken.value + 1

                                }
                            }
                        //}
                    }
                    werteListe.aktualisiereWerte()
                    abgeschlossen = true
                    fortbalken.maximumValue = fortbalken.value
                    //fortbalken.visible = false
                }

                anchors.horizontalCenter: parent.horizontalCenter
            }

            Label {
                anchors.topMargin: 400
                text: qsTr("Path: ") + StandardPaths.documents
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ProgressBar {
                id: fortbalken
                anchors.topMargin: 200
                //anchors.topMargin: 300
                width: parent.width * 0.8
                visible: true
                valueText: value
                label: qsTr("records")
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
