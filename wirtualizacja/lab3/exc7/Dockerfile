FROM nimmis/apache-php5
COPY default.conf /etc/apache2/sites-available/000-default.conf
RUN  mkdir -p /var/www/flarum/; chmod -R 777 /var/www/; cd /var/www/flarum; composer create-project flarum/flarum . --stability=beta
RUN chmod -R 0775 /var/www/
EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
