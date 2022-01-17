/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.4
import Sailfish.Silica 1.0
import "pages"
import "pages/helper/db.js" as DB
import "pages/helper/globs.js" as Globs

ApplicationWindow
{   id: haupt

    property var dbglobal
    property bool dbgeoeffnet: false
    property bool dbgeprueft: false
    property string aktDBVersion: "0.0.2"
    property string altDBVersion: "0.0.1"
    property string altVersion1: ""
    property string aktTitel: "Ielig:mmHg"
    property string aktThema: "global"
    property string globalThema: "global"
    property string parameterThema: "Thema"
    property string parameterAkthema: "Aktthema"
    property bool aktKeinstartbild: false
    property bool aktPrivat: false
    property bool aktPrivatexport: false
    property string aktGueltigbis: ""
    property int aktGueltigkeitstage: 0
    property string aktFeldbezeichner1: qsTr("Systolic")
    property string aktFeldbezeichner2: qsTr("Diastolic")
    property string aktFeldbezeichner3: qsTr("Pulse")
    property string aktFeldbezeichner4: qsTr("Comment")
    //property string aktFeldbezeichner5: qsTr("Lifetime")
    property string orgFeldbezeichner1: qsTr("Systolic")
    property string orgFeldbezeichner2: qsTr("Diastolic")
    property string orgFeldbezeichner3: qsTr("Pulse")
    property string orgFeldbezeichner4: qsTr("Comment")
    //property string orgFeldbezeichner5: qsTr("Lifetime")
    property int aktKurveMinwert: 50
    property int aktKurveMaxwert: 200
    property string aktKurveEinheit: "mmHg"
    property string orgKurveEinheit: "mmHg"
    property int orgKurveMinwert: 50
    property int orgKurveMaxwert: 200
    property int orgGueltigkeitstage: 0
    property date maxGueltigkeitsdatum: "2999-12-31";
    property date aktGueltigkeitsdatum: maxGueltigkeitsdatum
    property int aktseitenFontstufe: 1
    property int defaultFontSize: 26
    property int defaultFixedFontSize: 24
    property int minimumFontSize: 20
    property int fontpixelsize: 22
    property var locale: Qt.locale()
    property date neuesDatum;
    property string tempstring;
    property bool programmistinit: false

    //Einstellungen
    property string ieligmmhg: "ieligmmhg"
    property string aktUrl: ieligmmhg
    property int aktFontstufe: 1


    //initialPage: Component { Themaauswahl { } }
    //initialPage: Qt.resolvedUrl(programmInitAnzahl() < 2 ? "pages/Wertliste.qml" : "pages/Themaauswahl.qml" )
    initialPage: Qt.resolvedUrl("pages/"+programmInit() )
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    function programmEinstellungen() {
        var wert
        var wert2
        var wert3
        var wert4
        var zahl
        var wertGefunden
        resetEinstellungen()
        aktThema = gibEinstellung(aktUrl,parameterAkthema,globalThema)
        if (aktThema === "") aktThema = globalThema
        aktFontstufe = gibEinstellungReal(aktUrl,"Fontstufe",1,globalThema)
        aktKeinstartbild = gibEinstellungBool(aktUrl,"keinStartbild",aktThema)
        aktPrivatexport = gibEinstellungBool(aktUrl,"Privatexport",aktThema)

        wert = gibEinstellung(aktUrl,"Feldbezeichner1",aktThema)
        if ((wert !== "") && (wert !== undefined)) {
            aktFeldbezeichner1 = wert
            wertGefunden = true
        } else {
            aktFeldbezeichner1 = aktThema === globalThema ? orgFeldbezeichner1 : ""
            wertGefunden = false
        }
        wert2 = gibEinstellung(aktUrl,"Feldbezeichner2",aktThema)
        if ((wert2 !== "") && (wert2 !== undefined)) {
            aktFeldbezeichner2 = wert2
            wertGefunden = true
        } else {
            if (wertGefunden) aktFeldbezeichner2 = aktThema === globalThema ? orgFeldbezeichner2 : ""
        }
        wert3 = gibEinstellung(aktUrl,"Feldbezeichner3",aktThema)
        if ((wert3 !== "") && (wert3 !== undefined)) {
            aktFeldbezeichner3 = wert3
            wertGefunden = true
        } else {
            if (wertGefunden) aktFeldbezeichner3 = aktThema === globalThema ? orgFeldbezeichner3 : ""
        }
        wert4 = gibEinstellung(aktUrl,"Feldbezeichner4",aktThema)
        if ((wert4 !== "") && (wert4 !== undefined)) {
            aktFeldbezeichner4 = wert4
            wertGefunden = true
        } else {
            if (wertGefunden) aktFeldbezeichner4 = aktThema === globalThema ? orgFeldbezeichner4 : ""
        }
        zahl = 0
        zahl = gibEinstellungReal(aktUrl,"KurveMinwert",orgKurveMinwert,aktThema)
        if (zahl !== undefined) aktKurveMinwert = zahl
        zahl = gibEinstellungReal(aktUrl,"KurveMaxwert",orgKurveMaxwert,aktThema)
        if (zahl !== undefined) aktKurveMaxwert = zahl
        wert = gibEinstellung(aktUrl,"KurveEinheit",aktThema)
        if ((wert !== "") && (wert !== undefined)) aktKurveEinheit = wert
        zahl = gibEinstellungReal(aktUrl,"GueltigkeitBis",orgGueltigkeitstage,aktThema)
        if (zahl !== undefined) aktGueltigkeitstage = zahl
    }

    function resetEinstellungen() {
        aktFontstufe = 1
        aktPrivatexport = false
        aktFeldbezeichner1 = orgFeldbezeichner1
        aktFeldbezeichner2 = orgFeldbezeichner2
        aktFeldbezeichner3 = orgFeldbezeichner3
        aktFeldbezeichner4 = orgFeldbezeichner4
        aktKurveMinwert = orgKurveMinwert
        aktKurveMaxwert = orgKurveMaxwert
        aktKurveEinheit = orgKurveEinheit
    }

    ListModel {
        id: werteListe

        function editWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, gueltigkeit) {
            for (var i=0; i<count; i++) {
                if (get(i).datumzeit === datumzeit) set(i,{"datum":datum, "uhrzeit":uhrzeit, "sys":sys, "dia":dia, "bemerkung":bemerkung, "privat":privat, "puls":puls});
            }
            schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, aktThema, gueltigkeit);
            werteListe.clear();
            DB.gibWerte(aktThema)
        }

        function loescheWert(pdatumzeit) {
            //console.log("haupt wertListe.loescheWert suche datumzeit :" + pdatumzeit + ":")
            for (var i=0; i<count; i++) {                
                if (get(i).datumzeit === pdatumzeit) {
                    remove(i);
                }
            }
            DB.loescheWert(pdatumzeit,aktThema);
            DB.gibWerte(aktThema)
        }

        function neuerWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, gueltigkeit) {
            append({"datumzeit": datumzeit, "datum":datum, "uhrzeit":uhrzeit, "sys":sys, "dia":dia, "bemerkung":bemerkung, "privat":privat, "puls":puls, "thema":aktThema, "gueltigis":aktGueltigbis})
            schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, aktThema, gueltigkeit);
            werteListe.clear();
            DB.gibWerte(aktThema)
        }

        function ersteDatumzeit() {
            if (werteListe.count > 1) {
                var werteElement = werteListe.get(werteListe.count -1)
                var retwert = werteElement.datumzeit
                return retwert
            }
        }
        function letzteDatumzeit() {
            if (werteListe.count > 1) {
                var werteElement = werteListe.get(0)
                var retwert = werteElement.datumzeit
                return retwert
            }
        }
        function ersteDatum() {
            if (werteListe.count > 1) {
                var werteElement = werteListe.get(werteListe.count -1)
                var retwert = werteElement.datum
                return retwert
            }
        }
        function letzteDatum() {
            if (werteListe.count > 1) {
                var werteElement = werteListe.get(0)
                var retwert = werteElement.datum
                return retwert
            }
        }
        function letzteWerte() {
            if (werteListe.count > 1) {
                var werteElement = werteListe.get(werteListe.count -1)
                var retwert = werteElement.sys + "  /  " + werteElement.dia
                return retwert
            }
        }
        function aktualisiereWerte() {
            werteListe.clear();
            DB.gibWerte(aktThema)
        }
    }

   function schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, thema, gueltigbis) {
        DB.schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, thema, gueltigbis);
   }


   function reindexWert() {
       DB.loeschealleWerte(aktThema);
       var werteElement;
       for (var i = 0; i < werteListe.count; i++) {
           werteElement = werteListe.get(i);
           tempstring = werteElement.datum;
           neuesDatum = Date.fromLocaleDateString(locale,tempstring,"dd.MM.yy")
           tempstring = Globs.jahrhundert4zeitstempel(neuesDatum.toLocaleDateString(locale,"yyyyMMdd"))
           schreibeWert(tempstring + werteElement.uhrzeit,
                        werteElement.datum,werteElement.uhrzeit,werteElement.sys, werteElement.dia,
                        werteElement.bemerkung, werteElement.privat, werteElement.puls, aktThema, werteElement.gueltigbis);
       }
       werteListe.clear();
       DB.gibWerte(aktThema);
   }

   ListModel {
       id: themenListe

       function editThemenwert(wert) {
           editEinstellungthema(wert)
           themenListe.clear();
           DB.gibThemen(aktUrl,parameterThema);
       }

       function loescheWert(wert) {
           if (wert === aktThema) {
               aktThema = ""
               editEinstellung(aktUrl,parameterAkthema,neuesThema,globalThema)
               programmEinstellungen();
           }

           loescheEinstellungthema(wert);
           themenListe.clear();
           DB.gibThemen(aktUrl,parameterThema);

       }

       function neuerWert(wert) {
           editEinstellungthema(wert)
           themenListe.clear();
           DB.gibThemen(aktUrl,parameterThema);
       }
   }

   function wechsleThema(neuesThema) {
       aktThema = neuesThema;
       editEinstellung(aktUrl,parameterAkthema,neuesThema,globalThema)
       programmEinstellungen();
       werteListe.clear();
       DB.gibWerte(aktThema)
   }

   function gibEinstellung(url,parameter,thema) {
       return DB.gibEinstellung(url,parameter,thema)
   }

   function gibEinstellungBool(url,parameter,thema) {
       return DB.gibEinstellungBool(url,parameter,thema);
   }

   function gibEinstellungReal(url,parameter,vorgabe,thema) {
       var s = "";
       s = DB.gibEinstellungReal(url,parameter,vorgabe.toString(),thema);
       return parseFloat(s);
   }

   function leseSeiteneinstellungen (url) {
       aktseitenFontstufe = gibEinstellungReal(url,"Font",aktseitenFontstufe)
   }

   function editEinstellung(url, parameter, wert, thema) {
     DB.schreibeEinstellung(url, parameter, wert, thema);
   }

   function editEinstellungthema(wert) {
       return DB.schreibeEinstellungthema(aktUrl, parameterThema, wert, globalThema)
   }

   function loescheEinstellung(url,parameter,thema) {
     DB.loescheEinstellung(url,parameter,thema);
   }

   function loescheEinstellungthema(wert) {
     DB.loescheEinstellungthema(aktUrl,parameterThema,wert);
   }

   function gibGueltigkeit(aktuellesDatum) {
       if (aktGueltigkeitstage == 0) {
           return maxGueltigkeitsdatum
       } else {
           var neugueltig = new Date(aktuellesDatum)
           neugueltig.setDate(neugueltig.getDate() + aktGueltigkeitstage)
           return neugueltig
       }
   }

//    Component.onCompleted: {
//        DB.initialize(aktDBVersion,altDBVersion);
//        DB.gibThemen(aktUrl,parameterThema);
//        programmEinstellungen();
//        DB.gibWerte(aktThema);
//    }

   function programmInitAnzahl() {
       if (!programmistinit) {
           DB.initialize(aktDBVersion,altDBVersion);
           DB.gibThemen(aktUrl,parameterThema);
           programmEinstellungen();
           DB.loescheAbgelaufeneWerteAlleThemen()
           DB.gibWerte(aktThema);
           programmistinit = true
       }
       return themenListe.count
   }

   function programmInit() {
       var heute = new Date().toLocaleDateString(locale,"yyyyMMdd")
       if (!programmistinit) {
           DB.initialize(aktDBVersion,altDBVersion);
           DB.gibThemen(aktUrl,parameterThema);
           programmEinstellungen();
           DB.loescheAbgelaufeneWerteAlleThemen(heute);
           DB.gibWerte(aktThema);
           programmistinit = true
           if (aktKeinstartbild) {
               return "Wertliste.qml"
           } else {
               return "Willkommen.qml"
           }
       } else {
           if (aktKeinstartbild) {
               return "Wertliste.qml"
           } else {
               return "Willkommen.qml"
           }
       }
   }

}

