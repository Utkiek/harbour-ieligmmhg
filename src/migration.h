#ifndef MIGRATION_H
#define MIGRATION_H

#include <QObject>
#include <QDebug>
#include <QStringList>
#include <QFile>
#include <QDir>
#include <QSettings>
#include <QStandardPaths>

class Migration: public QObject
{
    Q_OBJECT

public:

    Q_PROPERTY(int param
               READ param
               WRITE setParam
               )

    explicit Migration(QObject *parent = 0);
    void migrateDatabase();

    Q_INVOKABLE bool istMigration();
    Q_INVOKABLE void meldeMigration();

    inline int param() const { return migraParam; };
    inline void setParam(const int &param) {migraParam = param; };

private:
    int migraParam;
};

#endif // MIGRATION_H
