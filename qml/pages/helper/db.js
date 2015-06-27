.import QtQuick.LocalStorage 2.0 as LS

function getDatabase(aktVersion) {
    var db= LS.LocalStorage.openDatabaseSync("IeligmmHg", aktVersion, "IeligmmHgDB", 100000);
    return db;
}

function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx,er) {
            //tx.executeSql('DROP TABLE wert;')
            //tx.executeSql('DROP TABLE einstellung;')
            tx.executeSql('CREATE TABLE IF NOT EXISTS wert(datumzeit TEXT PRIMARY KEY, datum TEXT, uhrzeit TEXT, sys TEXT, dia TEXT, bemerkung TEXT, privat TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS einstellung(url TEXT, parameter TEXT, wert TEXT)'); //kann ganz leer sein
        });
}


function dropTableWert() {
    var db = getDatabase();
    db.transaction(
        function(tx,er) {
            tx.executeSql('DROP TABLE wert;')
        }
    )
}

function schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        //console.debug("schreibe Seite in db:" + titel + " " + url);

        var rs = tx.executeSql('INSERT OR REPLACE INTO wert VALUES (?,?,?,?,?,?,?);', [datumzeit, datum,uhrzeit,sys,dia,bemerkung,privat]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Fehler";
        }
    }
    );
    return res;
}

function loescheWert(datumzeit) {
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM wert WHERE datumzeit=(?);', [datumzeit]);
//        if (rs.rowsAffected > 0) {
//            console.debug("DB Seite gelöscht");
//        } else {
//            console.debug("DB Seite löschen: Fehler");
//        }
    })
}

function gibWerte() {
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM wert ORDER BY wert.datumzeit desc;');
        werteListe.clear()
        for (var i = 0; i < rs.rows.length; i++) {
            werteListe.append({"datumzeit": rs.rows.item(i).datumzeit, "datum": rs.rows.item(i).datum, "uhrzeit": rs.rows.item(i).uhrzeit, "sys": rs.rows.item(i).sys, "dia": rs.rows.item(i).dia, "bemerkung": rs.rows.item(i).bemerkung, "privat": rs.rows.item(i).privat})
        //console.log("datumzeit:"+rs.rows.item(i).datumzeit+":uhrzeit:"+rs.rows.item(i).uhrzeit+":privat:"+rs.rows.item(i).privat)
        }
    })
}

function schreibeEinstellung(url,parameter,wert) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
        loescheEinstellung(url,parameter);
        //console.debug("schreibe Einstellung in db:" + url + " " + parameter);

        var rs = tx.executeSql('INSERT OR REPLACE INTO einstellung VALUES (?,?,?);', [url, parameter, wert]);
        if (rs.rowsAffected > 0) {
            res = "OK";
            //console.log ("DB Einstellung gespeichert: " + wert);
        } else {
            res = "Fehler";
            //console.log ("DB Einstellung speichern: Fehler");
        }
    }
    );
    return res;
}

function loescheEinstellung(url, parameter) {
    var db = getDatabase();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM einstellung WHERE url==(?) and parameter==(?);',[url,parameter]);
    })
}


function gibEinstellung(url, parameter) {
    var db = getDatabase();
    var ret = "";
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM einstellung WHERE url==(?) and parameter==(?);',[url,parameter]);
        if (rs.rows.length > 0) {
            //console.log ("DB Einstellung gelesen: " + rs.rows.item(0).wert);
            ret = rs.rows.item(0).wert
        } else {
            ret = "";
        }
    })
    return ret;
}

function gibEinstellungBool(url, parameter) {
    var db = getDatabase();
    var ret = false;
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM einstellung WHERE url==(?) and parameter==(?);',[url,parameter]);
        if (rs.rows.length > 0) {
            //console.debug ("DB EinstellungBool gelesen: " + string2Bool(rs.rows.item(0).wert));
            ret = string2Bool(rs.rows.item(0).wert);
        } else {
            //console.debug ("DB EinstellungBool nix gefunden" + url + " " + parameter);
            ret = false;
        }
    })
    return ret;
}

function gibEinstellungReal(url, parameter, vorgabe) {
    var db = getDatabase();
    var ret = vorgabe;
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM einstellung WHERE url==(?) and parameter==(?);',[url,parameter]);
        if (rs.rows.length > 0) {
            //console.log ("DB EinstellungReal gelesen: " + rs.rows.item(0).wert);
            ret = rs.rows.item(0).wert;
        } else {
            //console.log ("DB EinstellungReal nicht gefunden, Vorgabe: " + vorgabe);
            ret = vorgabe;
        }
    })
    return ret;
}

function string2Bool(str) {
    switch(str.toLowerCase()){
    case "true": case "yes": case "1": case "ja": return true;
    case "false": case "no": case "0": case "nein": case null: return false;
    default: return Boolean(string);
    }
}
