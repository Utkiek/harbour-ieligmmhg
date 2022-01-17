import QtQuick 2.4
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Dialog {
    id: eingabeDialog
    allowedOrientations: Orientation.All
    backNavigation: true

    property string pageNachspeichern : "Wertliste.qml"
    property date aktDatum: new Date()
    property date aktEingabedatum: aktDatum
    property bool datumGeaendert: false
    property string altesDatumtext: ""
    property string alteUhrzeittext: ""

    property bool aktualisiereModus: false
    property alias datumButton: datumButton.value
    property alias uhrzeitButton: uhrzeitButton.value
    property alias aktsystolic: systolic.text
    property alias aktdiastolic: diastolic.text
    property alias aktbemerkung: bemerkung.text
    property alias aktPrivat: privat.checked
    property alias aktpuls: puls.text
    property alias gueltigkeitButton: gueltigkeitButton.value

    acceptDestination: Qt.resolvedUrl("Wertliste.qml")
    acceptDestinationAction: PageStackAction.Replace
    //acceptDestinationReplaceTarget : pageNachspeichern
    onAccepted: speicherWerte()

    function speicherWerte() {
        var tempstringDatum
        var neuesDatum
        var tempstringGueltigbis
        var neuesDatumGueltigbis

        aktPrivat = privat.checked
        tempstringDatum = datumButton.value;
        neuesDatum = Date.fromLocaleDateString(locale,tempstringDatum,"dd.MM.yy")
        tempstringDatum = neuesDatum.toLocaleDateString(locale,"yyyyMMdd")
        tempstringDatum = Globs.jahrhundert4zeitstempel(tempstringDatum)
        tempstringGueltigbis = gueltigkeitButton.value;
        neuesDatumGueltigbis = Date.fromLocaleDateString(locale,tempstringGueltigbis,"dd.MM.yy")
        tempstringGueltigbis = neuesDatumGueltigbis.toLocaleDateString(locale,"yyyyMMdd")
        if (aktualisiereModus) {
            if (datumGeaendert) {
                werteListe.loescheWert(altesDatumtext + alteUhrzeittext)
                werteListe.neuerWert(tempstringDatum + uhrzeitButton.value,
                                     datumButton.value, uhrzeitButton.value,
                                     systolic.text, diastolic.text, bemerkung.text,
                                     privat.checked.toString(), puls.text, tempstringGueltigbis)
            } else {
                werteListe.editWert(tempstringDatum + uhrzeitButton.value,
                                    datumButton.value, uhrzeitButton.value,
                                    systolic.text, diastolic.text, bemerkung.text,
                                    privat.checked.toString(), puls.text, tempstringGueltigbis)
            }
        } else {
            werteListe.neuerWert(tempstringDatum + uhrzeitButton.value,
                                 datumButton.value, uhrzeitButton.value,
                                 systolic.text, diastolic.text, bemerkung.text,
                                 privat.checked.toString(), puls.text, tempstringGueltigbis)
        }
    }

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: col.height * 1.1 + kopf.height

        ScrollDecorator { }

        DialogHeader {
            id: kopf
            acceptText: qsTr("Save")
            cancelText: qsTr("Cancel")
        }

        Column {
            id: col
            anchors.top: kopf.bottom
            anchors.topMargin: 25
            anchors.bottomMargin: 50
            width: parent.width
            spacing: 25
            function ok() {
                accepted()
            }

            ValueButton {
                id: datumButton
                property date selectedDate //: aktEingabedatum  //.toLocaleDateString(locale, "dd.MM.yy")

                function openDateDialog() {
                    var dialog = pageStack.push(
                                "Sailfish.Silica.DatePickerDialog", {
                                    date: selectedDate
                                })

                    dialog.accepted.connect(function () {
                        altesDatumtext = aktDatum.toLocaleDateString(locale, "yyyyMMdd")
                        alteUhrzeittext = uhrzeitButton.value
                        value = dialog.date.toLocaleDateString(locale, "dd.MM.yy")
                        selectedDate = dialog.date
                        aktEingabedatum = dialog.date
                        datumGeaendert = true
                    })
                }

                label: qsTr("Date")
                value: aktDatum.toLocaleDateString(locale, "dd.MM.yy")
                onClicked: openDateDialog()
            }
            ValueButton {
                id: uhrzeitButton
                property int selectedHour
                property int selectedMinute
                function openTimeDialog() {
                    var dialog = pageStack.push(
                                "Sailfish.Silica.TimePickerDialog", {
                                    hourMode: DateTime.TwentyFourHours,
                                    hour: selectedHour,
                                    minute: selectedMinute
                                })

                    dialog.accepted.connect(function () {
                        altesDatumtext = aktDatum.toLocaleDateString(locale, "yyyyMMdd")
                        alteUhrzeittext = uhrzeitButton.value
                        value = dialog.time.toLocaleTimeString(locale, "hh:mm")
                        selectedHour = dialog.hour
                        selectedMinute = dialog.minute
                        datumGeaendert = true
                    })
                }

                label: qsTr("Time")
                value: aktDatum.toLocaleTimeString(locale, "hh:mm")
                onClicked: openTimeDialog()
            }

            TextField {
                id: systolic
                label: aktFeldbezeichner1 //qsTr("Systolic")
                width: (parent.width * 2 / 3) - Theme.paddingSmall //10
                inputMethodHints: Qt.ImhDigitsOnly
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: aktFeldbezeichner1 //qsTr("Systolic")
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: diastolic.focus = true
            }

            TextField {
                id: diastolic
                label: aktFeldbezeichner2 //qsTr("Diastolic")
                width: (parent.width * 2 / 3) - Theme.paddingSmall //10
                inputMethodHints: Qt.ImhDigitsOnly
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: aktFeldbezeichner2 //qsTr("Diastolic")
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: puls.focus = true
                visible: aktFeldbezeichner2 !== ""
            }

            TextField {
                id: puls
                label: aktFeldbezeichner3 //qsTr("Pulse")
                width: (parent.width * 2 / 3 - Theme.paddingSmall) //10
                inputMethodHints: Qt.ImhDigitsOnly
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: aktFeldbezeichner3 //qsTr("Pulse")
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: bemerkung.focus = true
                visible: aktFeldbezeichner3 !== ""
            }

            TextArea {
                id: bemerkung
                label: aktFeldbezeichner4 //qsTr("Comment")
                width: parent.width
                text: ""
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: aktFeldbezeichner4 //qsTr("Comment")
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: privat.focus = true
                visible: aktFeldbezeichner4 !== ""
            }

            TextSwitch {
                id: privat
                text: qsTr("Private")
                checked: aktPrivat
                onCheckedChanged: gueltigkeitButton.focus = true
            }

            ValueButton {
                id: gueltigkeitButton
                property date selectedDate //: aktgueltigbis

                function openGDateDialog() {
                    selectedDate = gibGueltigkeit(aktEingabedatum) //aktGueltigkeitsdatum
                    var dialog = pageStack.push(
                                "Sailfish.Silica.DatePickerDialog", {
                                    date: selectedDate
                                })

                    dialog.accepted.connect(function () {
                        value = dialog.date.toLocaleDateString(locale, "dd.MM.yy")
                        selectedDate = dialog.date
                        //aktgueltigbis = dialog.date
                    })
                }

                label: qsTr("Valid until")
                value:
                    if (aktGueltigkeitstage !== 0) {
                        gibGueltigkeit(aktEingabedatum).toLocaleDateString(locale, "dd.MM.yy")
                    } else {
                        0
                    }

                visible: aktGueltigkeitstage !== 0
                onClicked: openGDateDialog()
            }
        }
    }
}
