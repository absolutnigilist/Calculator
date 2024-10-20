// calculator.js
function add(a, b) {
    return a + b;
}

function subtract(a, b) {
    return a - b;
}

function multiply(a, b) {
    return a * b;
}

function divide(a, b) {
    if (b === 0) {
        console.error("Cannot divide by zero");
        return null;
    }
    return a / b;
}

function calculate(firstNumber, secondNumber, operator) {
    switch (operator) {
        case "+":
            return firstNumber + secondNumber;
        case "-":
            return firstNumber - secondNumber;
        case "×":
            return firstNumber * secondNumber;
        case "÷":
            return secondNumber !== 0 ? firstNumber / secondNumber : null; // Проверка на деление на 0
        default:
            return null; // Если оператор не распознан
    }
}
