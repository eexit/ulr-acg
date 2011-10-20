<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <style type="text/css">
            table
            {
                border-collapse: collapse;
            }
            td, th
            {
                border: 1px solid black;
                text-align: center;
                padding: 5px;
            }
        </style>
    </head>
    <body>
<?php
try
{
    $pdo_options[PDO::ATTR_ERRMODE] = PDO::ERRMODE_EXCEPTION;
    $bdd = new PDO('mysql:host=localhost;dbname=projet_hd', 'root', 'root', $pdo_options);
    
    $response = $bdd->query('SELECT * FROM product');
    
    ?>
        <table>
            <caption>Contenu du stock</caption>
            <tr>
                <th>Id</th>
                <th>Nom</th>
                <th>Prix</th>
                <th>Quantite</th>
            </tr>
    <?php
    while ($data = $response->fetch())
    {
    ?>
            <tr>
                <td><?php echo $data['id']; ?></td>
                <td><?php echo $data['name']; ?></td>
                <td><?php echo $data['price']; ?></td>
                <td><?php echo $data['quantity']; ?></td>
            </tr>
    <?php
    }
    ?>
        </table>
    <?php
    $reponse->closeCursor();

}
catch(Exception $e)
{
    die('Erreur : '.$e->getMessage());
}


?>
    </body>
</html>