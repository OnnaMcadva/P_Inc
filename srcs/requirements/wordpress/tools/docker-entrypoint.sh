# Скрипт настраивает WordPress в контейнере: 
# ждёт базу данных, скачивает и 
# устанавливает WordPress, создаёт `wp-config.php`, 
# добавляет пользователей, задаёт права и запускает PHP-FPM.

DATADIR='/var/www/html'
DBHOST='db:3306'

install_wordpress() {
    if [ ! -f "$DATADIR/wp-config.php" ]; then
        until mysqladmin ping -hdb --silent
        do
            echo "DB still not available, waiting.."
            sleep 5
        done

        echo "Installing Wordpress..."

        wp core download --path=$DATADIR

        echo "Generating wp config..."
        wp-cli.phar --path=$DATADIR config create --dbname="$WORDPRESS_DB_NAME" --dbuser="$WORDPRESS_DB_USER" --dbpass="$WORDPRESS_DB_PASSWORD" --dbhost="$DBHOST" --dbprefix="$WORDPRESS_TABLE_PREFIX"
        echo "Running core install / creating users..."
        wp --path=$DATADIR core install --url="$DOMAIN_NAME" --title="$WORDPRESS_SITE_TITLE" --admin_user="$WORDPRESS_ADMIN_USER" --admin_password="$WORDPRESS_ADMIN_PASSWORD" --admin_email="$WORDPRESS_ADMIN_EMAIL"
        wp --path=$DATADIR user create "$WORDPRESS_USER" "$WORDPRESS_EMAIL" --role='editor' --user_pass="$WORDPRESS_PASSWORD"

    else
        echo "Wordpress is already installed, nothing to do"
    fi
    # 755 ???
    chmod -R 777 $DATADIR
    echo "Starting PHP-FPM..."
    exec "$@"
}

if [ "$1" = 'php-fpm' ]; then
    install_wordpress $@
else
    exec "$@"
fi
