FROM ubuntu 
RUN apt-get update 
RUN apt-get -y install apache2
RUN apt-get -y install apache2-utils
RUN apt-get clean
COPY build/web/ /var/www/html/
CMD ["apache2ctl", "-D", "FOREGROUND"]