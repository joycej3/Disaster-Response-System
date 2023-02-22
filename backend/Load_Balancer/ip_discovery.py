import socket
from google.oauth2 import service_account
from google.auth.transport.requests import AuthorizedSession
import json

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
        "src/main/resources/firebase_service_account/private_key.json", scopes=scopes)
    
    data = {'ip': ip}
    data_json = json.dumps(data)
    
    # Use the credentials object to authenticate a Requests session.
    authed_session = AuthorizedSession(credentials)
    response = authed_session.post(
        "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/test.json", data_json)
    
    print(response.text)
    
if __name__ == "__main__":
    main()