@echo off
dir
if "%~1"=="server" (start /B /wait cmd /c mvnw clean install)
if "%~1"=="server" (start /B /wait cmd /c python ip_discovery.py)
if "%~1"=="server" (start /B cmd /c java -jar target/rest-service-complete-0.0.1-SNAPSHOT.jar) else (echo "not running server")


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