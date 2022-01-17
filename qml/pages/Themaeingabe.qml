import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Dialog {
    id: eingabeDialog
    allowedOrientations: Orientation.All
    backNavigation: true

    property date aktDatum: new Date()

    property bool aktualisiereModus: false
    property string akteingabethemawert: ""//themenwert.text

    acceptDestination: Qt.resolvedUrl("Einstellungen.qml")
    acceptDestinationAction: PageStackAction.Replace

    onAccepted: speicherWerte()

    function speicherWerte() {
        if (aktualisiereModus) {
            themenListe.editWert(themenwert.text)
        } else {
            themenListe.neuerWert(themenwert.text)
            wechsleThema(themenwert.text)
        }
    }

    //darf nicht Keys.onEnterPressed: speicherWerte();
    //darf nicht Keys.onReturnPressed: speicherWerte();

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: col.height + kopf.height

        DialogHeader {
            id: kopf
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        Column {
            id: col
            anchors.top: kopf.bottom
            anchors.topMargin: 25
            width: parent.width
            spacing: 25
            function ok() {
                accepted()
            }


            TextField {
                id: themenwert
                label: qsTr("Theme")
                //width: (parent.width / 2) - Theme.paddingSmall //10
                width: deviceOrientation == Orientation.Portrait ? (parent.width) - Theme.paddingSmall : (parent.width / 2) - Theme.paddingSmall
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Theme")
                text: aktualisiereModus ? akteingabethemawert : ""
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                //EnterKey.enabled: text.length > 0
                //EnterKey.iconSource: "image://theme/icon-m-enter-next"
                //EnterKey.onClicked: diastolic.focus = true
            }

        }
    }
}
