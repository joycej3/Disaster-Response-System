import time
import sys
import random
import numpy as np
import pyrebase


class ReportCreator:
    def __init__(self, database, num_reports: int, most_frequent_emergency_type: int, 
                 most_frequent_injury_type: int, epi_centre: tuple, max_distance_std: float, noise_frequency: float):
        self.num_reports = num_reports
        self.most_frequent_emergency_type = most_frequent_emergency_type
        self.most_frequent_injury_type = most_frequent_injury_type
        self.epi_centre = epi_centre
        self.distance_std = max_distance_std / 3
        self.noise_freqency = noise_frequency
        self.lat_bounds = [53.427261, 53.258333]
        self.long_bounds = [-6.453632, -6.082259]
        self.report_categories = [
            "0",
            "1",
            "2",
            "3", 
            "4"
        ]
        self.injury_categories = [
            "true",
            "false"
        ]
        self.database = database;
        

    def run(self):
        for report_number in range(self.num_reports):
            if random.random() < self.noise_freqency:
                report = self.generate_noisy_report()
            else:
                report = self.generate_report()
            self.send_report(report)


    def generate_report(self) -> dict:
        report_dict = dict()
        report_dict["Lat"] = str(np.random.normal(self.epi_centre[0], self.distance_std))
        report_dict["Lon"] = str(np.random.normal(self.epi_centre[1], self.distance_std))
        report_dict["Time"] = str(int(np.random.normal(time.time(), 600)))
        report_dict["Injured"] = str(self.injury_categories[self.most_frequent_injury_type])
        report_dict["ReportCategory"] = str(self.report_categories[self.most_frequent_emergency_type])
        return report_dict

    
    def generate_noisy_report(self) -> dict:
        print("noisy report")
        report_dict = self.generate_report()
        random_val = random.random()
        if random_val < 0.36:
            report_dict["Lat"] = str(random.uniform(self.lat_bounds[0], self.lat_bounds[1]))
            report_dict["Lon"] = str(random.uniform(self.long_bounds[0], self.long_bounds[1]))
        if 0.28 < random_val < 0.7:
            report_dict["ReportCategory"] = str(self.report_categories[random.randint(0, len(self.report_categories) - 1)])
        if 0.63 < random_val or random_val < 0.05:
            report_dict["Injured"] = str(self.injury_categories[random.randint(0, len(self.injury_categories) - 1)])
        return report_dict
        


    def send_report(self, report: dict):
        self.database.child("ReportTable/Categorised/Ongoing/1/Reports").push(report)


def main(num_reports, most_frequent_emergency_type, most_frequent_injury_type, epi_centre, max_distance_std, noise_frequency):
    firebase_config = {
    "apiKey": "AIzaSyAc8id5P7Ragb9RTYdc56dV3JC3R6gA0tQ",
    "authDomain": "group-9-c4e02.firebaseapp.com",
    "databaseURL": "https://group-9-c4e02-default-rtdb.europe-west1.firebasedatabase.app",
    "storageBucket": "group-9-c4e02.appspot.com",
    "serviceAccount": "private_key.json"
    }

    firebase = pyrebase.initialize_app(firebase_config)
    database = firebase.database()
    report_creator = ReportCreator(database, num_reports, most_frequent_emergency_type, most_frequent_injury_type, 
                                     epi_centre, max_distance_std, noise_frequency)
    report_creator.run()

    
if __name__ == "__main__":
    try:
        num_reports = int(sys.argv[1])
        most_frequent_emergency_type = int(sys.argv[2])
        most_frequent_injury_type = int(sys.argv[3])
        epi_centre = (float(sys.argv[4]), float(sys.argv[5]))
        max_distance = float(sys.argv[6])
        noise_frequency = float(sys.argv[7])
    except:
        print("Expected argumets in format "
              "num_reports(int) most_frequent_emergency_type(int) "
              "most_frequent_injury_type(int) "
              "centre_lat(float) centre_long(float) "
              "max_distance(float) "
              "noise_frequency(float)")
        raise SystemExit()
    if max_distance > 0.1:
        print("WARN: This will likely generate reports outside Dublin")

    main(num_reports, most_frequent_emergency_type, most_frequent_injury_type, epi_centre, max_distance, noise_frequency)
