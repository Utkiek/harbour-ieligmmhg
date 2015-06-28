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

import QtQuick 2.1
import Sailfish.Silica 1.0
import "pages"
import "pages/helper/db.js" as DB
import "pages/helper/globs.js" as Globs

ApplicationWindow
{   id: haupt

    property string aktDBVersion: "0.0.1"
    property string altVersion1: ""
    property string aktUrl
    property string aktTitel: "Ielig:mmHg"
    property bool aktPrivat: false
    property int aktseitenFontstufe: 1
    property int defaultFontSize: 26
    property int defaultFixedFontSize: 24
    property int minimumFontSize: 20
    property int fontpixelsize: 22


    //Einstellungen
    property string ieligmmhg: "ieligmmhg"
    property int aktFontstufe: 1

    initialPage: Component { Wertliste { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    function programmEinstellungen() {
        aktFontstufe = gibEinstellungReal(ieligmmhg,"Fontstufe",1)
    }


    ListModel {
        id: werteListe

        function editWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat) {
            for (var i=0; i<count; i++) {
                if (get(i).datumzeit === datumzeit) set(i,{"datum":datum, "uhrzeit":uhrzeit, "sys":sys, "dia":dia, "bemerkung":bemerkung, "privat":privat});
            }
            schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat);
            DB.gibWerte()
        }

        function loescheWert(datumzeit) {
            for (var i=0; i<count; i++) {
                if (get(i).datumzeit === datumzeit) remove(i);
            }
            DB.loescheWert(datumzeit);
            DB.gibWerte()
        }

        function neuerWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat) {
            append({"datumzeit": datumzeit, "datum":datum, "uhrzeit":uhrzeit, "sys":sys, "dia":dia, "bemerkung":bemerkung, "privat":privat})
            schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat);
            DB.gibWerte()
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
    }

   function schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat) {
        DB.schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat);
   }

   function gibEinstellung(url,parameter) {
       return DB.gibEinstellung(url,parameter)
   }

   function gibEinstellungBool(url,parameter) {
       return DB.gibEinstellungBool(url,parameter);
   }

   function gibEinstellungReal(url,parameter,vorgabe) {
       var s = "";
       s = DB.gibEinstellungReal(url,parameter,vorgabe.toString());
       return parseFloat(s);
   }

   function leseSeiteneinstellungen (url) {
       //aktJavascript = gibEinstellungBool(url,"Javascript")
       //neueWeite = gibEinstellungReal(url,"ZoomWeite",neueWeite)
       //aktUseragent = gibEinstellung(url,"Useragent")
       aktseitenFontstufe = gibEinstellungReal(url,"Font",aktseitenFontstufe)
   }

   function editEinstellung(url, parameter, wert) {
     DB.schreibeEinstellung(url, parameter, wert);
   }

   function loescheEinstellung(url) {
     DB.loescheEinstellung(url);
   }


    Component.onCompleted: {
        DB.initialize(aktDBVersion);
        programmEinstellungen();
        DB.gibWerte();

    }

}

