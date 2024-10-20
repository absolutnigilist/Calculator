#ifndef MATHEM_H
#define MATHEM_H

#include <QObject>
#include <QQmlEngine>

class Mathem : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit Mathem(QObject *parent = nullptr);
    Q_INVOKABLE void testFunc();


signals:
};

#endif // MATHEM_H
