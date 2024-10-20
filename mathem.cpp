#include "mathem.h"

Mathem::Mathem(QObject *parent)
    : QObject{parent}
{}

void Mathem::testFunc()
{
    qDebug()<<"testFunc";
}
