import socket
from google.oauth2 import service_account
from google.auth.transport.requests import AuthorizedSession
import json
import requests

def main():
    hostname = socket.gethostname()
    ip = socket.gethostbyname(hostname)
    
    # Define the required scopes
    scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database"
    ]
    
    # Authenticate a credential with the service account
    credentials = service_account.Credentials.from_service_account_file(
        "/etc/private_key.json", scopes=scopes)
    
    # Use the credentials object to authenticate a Requests session.
    authed_session = AuthorizedSession(credentials)
    response = authed_session.get(
        "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ip/.json")
    
    ip = json.loads(response.text)["ip"]
    print(f"got ip: {ip}")
    register_response = requests.post(f"http://{ip}:8080/register", json = {"type": "frontend"})

    
if __name__ == "__main__":
    main()