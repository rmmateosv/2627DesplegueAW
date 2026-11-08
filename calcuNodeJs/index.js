
const express = require('express');
const app = express();

app.use(express.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    mostrarCalculadora(res);
});

app.post('/calcular', (req, res) => {
    const num1 = Number(req.body.num1);
    const num2 = Number(req.body.num2);
    const operacion = req.body.operacion;

    let resultado;
    let error = '';

    if (
        req.body.num1 === '' ||
        req.body.num2 === '' ||
        !Number.isFinite(num1) ||
        !Number.isFinite(num2)
    ) {
        error = 'Introduce dos números válidos';
    } else {
        switch (operacion) {
            case 'sumar':
                resultado = num1 + num2;
                break;

            case 'restar':
                resultado = num1 - num2;
                break;

            case 'multiplicar':
                resultado = num1 * num2;
                break;

            case 'dividir':
                if (num2 === 0) {
                    error = 'No se puede dividir entre cero';
                } else {
                    resultado = num1 / num2;
                }
                break;

            default:
                error = 'Operación no válida';
        }
    }

    mostrarCalculadora(res, resultado, error);
});

function mostrarCalculadora(res, resultado = null, error = '') {

    res.send(`
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Calculadora Node.js</title>

        <style>
            body {
                font-family: Arial;
                background: #eef2f7;
                text-align: center;
                padding-top: 60px;
            }

            .calculadora {
                background: white;
                padding: 30px;
                width: 320px;
                margin: auto;
                border-radius: 12px;
                box-shadow: 0 3px 12px #bbb;
            }

            input, select, button {
                width: 100%;
                padding: 10px;
                margin: 8px 0;
                box-sizing: border-box;
            }

            button {
                background: #2563eb;
                color: white;
                border: none;
                cursor: pointer;
            }

            .resultado {
                color: green;
                font-weight: bold;
            }

            .error {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>

    <body>

        <div class="calculadora">

            <h1>Calculadora Node.js</h1>

            <form method="POST" action="/calcular">

                <input type="number" step="any"
                       name="num1"
                       placeholder="Primer número"
                       required>

                <select name="operacion">
                    <option value="sumar">Sumar (+)</option>
                    <option value="restar">Restar (-)</option>
                    <option value="multiplicar">Multiplicar (*)</option>
                    <option value="dividir">Dividir (/)</option>
                </select>

                <input type="number" step="any"
                       name="num2"
                       placeholder="Segundo número"
                       required>

                <button type="submit">Calcular</button>

            </form>

            ${resultado !== null
                ? `<p class="resultado">Resultado: ${resultado}</p>`
                : ''}

            ${error
                ? `<p class="error">${error}</p>`
                : ''}

        </div>

    </body>
    </html>
    `);
}

app.listen(3000, '0.0.0.0', () => {
    console.log('Calculadora funcionando en el puerto 3000');
});
