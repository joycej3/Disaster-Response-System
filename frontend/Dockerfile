FROM ubuntu 
RUN apt-get update \
&& apt-get install -y python3 \
&& apt-get install -y python3-pip \
&& apt-get install -y apache2 \
&& apt-get install -y apache2-utils
RUN pip3 install google-auth
RUN pip3 install requests
RUN apt-get clean
COPY build/web/ /var/www/html/
COPY startup_scripts/private_key.json /etc/
COPY startup_scripts/register.py /home/
COPY startup_scripts/startup.sh /home/
CMD ["/home/startup.sh"]