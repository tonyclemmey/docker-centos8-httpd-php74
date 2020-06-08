<?php

/**
 * Database Configuration
 *
 * After you've created a database, fill in this information so the [[RequirementsChecker]]
 * can connect to the database and determine if it meets the necessary requirements to run Craft.
 */

return array(
	// The database server name or IP address. Usually this is 'localhost' or '127.0.0.1'.
	'server' => getenv('DB_HOST'),

	// The database username to connect with.
	'user' => getenv('DB_USER'),

	// The database password to connect with.
	'password' => getenv('DB_PASS'),

	// The name of the database to connect to.
	'database' => getenv('DB_NAME'),

	// The database driver to use. Either 'mysql' for MySQL or 'pgsql' for PostgreSQL.
	'driver' => 'mysql',
);