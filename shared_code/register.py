import socket
from google.oauth2 import service_account
from google.auth.transport.requests import AuthorizedSession
import json
import requests
from time import sleep
import sys


class LoadBalManager:
    def __init__(self, server_type):
        scopes = [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/firebase.database"
        ]
        
        credentials = service_account.Credentials.from_service_account_file(
            "/etc/private_key.json", scopes=scopes)
        
        self.authed_session = AuthorizedSession(credentials)
        self.ip = ""
        self.failed_heartbeat_count = 0
        self.failed_heartbeat_limit = 5
        self.heartbeat_delay = 1
        self.server_type = server_type
        

    def run(self):
        while True:
            if self.ip:
                sleep(self.heartbeat_delay)
                self.heartbeat()
            else:
                self.get_ip_firebase()
                self.register()
            print("in python main loop")

    def get_ip_firebase(self):
        response = self.authed_session.get(
        "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app/ip/.json")

        if response.ok:
            self.ip = json.loads(response.text)["ip"]
            print(f"got ip: {self.ip}")
        else:
            self.ip = ""
            print("Failed to get ip from database")
            sleep(5)
            self.get_firebase_ip()


    def register(self):
        try:
            register_response = requests.post(f"http://{self.ip}:8080/register", json = {"type": self.server_type}, timeout=5)
            print(f"registered with load bal ip: {self.ip}")
            if not register_response.ok:
                self.ip = ""
                sleep(5)
        except requests.exceptions.ConnectionError:
            print("register connection error")
            self.ip = ""
            sleep(5)
        except requests.exceptions.Timeout:
            print("register timed out")
            self.ip = ""


    def heartbeat(self):
        try:
            register_response = requests.get(f"http://{self.ip}:8080/heartbeat", timeout=5)
            if register_response.ok:
                self.failed_heartbeat_count = 0
            else:
                self.failed_heartbeat_count += 1
                if self.failed_heartbeat_count > self.failed_heartbeat_limit:
                    self.ip = ""
        except requests.exceptions.ConnectionError:
            print("heartbeat connection error")
            self.failed_heartbeat_count += 1
            if self.failed_heartbeat_count > self.failed_heartbeat_limit:
                self.ip = ""
        except requests.exceptions.Timeout:
            print("heartbeat timed out")
            self.failed_heartbeat_count += 1
            if self.failed_heartbeat_count > self.failed_heartbeat_limit:
                self.ip = ""


def main(args):
    if  len(args) != 2:
        print("Pass server type as argument")
        raise SystemError
    server_type = args[1]
    load_bal_manager = LoadBalManager(server_type)
    load_bal_manager.run()

    
if __name__ == "__main__":
    main(sys.argv)
