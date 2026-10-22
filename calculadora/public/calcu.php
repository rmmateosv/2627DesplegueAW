<?php
require_once '../controlador/controlador.php'

?> 
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <form action="" method="post">
        <div>
            <label for="n1">Número 1</label><br/>
            <input type="number" name="n1" id="n1" value="<?php echo (isset($_POST['n1'])?$_POST['n1']:'') ?>"/>
        </div>
        <div>
            <label for="n1">Número 2</label><br/>
            <input type="number" name="n2" id="n2" value="<?php echo (isset($_POST['n2'])?$_POST['n2']:'') ?>"/>
        </div>
        <div>
            <label for="resultado">Resultado</label><br/>
            <input type="text" name="resultado" id="resultado" value="<?php echo (isset($resultado)?$resultado:''); ?>"/>
        </div>
        <div>
            <button type="submit" name="b+">+</button>
            <button type="submit" name="b-">-</button>
            <button type="submit" name="b*">*</button>
            <button type="submit" name="b/">/</button>
        </div>
        
    </form>
</body>
</html>