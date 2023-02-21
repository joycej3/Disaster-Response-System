@echo off
start /B /wait cmd /c mvn clean install
start /B /wait cmd /c docker build -t aswe/load .
start /B /wait cmd /c docker run -d -p 8080:8080 aswe/load

cd ../../frontend
start /B /wait cmd /c flutter build web
start /B /wait cmd /c docker build -t aswe/frontend
start /B /wait cmd /c docker run -d -p 80:80  aswe/frontend
 

cd ../backend/Api_Backend
start /B /wait cmd /c mvn clean install 
start /B /wait cmd /c docker build -t aswe/backend . 
start /B /wait cmd /c docker run -d -p 8081:8080 aswe/backend
