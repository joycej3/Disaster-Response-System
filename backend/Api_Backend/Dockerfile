FROM eclipse-temurin:17-jdk-alpine 
RUN apk update \
&& apk add python3 \
&& apk add py3-pip 
RUN pip3 install google-auth
RUN pip3 install requests
VOLUME /tmp 
COPY target/rest-service-complete-0.0.1-SNAPSHOT.jar target/app.jar 
COPY startup_scripts/private_key.json etc/
COPY startup_scripts/register.py home/
COPY startup_scripts/startup.sh home/
CMD ["sh", "home/startup.sh"]
