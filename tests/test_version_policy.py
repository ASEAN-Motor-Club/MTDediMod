"""Version-file and release-tag policy tests."""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import check_version  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]


class VersionPolicyTests(unittest.TestCase):
    def test_committed_version_files_are_stable(self):
        versions = check_version.read_versions(ROOT)
        self.assertEqual(set(versions), {"client", "server"})
        for value in versions.values():
            self.assertRegex(value, r"^\d+\.\d+\.\d+$")

    def test_version_file_rejects_rc_suffix(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "VERSION").write_text("1.2.3-rc1\n")
            (root / "SERVER_VERSION").write_text("4.5.6\n")
            with self.assertRaises(ValueError):
                check_version.read_version(root, "VERSION")

    def test_stable_and_rc_tags_match_version_files(self):
        versions = {"client": "1.2.3", "server": "4.5.6"}
        self.assertEqual(check_version.check_tag("client/v1.2.3", versions)["prerelease"], False)
        self.assertEqual(check_version.check_tag("client/v1.2.3-rc2", versions)["prerelease"], True)
        self.assertEqual(check_version.check_tag("server/v4.5.6", versions)["prerelease"], False)

    def test_mismatched_and_malformed_tags_rejected(self):
        versions = {"client": "1.2.3", "server": "4.5.6"}
        for bad in ("client/v1.2.4", "server/v4.5.7-rc1", "client/v1.2.3-rc0", "v1.2.3", "client/1.2.3"):
            with self.subTest(tag=bad):
                with self.assertRaises(ValueError):
                    check_version.check_tag(bad, versions)


if __name__ == "__main__":
    unittest.main()
