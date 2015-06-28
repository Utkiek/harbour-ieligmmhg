import QtQuick 2.1
import Sailfish.Silica 1.0
import "helper/globs.js" as Globs

Dialog {
    id: eingabeDialog
    allowedOrientations: Orientation.All
    backNavigation: true

    property date aktDatum: new Date()
    property var locale: Qt.locale()

    property bool aktualisiereModus: false
    property alias datumButton: datumButton.value
    property alias uhrzeitButton: uhrzeitButton.value
    property alias systolic: systolic.text
    property alias diastolic: diastolic.text
    property alias bemerkung: bemerkung.text

    onAccepted: speicherWerte()

    function speicherWerte() {
        aktPrivat = privat.checked
        if (aktualisiereModus) {
            werteListe.editWert(datumButton.value + uhrzeitButton.value,
                                datumButton.value, uhrzeitButton.value,
                                systolic.text, diastolic.text, bemerkung.text,
                                privat.checked.toString())
        } else {
            werteListe.neuerWert(datumButton.value + uhrzeitButton.value,
                                 datumButton.value, uhrzeitButton.value,
                                 systolic.text, diastolic.text, bemerkung.text,
                                 privat.checked.toString())
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

            ValueButton {
                id: datumButton
                property date selectedDate

                function openDateDialog() {
                    var dialog = pageStack.push(
                                "Sailfish.Silica.DatePickerDialog", {
                                    date: selectedDate
                                })

                    dialog.accepted.connect(function () {
                        value = dialog.date.toLocaleDateString(locale, "dd.MM.yy")
                        selectedDate = dialog.date
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
                        value = dialog.time.toLocaleTimeString(locale, "hh:mm")
                        selectedHour = dialog.hour
                        selectedMinute = dialog.minute
                    })
                }

                label: qsTr("Time")
                value: aktDatum.toLocaleTimeString(locale, "hh:mm")
                onClicked: openTimeDialog()
            }

            TextField {
                id: systolic
                label: qsTr("Systolic")
                width: (parent.width / 2) - 10
                inputMethodHints: Qt.ImhDigitsOnly
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Systolic")
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: diastolic.focus = true
            }

            TextField {
                id: diastolic
                label: qsTr("Diastolic")
                width: (parent.width / 2) - 10
                inputMethodHints: Qt.ImhDigitsOnly
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Diastolic")
                font.pixelSize: Globs.gibThemeFontgroesse(aktFontstufe)
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: bemerkung.focus = true
            }
            TextField {
                id: bemerkung
                label: qsTr("Comment")
                width: parent.width - 20
                text: ""
                onFocusChanged: if (focus == true)
                                    selectAll()
                placeholderText: qsTr("Comment")
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: privat.focus = true
            }
            TextSwitch {
                id: privat
                text: qsTr("Private")
                checked: aktPrivat
            }
        }
    }
}
