@echo off


cd ../../frontend
dir
start /B /wait cmd /c copy "..\\shared_code\\register\\register.py" "startup_scripts\\register.py"
start /B /wait cmd /c flutter build web
start /B /wait cmd /c docker build -t aswe/frontend .
start /B /wait cmd /c docker run -d -p 80:80 aswe/frontend
start /B cmd /c del startup_scripts\\register.py

 
cd ../backend/Api_Backend
dir
start /B /wait cmd /c copy "..\\..\\shared_code\\register\\register.py" "startup_scripts\\register.py"
start /B /wait cmd /c mvnw clean install 
start /B /wait cmd /c docker build -t aswe/backend .
start /B /wait cmd /c docker run -d -p 8081:8080 aswe/backend
start /B cmd /c del startup_scripts\\register.py
