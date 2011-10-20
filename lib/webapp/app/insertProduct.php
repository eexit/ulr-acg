<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Insérer un produit</title>
    </head>
    <body>
        <h1>Insérer un produit :</h1><br>
<?php
try
{
    $pdo_options[PDO::ATTR_ERRMODE] = PDO::ERRMODE_EXCEPTION;
    $bdd = new PDO('mysql:host=localhost;dbname=projet_hd', 'root', 'root', $pdo_options);
    
    $req = $bdd->prepare('INSERT INTO product(name, price, quantity) VALUES(:name, :price, :quantity)');
    $req->execute(array(
	'name' => $_POST['name'],
	'price' => $_POST['price'],
        'quantity' => $_POST['quantity']
	));

    echo 'Le produit a bien été ajouté';
}
catch(Exception $e)
{
    die('Erreur : '.$e->getMessage());
}
?>
    </body>
</html>
