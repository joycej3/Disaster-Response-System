!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!This is for backend files running the backend pipeline !
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Must install Java 19 (jdk-19)
link: https://www.oracle.com/ie/java/technologies/downloads/

Ensure JAVA_HOME environment variable is    set correctly

On windows change environemnt variable to:
Variable Name: JAVA_HOME
Variable Path: C:\Program Files\Java\jdk-19

On windows change environemnt variable to:
Variable Name: JAVA_HOME
Variable Path: C:\Program Files\Java\jdk-19

Ensure Python3 is installed

Install requirements.txt:
`pip install -r requirements.txt`

! You need to this every time you want start the server
You must have docker desktop installed and running.

start docker microservers by having docker installed and clicking on the serverSetupWithLoad.bat in the Load_balancer folder. This will take some time.

Once you see the text "registered backend: xxx.xxx.xx.x" and the same for frontend,

If you want to add more servers to the swarm for load balancing you can click the serverSetup.bat on any another computer on the same local network.

You can then try using the app from the frontend

Note: This will start up a frontend server as well.
This can be accessed through the load balancer at `http://localhost:8080`.
This will sucessfully serve the UI.
However, as this is a http implementation, most web browsers disable location based data.
This means that the map functionality will not work in most cases (sometimes location is required on load and the map will not show, sometimes it is only used on button press, so the buttons will not function).
The full frontend expereince can be had by following `frontend/README.md`.