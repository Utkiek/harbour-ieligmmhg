#include "migration.h"

Migration::Migration(QObject *parent) :
    QObject(parent)
{
}


void Migration::migrateDatabase()
{
    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/de.ielig/IeligMmhg/IeligMmhg.conf", QSettings::NativeFormat);
    if (settings.contains("migrated430sailjailDB")) {
//           settings.remove("migrated430sailjail");
//           qDebug() << "Migration: Setting gelöscht";
        return;
    }

    QStringList filter;
    filter << "*.ini";

    QString quelle = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/harbour-ieligmmhg/harbour-ieligmmhg/QML/OfflineStorage/Databases";
    QString ziel = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/de.ielig/IeligMmhg/QML/OfflineStorage/Databases";

    QDir dir(quelle);
    QStringList dirs = dir.entryList(filter);

//    qDebug() << "Migration Quelle :" << quelle << ": Ziel :" << ziel;
//    qDebug() << "Gefunden Anzahl:" << dirs.size();

    if (dirs.size() > 0) {

        QFile::remove(ziel + "/" + dirs.at(0));
        QFile::copy(quelle + "/" + dirs.at(0), ziel + "/" + dirs.at(0));

//        qDebug() << "Gefunden :" << dirs.at(0);
    } else {
        return;
    }

    QStringList filter2;
    filter2 << "*.sqlite";

    QDir dir2(ziel);
    if (!dir2.exists()) {
        return;
    }
    QStringList dirs2 = dir.entryList(filter2);

//    qDebug() << "Gefunden Anzahl 2:" << dirs2.size();

    if (dirs2.size() > 0) {

        QFile::remove(ziel + "/" + dirs2.at(0));
        QFile::copy(quelle + "/" + dirs2.at(0), ziel + "/" + dirs2.at(0));

//        qDebug() << "Gefunden 2 :" << dirs2.at(0);
    }

    settings.setValue("migrated430sailjailDB", "true");
}

bool Migration::istMigration() {
    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/de.ielig/IeligMmhg/IeligMmhg.conf", QSettings::NativeFormat);
    return settings.contains("migrated430sailjailSettings");
}

void Migration::meldeMigration() {
    QSettings settings(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/de.ielig/IeligMmhg/IeligMmhg.conf", QSettings::NativeFormat);
    settings.setValue("migrated430sailjailSettings", "true");
}
