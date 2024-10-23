
pragma ComponentBehavior: Bound

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import MyModule 1.0
import "calculator.js" as Calculator

Window {
    id: main
    width: 360
    height: 616
    visible: true
    title: qsTr("Calculator")

    // Подключаем шрифт через FontLoader
        FontLoader {
            id: openSansSemibold
            source: "qrc:/fonts/OpenSansSemibold.ttf" // Указываем путь к шрифту
        }


    // Импортируем JavaScript-файл
    QtObject {
        id: calculator
        Component.onCompleted: {
            console.log("Calculator loaded");
        }
    }

    Mathem{
        id:mathInst
    }
    Component.onCompleted:
    {
        console.log(mathInst.testFunc());
    }

    property string display: ""
    property double firstNumber: 0
    property double secondNumber: 0
    property string operator: ""

    property string secretCode: ""
    property bool secretMenuOpened: false

    // Таймер для отслеживания долгого нажатия
    Timer {
        id: timer
        interval: 4000
        running: false
        repeat: false

        onTriggered:
        {
            main.secretCode = ""; // Сбрасываем комбинацию
        }
    }
    // Таймер для отслеживания ввода кода
    Timer {
        id: codeTimer
        interval: 5000
        running: false
        repeat: false

        onTriggered:
        {
            main.secretCode = ""; // Сбрасываем код после 5 секунд
        }
    }
    // Экран секретного меню
        Rectangle {
            id: secretMenu
            width: parent.width
            height: parent.height
            visible: main.secretMenuOpened
            color: "#024873"

            Text {
                text: "Секретное меню"
                font.pixelSize: 32
                color: "white"
                anchors.centerIn: parent
            }

            Button {
                text: "Назад"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    main.secretMenuOpened = false
                }
            }
        }
    // Основное окно калькулятора
    Rectangle {
        id:mainRect
        width: parent.width
        height: parent.height
        color: "#024873" // Фоновый цвет
        visible: !main.secretMenuOpened

        // Экран для вывода
        Rectangle {
            id:outRect
            width: parent.width
            height: parent.height * 0.3
            color: "#04BFAD"
            radius: 10
            anchors.top: parent.top
            anchors.topMargin: -10
            Rectangle
            {
                id: frstDsp
                width:281
                height:30
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.bottom:rsltDsp.top
                anchors.bottomMargin:10
                color:"transparent"
                Text {
                    id: firstDisplay
                    font.family:openSansSemibold.name
                    text: main.display
                    font.pixelSize: 24
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right // Выравнивание по правому краю
                    horizontalAlignment: Text.AlignRight
                    clip: true // Обрезаем текст, если он выходит за пределы
                }
            }

            Rectangle
            {
                id:rsltDsp
                width:281
                height:60
                anchors.horizontalCenter:parent.horizontalCenter
                anchors.bottom:parent.bottom
                anchors.bottomMargin:10
                color:"transparent"
                Text {
                    id: resultDisplay
                    text: main.display // Пример текста
                    font.family:openSansSemibold.name
                    font.pixelSize: 48
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    horizontalAlignment: Text.AlignRight // Выравнивание по правому краю
                    clip: true // Обрезать текст, если он выходит за пределы


                }
            }

        }

        // Сетка кнопок
        GridLayout {
            id: buttonGrid
            rows:5
            columns:4
            anchors.top: outRect.bottom
            anchors.topMargin: 24
            anchors.right:outRect.right
            anchors.rightMargin: 24
            anchors.left:outRect.left
            anchors.leftMargin: 24
            anchors.bottom:parent.bottom
            anchors.bottomMargin: 24

            property var buttons: [
                "()", "+/-", "%", "÷",
                "7", "8", "9", "×",
                "4", "5", "6", "-",
                "1", "2", "3", "+",
                "C", "0", ".", "="
            ]

            Repeater {
                id:rpt
                model: buttonGrid.buttons

                Rectangle{
                    id: baseBtnRect
                    Layout.fillHeight:true
                    Layout.fillWidth:true
                    required property string modelData
                    color: "transparent"

                    RoundButton {
                        id:btn
                        anchors.centerIn: parent
                        width:60
                        height:60
                        background: Rectangle {
                            id: bb
                            // Цвета кнопок
                            color: (baseBtnRect.modelData == "C") ? "#F25E5E" :
                                                                    (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                                                     baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#0889A6" :"#B0D1D8" // Цвет цифр
                            radius: parent.width / 2// Делаем кнопки круглыми
                        }

                        contentItem: Text
                        {
                            text: baseBtnRect.modelData
                            font.family:openSansSemibold.name
                            font.pixelSize: 24
                            color: (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" ||
                                    baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" || baseBtnRect.modelData == "()" ||
                                    baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#FFFFFF" : "#024873" // Цвет текста
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            anchors.fill: parent // Заполняем родителя и центрируем текст
                        }

                        //Обработка состояний кнопки (наведение, нажатие)
                        MouseArea {
                            id: mouseArea
                            acceptedButtons: Qt.LeftButton
                            anchors.fill: parent
                            onPressed: {
                                if(baseBtnRect.modelData==="=")
                                {
                                timer.start();
                                }
                                // Меняем цвет при нажатии
                                bb.color = (baseBtnRect.modelData == "C") ? "#F47E7E" :
                                                                            (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                                                             baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#F7E425" : "#04BFAD"
                            // Обработка ввода цифр
                                if (baseBtnRect.modelData.match(/^\d$/))
                                {
                                    main.secretCode+=baseBtnRect.modelData;// Добавляем цифру к коду
                                    if(main.secretCode.length>3)
                                    {
                                        main.secretCode = ""; // Сбрасываем код если слишком длинный
                                    }
                                    else if(main.secretCode==="123")
                                    {
                                    main.secretMenuOpened=true; // Открываем секретное меню, если введен правильный код
                                    main.secretCode = ""; // Сбрасываем код после открытия меню
                                    }
                                }
                            }
                            onReleased: {
                            // Останавливаем таймер при отпускании кнопки "="
                            timer.stop();

                            // Возвращаем исходный цвет
                            bb.color = (baseBtnRect.modelData == "C") ? "#F25E5E" :
                                                                            (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                                                             baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#0889A6" :
                                                                                                                                                                              "#B0D1D8"
                            }
                            onEntered: {
                                // Изменяем цвет при наведении
                                bb.color = (baseBtnRect.modelData == "C") ? "#F47E7E" :
                                                                            (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                                                             baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#F7E425" :
                                                                                                                                                                              "#04BFAD"
                            }
                            onExited: {
                                // Возвращаем исходный цвет при уходе курсора
                                bb.color = (baseBtnRect.modelData == "C") ? "#F25E5E" :
                                                                            (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                                                             baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#0889A6" :
                                                                                                                                                                              "#B0D1D8"
                            }
                            onCanceled: {
                            timer.stop(); // Остановить таймер, если нажатие прервано
                            // Возвращаем исходный цвет
                            bb.color = (baseBtnRect.modelData == "C") ? "#F25E5E" :
                                        (baseBtnRect.modelData == "=" || baseBtnRect.modelData == "÷" || baseBtnRect.modelData == "×" || baseBtnRect.modelData == "-" || baseBtnRect.modelData == "+" ||
                                         baseBtnRect.modelData == "()" || baseBtnRect.modelData == "+/-" || baseBtnRect.modelData == "%") ? "#0889A6" :
                                        "#B0D1D8";
                                }
                            onClicked: {
                                // Обработка нажатий на кнопки
                                if (baseBtnRect.modelData === "=") {
                                    // Выполнение вычисления
                                    if (main.operator !== "" && main.secondNumber !== 0) { // Проверяем, есть ли оператор и второе число
                                        var result = Calculator.calculate(main.firstNumber, main.secondNumber, main.operator);
                                        resultDisplay.text = result !== null ? result.toString() : "Error";
                                        // Сбрасываем значения для следующего вычисления
                                        main.firstNumber = result; // Устанавливаем первый номер в результат для цепочки операций
                                        main.secondNumber = 0;
                                        main.operator = "";
                                        firstDisplay.text = ""; // Сбрасываем дисплей
                                    } else {
                                        resultDisplay.text = "Error"; // Если что-то не так, выводим ошибку
                                    }
                                } else if (baseBtnRect.modelData === "C") {
                                    // Очистка экрана
                                    firstDisplay.text = "";
                                    main.firstNumber = 0;
                                    main.secondNumber = 0;
                                    main.operator = "";
                                    resultDisplay.text = "0";
                                } else {
                                    // Проверка, если это цифра
                                    if (baseBtnRect.modelData.match(/^\d$/)) {
                                        if (operator === "") {
                                            // Если оператор еще не выбран, добавляем цифру к первому числу
                                            firstDisplay.text += baseBtnRect.modelData;
                                            main.firstNumber = parseFloat(firstDisplay.text);
                                        } else {
                                            // Если оператор уже выбран, добавляем цифру ко второму числу
                                            if (firstDisplay.text.includes(" ")) {
                                                // Если в тексте есть пробелы (то есть оператор уже установлен), очищаем его перед вводом второго числа
                                                var parts = firstDisplay.text.split(" ");
                                                if (parts.length === 3) {
                                                    // Обновляем второе число
                                                    parts[2] = parts[2] + baseBtnRect.modelData; // Добавляем к текущему второму числу
                                                    firstDisplay.text = parts.join(" ");
                                                }
                                            } else {
                                                // Просто добавляем цифру к текущему вводу
                                                firstDisplay.text += baseBtnRect.modelData;
                                            }
                                            // Парсим второе число из текста
                                            var parts = firstDisplay.text.split(" ");
                                            if (parts.length === 3) { // Ожидаем формата "число оператор число"
                                                main.secondNumber = parseFloat(parts[2]);
                                            }
                                        }
                                    } else if (["+", "-", "×", "÷"].includes(baseBtnRect.modelData)) {
                                        // Устанавливаем оператор
                                        if (firstNumber !== 0) {
                                            operator = baseBtnRect.modelData; // Устанавливаем оператор
                                            firstDisplay.text += " " + operator + " "; // Отображение оператора на экране
                                            main.secondNumber = 0; // Сбрасываем второе число, чтобы готовиться к вводу
                                        }
                                    }
                                }
                            }


                        }
                    }
                }
            }
        }
    }
}
