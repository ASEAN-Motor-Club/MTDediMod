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

    def test_version_file_rejects_prerelease_suffix(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            for bad in ("1.2.3-rc1\n", "1.2.3-exp.foo.1\n", "v1.2.3\n", "01.2.3\n"):
                (root / "VERSION").write_text(bad)
                with self.subTest(raw=bad.strip()):
                    with self.assertRaises(ValueError):
                        check_version.read_version(root, "VERSION")

    def test_stable_tags_must_match_version_files(self):
        versions = {"client": "1.2.3", "server": "4.5.6"}
        self.assertEqual(
            check_version.check_tag("client/v1.2.3", versions),
            {"kind": "client", "version": "1.2.3", "base": "1.2.3", "prerelease": False},
        )
        self.assertEqual(
            check_version.check_tag("server/v4.5.6", versions),
            {"kind": "server", "version": "4.5.6", "base": "4.5.6", "prerelease": False},
        )
        with self.assertRaises(ValueError):
            check_version.check_tag("client/v1.2.4", versions)
        with self.assertRaises(ValueError):
            check_version.check_tag("server/v4.5.7", versions)

    def test_prerelease_rc_and_exp_tags_accepted(self):
        versions = {"client": "1.2.3", "server": "4.5.6"}
        for tag, expected_ver in (
            ("client/v1.2.3-rc2", "1.2.3-rc2"),
            ("client/v1.3.0-rc.1", "1.3.0-rc.1"),
            ("server/v4.5.6-exp.junction-priority.3", "4.5.6-exp.junction-priority.3"),
            ("server/v4.6.0-exp.test.1", "4.6.0-exp.test.1"),
        ):
            with self.subTest(tag=tag):
                res = check_version.check_tag(tag, versions)
                self.assertTrue(res["prerelease"])
                self.assertEqual(res["version"], expected_ver)

    def test_malformed_tags_rejected(self):
        versions = {"client": "1.2.3", "server": "4.5.6"}
        for bad in (
            "client/v1.2.3-rc0",
            "client/v1.2.3-rc.0",
            "server/v4.5.6-exp.bad_name.1",
            "server/v4.5.6-exp.name.0",
            "server/v4.5.6-exp.name",
            "server/v4.5.6-beta1",
            "v1.2.3",
            "client/1.2.3",
            "client/v01.2.3",
        ):
            with self.subTest(tag=bad):
                with self.assertRaises(ValueError):
                    check_version.check_tag(bad, versions)


if __name__ == "__main__":
    unittest.main()
