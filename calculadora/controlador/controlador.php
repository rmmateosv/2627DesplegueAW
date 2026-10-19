<?php


if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['n1']) or !isset($_POST['n2'])) {
        $resultado = 'Debes rellenar ambos números';
    }
    elseif (!is_numeric($_POST['n1']) or !is_numeric($_POST['n2'])) {
        $resultado = 'Hay valores no numéricos';
    }
    elseif ($_POST['n2'] == 0 and isset($_POST['b/'])) {
        $resultado = 'División por 0';
    }
    elseif (isset($_POST['b+'])) {
        $resultado = $_POST['n1'] + $_POST['n2'];
    }
    elseif (isset($_POST['b-'])) {
        $resultado = $_POST['n1'] - $_POST['n2'];
    }
    elseif (isset($_POST['b*'])) {
        $resultado = $_POST['n1'] * $_POST['n2'];
    }
    elseif (isset($_POST['b/'])) {
        $resultado = $_POST['n1'] / $_POST['n2'];
    }
}

?>
