FROM centos
MAINTAINER pgalczynski
RUN yum -y update
RUN yum -y install httpd
ADD index.html /var/www/html/index.html

CMD ["httpd", "-DFOREGROUND"]
