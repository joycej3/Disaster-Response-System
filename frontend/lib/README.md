
in order to check the frontend and backend are working properly follow these steps:

1. 
make sure the backend is set up properly according to the README.md in the backend directory
in one terminal window, change directory to backend\Api_backend\
run:    ./mvnw spring-boot:run

2. 
in a separate terminal window, change directory to \backend\Load_Balancer
run:    python .\ip_discovery.py

3. 
then in another separate terminal window, change directory to \frontend\
run: flutter run -d edge  --web-browser-flag "--disable-web-security"








