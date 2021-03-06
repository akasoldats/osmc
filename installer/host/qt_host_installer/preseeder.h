#ifndef PRESEEDER_H
#define PRESEEDER_H
#include <QString>
#include <QStringList>
#include "networksettings.h"

class Preseeder
{
public:
    Preseeder();
    void setLanguageString(QString language);
    void setNetworkSettings(NetworkSettings *ns);
    QStringList getPreseed() { return preseedStringList; }
    static const int PRESEED_STRING = 0;
    static const int PRESEED_BOOL = 1;
private:
    QStringList preseedStringList;
    QString languageString;
    QString installDestString;
    void writeOption(QString preseedSection, QString preseedOptionKey, int preseedOptionType, QString preseedOptionValue);
};

#endif // PRESEEDER_H
