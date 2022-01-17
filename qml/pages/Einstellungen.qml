import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Dialog {
    id: einstellungsSeite
    allowedOrientations: Orientation.All

    property bool feldbezeichner1gesetzt: false
    property bool feldbezeichner2gesetzt: false
    property bool feldbezeichner3gesetzt: false
    property bool feldbezeichner4gesetzt: false
    property bool kurveMinwertgesetzt: false
    property bool kurveMaxwertgesetzt: false
    property bool kurveEinheitgesetzt: false
    property bool gueltigkeitstagegesetzt: false

    acceptDestination: Qt.resolvedUrl("Wertliste.qml")
    acceptDestinationAction: PageStackAction.Replace

    onAccepted: speicherEinstellungen()

    function speicherEinstellungen() {
        aktFontstufe = fontStufe.currentIndex;
        editEinstellung(aktUrl,"Fontstufe",aktFontstufe,globalThema,aktThema);
        aktPrivatexport = privat.checked;
        editEinstellung(aktUrl,"Privatexport",privat.checked.toString(),aktThema);
        if (feldbezeichner1gesetzt) {
            aktFeldbezeichner1 = fieldtext1.text
            editEinstellung(aktUrl,"Feldbezeichner1",fieldtext1.text,aktThema);
        }
        if (feldbezeichner2gesetzt) {
            aktFeldbezeichner2 = fieldtext2.text
            editEinstellung(aktUrl,"Feldbezeichner2",fieldtext2.text,aktThema);
        }
        if (feldbezeichner3gesetzt) {
            aktFeldbezeichner3 = fieldtext3.text
            editEinstellung(aktUrl,"Feldbezeichner3",fieldtext3.text,aktThema);
        }
        if (feldbezeichner4gesetzt) {
            aktFeldbezeichner4 = fieldtext4.text
            editEinstellung(aktUrl,"Feldbezeichner4",fieldtext4.text,aktThema);
        }
        if (kurveMinwertgesetzt) {
            aktKurveMinwert = +kurveMinwert.text
            editEinstellung(aktUrl,"KurveMinwert",kurveMinwert.text,aktThema);
        }
        if (kurveMaxwertgesetzt) {
            aktKurveMaxwert = +kurveMaxwert.text
            editEinstellung(aktUrl,"KurveMaxwert",kurveMaxwert.text,aktThema);
        }
        if (kurveEinheitgesetzt) {
            aktKurveEinheit = kurveEinheit.text
            editEinstellung(aktUrl,"KurveEinheit",kurveEinheit.text,aktThema)
        }
        if (gueltigkeitstagegesetzt) {
            aktGueltigkeitstage = gueltigkeitstage.text
            editEinstellung(aktUrl,"GueltigkeitBis",gueltigkeitstage.text,aktThema)
        }
    }

    SilicaFlickable {
        width:parent.width
        height: parent.height
        contentHeight: col.height + kopf.height

        ScrollDecorator { }

        DialogHeader {
            id: kopf
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        PullDownMenu {
            MenuItem {
                text: qsTr("About Ielig:mmHg")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
        }

        Column {
            id: col
            anchors.top: kopf.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.leftMargin: Theme.horizontalPageMargin//100
            anchors.rightMargin: Theme.horizontalPageMargin
            spacing: 20
            Component.onCompleted: {
                if ((Screen.orientation == Qt.LandscapeOrientation) || (Screen.orientation == Qt.InvertedLandscapeOrientation)) {
                    col.anchors.horizontalCenter = parent.horizontalCenter
                    col.width = Screen.width > (540 * Theme.pixelRatio) ? 540 * Theme.pixelRatio : Screen.width
                } else {
                    col.width = parent.width
                }

            }

//            Label {
//                text: qsTr("Global settings")
//                anchors.right: parent.right
//                anchors.rightMargin: Theme.horizontalPageMargin
//                horizontalAlignment: Text.AlignRight
//                color: Theme.secondaryHighlightColor
//                font.pixelSize: Theme.fontSizeExtraSmall
//            }
            SectionHeader  {
                text: qsTr("Global settings")
            }

            ComboBox {
                id: fontStufe
                width: parent.width - Theme.paddingMedium // - 20
                label: qsTr("Font size")
                currentIndex: aktFontstufe                

                menu: ContextMenu {
                    MenuItem { text: qsTr("small") }
                    MenuItem { text: qsTr("normal") }
                    MenuItem { text: qsTr("big") }
                }
            }

            TextField {
                id: fieldtext1
                label: qsTr("Field 1 label")
                width: parent.width
                text: aktFeldbezeichner1 !== orgFeldbezeichner1 ? aktFeldbezeichner1 : ""
                onTextChanged: {
                    feldbezeichner1gesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Field 1 label") + " (" + orgFeldbezeichner1 + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: fieldtext2.focus = true
            }

            TextField {
                id: fieldtext2
                label: qsTr("Field 2 label")
                width: parent.width
                text: aktFeldbezeichner2 !== orgFeldbezeichner2 ? aktFeldbezeichner2 : ""
                onTextChanged: {
                    feldbezeichner2gesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Field 2 label") + " (" + orgFeldbezeichner2 + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: fieldtext3.focus = true
            }

            TextField {
                id: fieldtext3
                label: qsTr("Field 3 label")
                width: parent.width
                text: aktFeldbezeichner3 !== orgFeldbezeichner3 ? aktFeldbezeichner3 : ""
                onTextChanged: {
                    feldbezeichner3gesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Field 3 label") + " (" + orgFeldbezeichner3 + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: fieldtext4.focus = true
            }

            TextField {
                id: fieldtext4
                label: qsTr("Field 4 label")
                width: parent.width
                text: aktFeldbezeichner4 !== orgFeldbezeichner4 ? aktFeldbezeichner4 : ""
                onTextChanged: {
                    feldbezeichner4gesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Field 4 label") + " (" + orgFeldbezeichner4 + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: kurveMinwert.focus = true
            }

//            Label {
//                text: qsTr("Graph of value 1+2")
//                anchors.right: parent.right
//                anchors.rightMargin: Theme.horizontalPageMargin
//                horizontalAlignment: Text.AlignRight
//                color: Theme.secondaryHighlightColor
//                font.pixelSize: Theme.fontSizeExtraSmall
//            }

            SectionHeader {
                text: qsTr("Graph of value 1+2")
            }

            TextField {
                id: kurveMinwert
                label: qsTr("Min. value")
                width: (parent.width / 2) - Theme.paddingSmall //10
                inputMethodHints: Qt.ImhDigitsOnly
                text: aktKurveMinwert !== orgKurveMinwert ? aktKurveMinwert : ""
                onTextChanged: {
                    kurveMinwertgesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Min. value") + " (" + aktKurveMinwert + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: kurveMaxwert.focus = true
            }

            TextField {
                id: kurveMaxwert
                label: qsTr("Max. value")
                width: (parent.width / 2) - Theme.paddingSmall //10
                inputMethodHints: Qt.ImhDigitsOnly
                text: aktKurveMaxwert !== orgKurveMaxwert ? aktKurveMaxwert : ""
                onTextChanged: {
                    kurveMaxwertgesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Max. value") + " (" + aktKurveMaxwert + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: kurveEinheit.focus = true
            }

            TextField {
                id: kurveEinheit
                label: qsTr("Unit")
                width: (parent.width / 2) - Theme.paddingSmall //10
                text: aktKurveEinheit !== orgKurveEinheit ? aktKurveEinheit : ""
                onTextChanged: {
                    kurveEinheitgesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Unit") + " (" + aktKurveEinheit + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: gueltigkeitstage.focus = true
            }


            SectionHeader {
                text: qsTr("Database")
            }


            TextSwitch {
                id: privat
                text: qsTr("Export private data")
                checked: aktPrivatexport
            }

            TextField {
                id: gueltigkeitstage
                label: qsTr("Valid for days (0=indefinite)")
                width: (parent.width) - Theme.paddingSmall //10
                inputMethodHints: Qt.ImhDigitsOnly
                text: aktGueltigkeitstage !== orgGueltigkeitstage ? aktGueltigkeitstage : "0"
                onTextChanged: {
                    gueltigkeitstagegesetzt = true
                }
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Valid for days (0=indefinite)") + " (" + aktGueltigkeitstage + ")"
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: standardEinstellungen.focus = true
            }

            Button {
                id: standardEinstellungen
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Reset all settings")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NachfrageAllesLoeschen.qml"), {
                                       werteListe: werteListe, modus: "standardeinstellungen"
                                   })
                        }
            }

            Button {
                id: reindex
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Reindex all values")
                onClicked: {
                    reindexWert();
                    close();
                }
            }

            Button {
                id: allesLoeschen
                text: qsTr("Delete all values")
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NachfrageAllesLoeschen.qml"), {
                                       werteListe: werteListe, modus: "loeschenWerte"
                                   })
                        }
            }
        }
    }

}
