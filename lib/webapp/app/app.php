<?php
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use Zend\Ldap\Ldap;
use Zend\Ldap\Attribute;
use Zend\Ldap\Exception as ZLdapException;

// Bootstraping
require_once __DIR__ . '/../vendor/silex/silex.phar';
$app = new Silex\Application();

// Registers Twig extension
$app->register(new Silex\Provider\TwigServiceProvider(), array(
   'twig.class_path'    => __DIR__ . '/../vendor/Twig/lib',
   'twig.path'          => __DIR__ . '/views',
   'twig.options'       => array('strict_variables' => false)
));

$app['autoloader']->registerNamespace('Zend', __DIR__ . '/../vendor/zend/library');

$app['ldap'] = $app->share(function() {
    try {
        $ldap = new Ldap(array(
            'host'              => 'ldap.g1b5.tp.org',
            'username'          => 'cn=manager,dc=g1b5,dc=tp,dc=org',
            'password'          => 'iamldapadmin',
            'bindRequiresDn'    => true,
            'accountDomainName' => 'g1b5.tp.org',
            'baseDn'            => 'ou=employee,dc=g1b5,dc=tp,dc=org',
        ));
        return $ldap->bind();
    } catch (ZLdapException $e) {
        var_dump($e->getMessage());
    }
});

$app['mysql'] = $app->share(function() {
   try {
       $pdo_options[\PDO::ATTR_ERRMODE] = \PDO::ERRMODE_EXCEPTION;
       return new \PDO('mysqli:host=localhost;dbname=projet_hd', 'root', 'root', $pdo_options);       
   } catch (\PDOException $e) {
       var_dump($e->getMessage());
   }
});

// Application error handling
$app->error(function(\Exception $e) use ($app) {
    if ($e instanceof NotFoundHttpException) {
        $content = sprintf('<h1>%d - %s (%s)</h1>',
            $e->getStatusCode(),
            Response::$statusTexts[$e->getStatusCode()],
            $app['request']->getRequestUri()
        );
        return new Response($content, $e->getStatusCode());
    }
    
    if ($e instanceof HttpException) {
        return new Response('<h1>Oops!</h1><h2>Something went wrong...</h2><p>You should go eat some cookies while we\'re fixing this feature!</p>', $e->getStatusCode());
    }
});

$app->get('/', function(Silex\Application $app) {
    return $app['twig']->render('index.twig', array(
        'home'      => true,
        'remote_ip' => $app['request']->getClientIp(),
        'local_ip'  => $app['request']->getHost()
    ));
});

$app->get('/ldap.html', function(Silex\Application $app) {
    //$results = $app['ldap']->search('(objectclass=*)', 'ou=employee,dc=g1b5,dc=tp,dc=org', Zend_Ldap_Ext::SEARCH_SCOPE_ONE);
    $results = array(
        array(
            'dn'    => 'cn=Berthelot,ou=employee,dc=g1b5,dc=tp,dc=org',
            'cn'    => array('Berthelot')
        ),
        array(
            'dn'    => 'cn=Berthelot,ou=employee,dc=g1b5,dc=tp,dc=org',
            'cn'    => array('Berthelot')
        ),
        array(
            'dn'    => 'cn=Berthelot,ou=employee,dc=g1b5,dc=tp,dc=org',
            'cn'    => array('Berthelot')
        )
    );
    return $app['twig']->render('ldap.twig', array(
        'dir'       => true,
        'entries'   => $results
    ));    
});

$app->post('/ldap.html', function(Silex\Application $app) {
    $name = $app->escape($app['request']->get('name'));
    $entry = array();
    Attribute::setAttribute($entry, 'cn', $name);
    Attribute::setAttribute($entry, 'sn', $name);
    Attribute::setAttribute($entry, 'objectClass', 'inetOrgPerson');
    $app['ldap']->add('cn=' . $name . 'ou=employee,dc=g1b5,dc=tp,dc=org', $entry);
    $app->redirect('/ldap.html');
});

$app->get('/mysql.html', function(Silex\Application $app) {
    //$response = $app['mysql']->query('SELECT * FROM `product`')->fetchAll(\PDO::FETCH_ASSOC);
    return $app['twig']->render('mysql.twig', array(
        'db'        => true,
        'entries'   => $response
    ));
});

$app->post('/mysql.html', function(Silex\Application $app) {
    $req = $app['mysql']->prepare('INSERT INTO product(name, price, quantity) VALUES(:name, :price, :quantity)');
    $req->execute(array(
	    'name'      => $app->escape($app['request']->get('name')),
	    'price'     => $app->escape($app['request']->get('price')),
	    'quantity'  => $app->escape($app['request']->get('qte'))
	));
	$app->redirect('/mysql.html');
});

return $app;
?>