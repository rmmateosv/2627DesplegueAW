
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h2>ALUMNOS</h2>
    <ul>
        <li><a href="index.php?alumno=1&nombre=Luis">Luis</a></li>
        <li><a href="index.php?alumno=2&nombre=Ana">Ana</a></li>
        <li><a href="index.php?alumno=3&nombre=María">María</a></li>
    </ul>

    <?php 
    if(isset($_GET['alumno'])){
        echo '<h1>Alumno: '.$_GET['alumno'].'</h1>';
    }
    if(isset($_GET['nombre'])){
        echo '<h1>Nombre: '.$_GET['nombre'].'</h1>';
    }
     ?>
</body>
</html>