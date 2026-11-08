
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String resultado = "";
    String error = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            double num1 = Double.parseDouble(request.getParameter("num1"));
            double num2 = Double.parseDouble(request.getParameter("num2"));
            String operacion = request.getParameter("operacion");

            switch (operacion) {
                case "sumar":
                    resultado = String.valueOf(num1 + num2);
                    break;
                case "restar":
                    resultado = String.valueOf(num1 - num2);
                    break;
                case "multiplicar":
                    resultado = String.valueOf(num1 * num2);
                    break;
                case "dividir":
                    if (num2 == 0) {
                        error = "No se puede dividir entre cero";
                    } else {
                        resultado = String.valueOf(num1 / num2);
                    }
                    break;
                default:
                    error = "Operación no válida";
            }
        } catch (Exception e) {
            error = "Introduce dos números válidos";
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Calculadora JSP</title>
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
    <h1>Calculadora JSP</h1>

    <form method="POST">
        <input type="number" step="any" name="num1"
               placeholder="Primer número" required>

        <select name="operacion">
            <option value="sumar">Sumar (+)</option>
            <option value="restar">Restar (-)</option>
            <option value="multiplicar">Multiplicar (*)</option>
            <option value="dividir">Dividir (/)</option>
        </select>

        <input type="number" step="any" name="num2"
               placeholder="Segundo número" required>

        <button type="submit">Calcular</button>
    </form>

    <% if (!resultado.isEmpty()) { %>
        <p class="resultado">Resultado: <%= resultado %></p>
    <% } %>

    <% if (!error.isEmpty()) { %>
        <p class="error"><%= error %></p>
    <% } %>
</div>

</body>
</html>
