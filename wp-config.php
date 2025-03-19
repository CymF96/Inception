<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/**Debugging test for env */
/**echo 'DATABASE: ' . getenv('DATABASE'); */
/**echo 'DB_ADMIN_ID: ' . getenv('DB_ADMIN_ID'); */
/** The name of the database for WordPress */
define('DB_NAME', getenv('DATABASE'));

/** Database username */
define('DB_USER', getenv('DB_ADMIN_ID'));

/** Database password */
define('DB_PASSWORD', getenv('DB_ADMIN_PWD'));

/** Database hostname */
define( 'DB_HOST', getenv('DB_HOST'));

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '|-B_+----GE&LtNwKB#s_|1Y^|~-|0tjr|`E&f0XRM q*,YSrk5g));H9r|Wb&G<');
define('SECURE_AUTH_KEY',  'EPw6St/=YK)Ln#bO ;kWjjeZv/pqtIQdrB5Fk;Q^-`*nd]4g}Zfbt?cX)D~l%bFf');
define('LOGGED_IN_KEY',    'zd;.tuljvKr[x!vs74u0#+Z=ct|8&=8Yw$dlZ-V<Ad4|L K0o9i/]wifE~$[OOJu');
define('NONCE_KEY',        '+|8c2F#`%hq*QJm^tNJ-]z<>myV,mR*4,35F~uWgsAp;$BMq+Tq-N^F&2pBUWw&g');
define('AUTH_SALT',        '[0BG{uD98{:&at~.(>H8:8u&UpKT! TH6SU4G5jTA|H9-9g?dz4)M] `T-([)oA6');
define('SECURE_AUTH_SALT', '0rU*bucV,MPg)2O0tZr%$_7 n+g${%pFAN=IefVEnRGos>Z)/{W>V@zwm3o2^f+&');
define('LOGGED_IN_SALT',   'cUB$,_q$8UL]gDV(]3b! upu#k1j0mf`}F]:a4BM5osS#v9%4D+Ld8RJnu9{-r|z');
define('NONCE_SALT',       'Exc,/a+-@yH/M|K()>[P7Ah^*7PVe@>^-~-[Nf[mW4FZ{nk:(MNY0~4Dm!tI#YRb');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
