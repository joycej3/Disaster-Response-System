import unittest
from unittest.mock import MagicMock, patch, Mock
from create_reports import create_reports


class TestRegister(unittest.TestCase):
    def setUp(self):
        mocked_db = "something"
        self.report_creator = create_reports.ReportCreator(mocked_db, 10, 0, 1, (53.32, -6.25), .05, .05)
        self.report_categories = ["Injured", "ReportCategory", "Time", "Lat", "Lon"]
        
    def test_generate_report(self):
        report = self.report_creator.generate_report()
        for report_category in self.report_categories:
            self.assertIn(report_category, report.keys())
            self.assertEqual(type(report[report_category]), str)

    def test_generate_noisy_report(self):
        report = self.report_creator.generate_noisy_report()
        for report_category in self.report_categories:
            self.assertIn(report_category, report.keys())
            self.assertEqual(type(report[report_category]), str)


if __name__ == "__main__":
    unittest.main()

