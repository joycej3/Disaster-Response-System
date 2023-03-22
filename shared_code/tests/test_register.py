import unittest
from unittest.mock import MagicMock, patch, Mock
from register import register
from google.auth.transport.requests import AuthorizedSession


class TestRegister(unittest.TestCase):
    def setUp(self):
        self.mocked_authed_session = AuthorizedSession(None)
        self.load_bal_manager = register.LoadBalManager(server_type="frontend", authed_session=self.mocked_authed_session)

    @patch('requests.post')
    def test_register_no_ip(self, mocked_requests_post):
        mocked_requests_post.return_value = MagicMock(ok=True, text="failed")
        self.load_bal_manager.ip = "ip"
        self.load_bal_manager.register()
        self.assertEqual(self.load_bal_manager.ip, "")

    @patch('requests.post')
    def test_register_with_ip(self, mocked_requests_post):
        mocked_requests_post.return_value = MagicMock(ok=True, text="success")
        self.load_bal_manager.ip = "ip"
        self.load_bal_manager.register()
        self.assertEqual(self.load_bal_manager.ip, "ip")

    @patch('requests.get')
    def test_heartbeat_success(self, mocked_requests_get):
        mocked_requests_get.return_value = MagicMock(ok=True, text="success")
        self.load_bal_manager.ip = "ip"
        self.load_bal_manager.heartbeat()
        self.assertEqual(self.load_bal_manager.ip, "ip")

    @patch('requests.get')
    def test_heartbeat_failed_once(self, mocked_requests_get):
        mocked_requests_get.return_value = MagicMock(ok=False)
        self.load_bal_manager.ip = "ip"
        self.load_bal_manager.heartbeat()
        self.assertEqual(self.load_bal_manager.ip, "ip")
        self.assertEqual(self.load_bal_manager.failed_heartbeat_count, 1)

    @patch('requests.get')
    def test_heartbeat_failed_more_than_threshold(self, mocked_requests_get):
        mocked_requests_get.return_value = MagicMock(ok=False)
        self.load_bal_manager.ip = "ip"
        for i in range(self.load_bal_manager.failed_heartbeat_limit + 1):
            self.load_bal_manager.heartbeat()
        self.assertEqual(self.load_bal_manager.ip, "")
        self.assertEqual(self.load_bal_manager.failed_heartbeat_count, self.load_bal_manager.failed_heartbeat_limit + 1)
    
    @patch('google.auth.transport.requests.AuthorizedSession.get')
    def test_get_ip_good_response(self, mocked_auth_session_get):
        mocked_auth_session_get.return_value = MagicMock(ok=True, text='{"ip":"val","red_herring":"some_other_val"}')
        self.load_bal_manager.get_ip_firebase()
        self.assertEqual(self.load_bal_manager.ip, "val")

    @patch('google.auth.transport.requests.AuthorizedSession.get')
    def test_get_ip_bad_response(self, mocked_auth_session_get):
        mocked_auth_session_get.return_value = MagicMock(ok=False, text='{"ip":"val","red_herring":"some_other_val"}')
        self.load_bal_manager.get_ip_firebase()

        self.assertEqual(self.load_bal_manager.ip, "")


if __name__ == "__main__":
    unittest.main()

