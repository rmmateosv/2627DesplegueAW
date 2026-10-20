<?php
if(isset($_POST['cargar'])){
    if(!empty($_FILES['fichero']['name'])){
        //Mover el fichero subido de la ruta temporal a nuestro sitio web
        if(move_uploaded_file($_FILES['fichero']['tmp_name'],
        '../cargados/'.date('Ymdhis').$_FILES['fichero']['name'])){
            $mensaje = 'Fichero cargado';
        }
        else{
            $error = 'Error al cargar el fichero';
        }
    }
    else{
        $error = 'Debes incluir un fichero';
    }
}
?>