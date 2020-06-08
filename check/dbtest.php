<?php

// Create and check MySQLi connection with SSL
// $conn = mysqli_init( );

// mysqli_ssl_set($conn, NULL, NULL, "/etc/my.cnf.d/certificates/BaltimoreCyberTrustRoot.crt.pem", NULL, NULL);
// mysqli_real_connect($conn, getenv('DB_HOST'), getenv('DB_USER'), getenv('DB_PASS'), getenv('DB_NAME'), 3306);

// if ($conn->connect_error) {
//   die("Connection failed: " . $conn->connect_error);
// }
// echo "Connected successfully";

// Check PDO db connection with SSL
try {
    	$options = array(
                \PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                \PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                \PDO::ATTR_EMULATE_PREPARES => false,
                // \PDO::MYSQL_ATTR_SSL_CA => '/etc/my.cnf.d/certificates/BaltimoreCyberTrustRoot.crt.pem',
          		  // \PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
        );
      $dbh = new PDO('mysql:host=mariadb;port=3306;dbname=example', 'user', 'password', $options);
      echo "Connected successfully";
}
catch (PDOException $e) {
     throw new \PDOException($e->getMessage(), (int)$e->getCode());
}

?>