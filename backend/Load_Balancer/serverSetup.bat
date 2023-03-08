@echo off


cd ../../frontend
dir
start /B /wait cmd /c flutter build web
start /B /wait cmd /c docker build -t aswe/frontend .
start /B /wait cmd /c docker run -d -p 80:80 aswe/frontend


 
cd ../backend/Api_Backend
dir
start /B /wait cmd /c mvnw clean install 
start /B /wait cmd /c docker build -t aswe/backend .
start /B /wait cmd /c docker run -d -p 8081:8080 aswe/backend
