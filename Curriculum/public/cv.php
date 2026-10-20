<?php
require_once '../controlador/controlador.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h1>CARGA DE CURRÍCULUMS</h1>
    <form action="" method="post" enctype="multipart/form-data">
        <input type="text" name="nombre" placeholder="Introduce nombre">
        Fichero <input type="file" name="fichero">
        <button type="submit" name="cargar">Cargar</button>
    </form>
    <?php 
    if(isset($mensaje)){
        echo '<h3 style="color:green">'.$mensaje.'</h3>';
    }
    if(isset($error)){
        echo '<h3 style="color:red">'.$error.'</h3>';
    }
     ?>
</body>
</html>