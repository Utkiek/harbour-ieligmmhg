.import QtQuick.LocalStorage 2.0 as LS


function getDatabase() {
    if (haupt.dbgeoeffnet) {
        return haupt.dbglobal
    } else {
        haupt.dbglobal = LS.LocalStorage.openDatabaseSync("IeligmmHg", "",
                                                          "IeligmmHgDB", 100000)
        haupt.dbgeoeffnet = true
        return haupt.dbglobal
    }
}

function initialize(aktVersion, altVersion) {
    var db = getDatabase()
    var ispuls = false
    var isthema = false
    var isgueltigbis = false

    try {
        db.transaction(function (tx, er) {
            var rs = tx.executeSql('SELECT * FROM wert;')
        })
    } catch (e) {
        db.transaction(function (tx, er) {
            //tx.executeSql('DROP TABLE wert;')
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS wert(datumzeit TEXT PRIMARY KEY, datum TEXT, uhrzeit TEXT, sys TEXT DEFAULT "", dia TEXT DEFAULT "", bemerkung TEXT DEFAULT "", privat TEXT DEFAULT "", puls TEXT DEFAULT "", thema TEXT DEFAULT "", gueltigbis TEXT DEFAULT "")')
        })
    }

    try {
        db.transaction(function (tx, er) {
            var rs = tx.executeSql('SELECT * FROM einstellung;')
        })
    } catch (e) {
        db.transaction(function (tx, er) {
            //tx.executeSql('DROP TABLE einstellung;')
            tx.executeSql(
                        'CREATE TABLE IF NOT EXISTS einstellung(url TEXT, parameter TEXT, wert TEXT DEFAULT "", thema TEXT DEFAULT "")') //kann ganz leer sein
        })
    }

    if (!haupt.dbgeprueft) {
        db.transaction(function (tx, er) {
            var rs = tx.executeSql("PRAGMA table_info('wert')")
            for (var i = 0; i < rs.rows.length; i++) {
                if (rs.rows.item(i).name === "puls") {
                    ispuls = true
                }
                if (rs.rows.item(i).name === "thema") {
                    isthema = true
                }
                if (rs.rows.item(i).name === "gueltigbis") {
                    isgueltigbis = true
                }
                //console.log("Schema:"+rs.rows.item(i).name);
            }
        })

        if (ispuls) {

            //        if (db.version < haupt.aktDBVersion) {
            //            db.changeVersion(db.version,haupt.aktDBVersion);
            //        }
        } else {
            //console.log("Puls nicht gefunden, wird angehängt: DBVersion ist: " + db.version)
            try {
                db.transaction(function (tx, er) {
                    tx.executeSql('ALTER TABLE wert ADD COLUMN puls TEXT DEFAULT ""')
                })
                db.transaction(function (tx, er) {
                    tx.executeSql('UPDATE wert SET datumzeit = replace(substr(datumzeit,1,2),"19","20") || substr(datumzeit,3) WHERE datumzeit LIKE "19%";')
                })
            } catch (e) {

            }
        }
        if (!isthema) {
            //console.log("Thema nicht gefunden, wird angehängt: DBVersion ist: " + db.version)
            try {
                db.transaction(function (tx, er) {
                    tx.executeSql('ALTER TABLE wert ADD COLUMN thema TEXT DEFAULT ""')
                })
                db.transaction(function (tx, er) {
                    tx.executeSql('UPDATE wert SET thema = ?', aktThema)
                })
            } catch (e) {

            }
        }
        if (!isgueltigbis) {
            //console.log("Gueligbis nicht gefunden, wird angehängt: DBVersion ist: " + db.version)
            try {
                db.transaction(function (tx, er) {
                    tx.executeSql('ALTER TABLE wert ADD COLUMN gueltigbis TEXT DEFAULT ""')
                })
            } catch (e) {

            }
        }

        db.transaction(function (tx, er) {
            var rs = tx.executeSql("PRAGMA table_info('einstellung')")
            isthema = false
            for (var i = 0; i < rs.rows.length; i++) {
                if (rs.rows.item(i).name === "thema") {
                    isthema = true
                }
            }
        })
        if (!isthema) {
            //console.log("Thema in Einstellung nicht gefunden, wird angehängt: DBVersion ist: "
            //            + db.version)
            try {
                db.transaction(function (tx, er) {
                    tx.executeSql(
                                'ALTER TABLE einstellung ADD COLUMN thema TEXT')
                })
                db.transaction(function (tx, er) {
                    tx.executeSql('UPDATE einstellung SET thema = ?', aktThema)
                })
            } catch (e) {

            }
        }
        haupt.dbgeprueft = true
    }
    return
}

function dropTableWert() {
    var db = getDatabase()
    db.transaction(function (tx, er) {
        tx.executeSql('DROP TABLE wert;')
    })
    db.transaction(function (tx, er) {
        tx.executeSql(
                    'CREATE TABLE IF NOT EXISTS wert(datumzeit TEXT PRIMARY KEY, datum TEXT, uhrzeit TEXT, sys TEXT, dia TEXT, bemerkung TEXT, privat TEXT, puls TEXT, thema TEXT, gueltigbis TEXT)')
    })
}

function dropTableEinstellung() {
    var db = getDatabase()
    db.transaction(function (tx, er) {
        tx.executeSql('DROP TABLE einstellung;')
    })
    db.transaction(function (tx, er) {
        tx.executeSql(
                    'CREATE TABLE IF NOT EXISTS einstellung(url TEXT, parameter TEXT, wert TEXT, thema TEXT)') //kann ganz leer sein
    })
}

function schreibeWert(datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, thema, gueltigbis) {
    var db = getDatabase()
    var res = ""

    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'INSERT OR REPLACE INTO wert VALUES (?,?,?,?,?,?,?,?,?,?);',
                    [datumzeit, datum, uhrzeit, sys, dia, bemerkung, privat, puls, thema, gueltigbis])
        if (rs.rowsAffected > 0) {
            res = "OK"
        } else {
            res = "Fehler"
        }
    })
    //console.log("db.js schreibeWert :" + datumzeit+datum+uhrzeit+sys+dia+bemerkung+privat+puls+thema+gueltigbis + ": Status: " + res)
    return res
}

function gibWerte(thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT * FROM wert WHERE thema = ? ORDER BY wert.datumzeit desc;',
                    [thema])
        werteListe.clear()
        for (var i = 0; i < rs.rows.length; i++) {
            werteListe.append({
                                  datumzeit: rs.rows.item(i).datumzeit,
                                  datum: rs.rows.item(i).datum,
                                  uhrzeit: rs.rows.item(i).uhrzeit,
                                  sys: rs.rows.item(i).sys,
                                  dia: rs.rows.item(i).dia,
                                  bemerkung: rs.rows.item(i).bemerkung,
                                  privat: rs.rows.item(i).privat,
                                  puls: rs.rows.item(i).puls,
                                  thema: rs.rows.item(i).thema,
                                  gueltigbis: rs.rows.item(i).gueltigbis
                              })
            //console.log("db.js: gibWerte: datumzeit:"+rs.rows.item(i).datumzeit+":uhrzeit:"+rs.rows.item(i).uhrzeit+":privat:"+rs.rows.item(i).privat+":puls:"+rs.rows.item(i).puls+":thema:"+rs.rows.item(i).thema+":")
        }
    })
}

function loescheWert(datumzeit, thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'DELETE FROM wert WHERE datumzeit=(?) and thema=(?);',
                    [datumzeit, thema])
    })
}

function loescheAbgelaufeneWerte(datumzeit, thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'DELETE FROM wert WHERE gueltigbis<(?) and gueltigbis not null and gueltigbis >(?) and thema=(?);',
                    [datumzeit, "0", thema])
    })
}

function loescheAbgelaufeneWerteAlleThemen(datumzeit) {
    var db = getDatabase()
    var sdatumzeit
    sdatumzeit = datumzeit === "" ? "0" : datumzeit
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'DELETE FROM wert WHERE gueltigbis<(?) and gueltigbis not null and gueltigbis != (?) and gueltigbis != (?);',
                    [sdatumzeit, "0", ""])
    })
}

function loeschealleWerte(thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql('DELETE FROM wert WHERE thema=(?);', [thema])
    })
}

function loeschealleThemaWerte(thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql('DELETE FROM wert WHERE thema=(?);', [thema])
    })
}

function schreibeEinstellung(url, parameter, wert, thema) {
    var db = getDatabase()
    var res = ""
    db.transaction(function (tx) {
        loescheEinstellung(url, parameter, thema)

        //console.debug("schreibe Einstellung in db:" + url + " " + parameter);
        var rs = tx.executeSql(
                    'INSERT OR REPLACE INTO einstellung VALUES (?,?,?,?);',
                    [url, parameter, wert, thema])
        if (rs.rowsAffected > 0) {
            res = "OK"
        } else {
            res = "Fehler"
        }
    })
    return res
}

function schreibeEinstellungthema(url, parameter, wert, thema) {
    var db = getDatabase()
    var res = ""
    db.transaction(function (tx) {
        loescheEinstellungthema(url, parameter, wert)

        //console.debug("schreibe Einstellung in db:" + url + " " + parameter);
        var rs = tx.executeSql(
                    'INSERT OR REPLACE INTO einstellung VALUES (?,?,?,?);',
                    [url, parameter, wert, thema])
        if (rs.rowsAffected > 0) {
            res = "OK"
        } else {
            res = "Fehler"
        }
    })
    return res
}

function loescheEinstellung(url, parameter, thema) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'DELETE FROM einstellung WHERE url==(?) and parameter==(?) and thema==(?);',
                    [url, parameter, thema])
    })
}

function loescheEinstellungthema(url, parameter, wert) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'DELETE FROM einstellung WHERE url==(?) and parameter==(?) and wert==(?);',
                    [url, parameter, wert])
    })
}

function gibEinstellung(url, parameter, thema) {
    var db = getDatabase()
    var ret = ""
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT * FROM einstellung WHERE url==(?) and parameter==(?)and thema==(?);',
                    [url, parameter, thema])
        if (rs.rows.length > 0) {
            //console.log ("DB Einstellung gelesen: " + rs.rows.item(0).wert);
            ret = rs.rows.item(0).wert
        } else {
            ret = ""
        }
    })
    return ret
}

function gibEinstellungBool(url, parameter, thema) {
    var db = getDatabase()
    var ret = false
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT * FROM einstellung WHERE url==(?) and parameter==(?) and thema==(?);',
                    [url, parameter, thema])
        if (rs.rows.length > 0) {
            //console.debug ("DB EinstellungBool gelesen: " + string2Bool(rs.rows.item(0).wert));
            ret = string2Bool(rs.rows.item(0).wert)
        } else {
            //console.debug ("DB EinstellungBool nix gefunden" + url + " " + parameter);
            ret = false
        }
    })
    return ret
}

function gibEinstellungReal(url, parameter, vorgabe, thema) {
    var db = getDatabase()
    var ret = vorgabe
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT * FROM einstellung WHERE url==(?) and parameter==(?)and thema==(?);',
                    [url, parameter, thema])
        if (rs.rows.length > 0) {
            //console.log ("DB EinstellungReal gelesen: " + rs.rows.item(0).wert);
            ret = rs.rows.item(0).wert
        } else {
            //console.log ("DB EinstellungReal nicht gefunden, Vorgabe: " + vorgabe);
            ret = vorgabe
        }
    })
    return ret
}

function gibThemen(url, parameter) {
    var db = getDatabase()
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT * FROM einstellung WHERE url==(?) and parameter==(?) ORDER BY thema;',
                    [url, parameter])
        //console.log("db.js.gibThemen")
        themenListe.clear()
        for (var i = 0; i < rs.rows.length; i++) {
            themenListe.append({
                                   url: rs.rows.item(i).url,
                                   parameter: rs.rows.item(i).parameter,
                                   wert: rs.rows.item(i).wert,
                                   thema: rs.rows.item(i).thema
                               })
        }
    })
}
function string2Bool(str) {
    switch (str.toLowerCase()) {
    case "true":

    case "yes":

    case "1":

    case "ja":
        return true
    case "false":

    case "no":

    case "0":

    case "nein":

    case null:
        return false
    default:
        return Boolean(string)
    }
}




