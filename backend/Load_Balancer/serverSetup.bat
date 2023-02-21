@echo off
dir
start /B /wait cmd /c mvnw clean install

cd ../../frontend
dir
start /B /wait cmd /c flutter build web
 
cd ../backend/Api_Backend
dir
start /B /wait cmd /c mvnw clean install 
cd ../Load_Balancer
start /B /wait cmd /c docker-compose up --build
