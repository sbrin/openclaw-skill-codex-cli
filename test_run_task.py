import importlib.util
from pathlib import Path
import unittest


SPEC = importlib.util.spec_from_file_location(
    "run_task",
    Path(__file__).with_name("run-task.py"),
)
run_task = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(run_task)


class TelegramProgressHelperTests(unittest.TestCase):
    def test_general_topic_payload_omits_message_thread_id(self):
        payload = run_task.build_telegram_send_payload(
            chat_id="-1003758807383",
            text="x",
            thread_id="1",
            silent=True,
        )

        self.assertNotIn("message_thread_id", payload)

    def test_non_general_topic_payload_keeps_message_thread_id(self):
        payload = run_task.build_telegram_send_payload(
            chat_id="-1003758807383",
            text="x",
            thread_id="19",
            silent=True,
        )

        self.assertEqual(payload["message_thread_id"], 19)

    def test_progress_helper_script_omits_general_topic_thread_field(self):
        script = run_task.render_progress_notify_script(
            bot_token="token",
            chat_id="-1003758807383",
            thread_id="1",
        )

        self.assertNotIn("message_thread_id", script)

    def test_progress_helper_script_keeps_non_general_topic_thread_field(self):
        script = run_task.render_progress_notify_script(
            bot_token="token",
            chat_id="-1003758807383",
            thread_id="19",
        )

        self.assertIn("'message_thread_id': 19", script)


if __name__ == "__main__":
    unittest.main()
