"""Regression checks for the coverage gate's false-green failure modes."""

import unittest

from scripts.check_coverage import measure, meets_minimum


def record(source="lib/main.dart", hits=(1, 0)):
    rows = [f"SF:{source}"]
    rows += [f"DA:{line},{hit}" for line, hit in enumerate(hits, 1)]
    rows += [f"LF:{len(hits)}", f"LH:{sum(hit > 0 for hit in hits)}", "end_of_record"]
    return "\n".join(rows) + "\n"


class CoverageTest(unittest.TestCase):
    def test_windows_paths_and_repeated_records_merge_by_line(self):
        report = record(r"lib\main.dart") + record(hits=(0, 2))
        self.assertEqual(measure(report, {"lib/main.dart"}), (2, 2))

    def test_uncovered_lines_count_across_all_sources(self):
        report = record(hits=(1, 1, 1)) + record("lib/other.dart", (0,))
        self.assertEqual(measure(report, {"lib/main.dart", "lib/other.dart"}), (3, 4))

    def test_missing_source_cannot_inflate_coverage(self):
        with self.assertRaisesRegex(ValueError, "missing"):
            measure(record(hits=(1,)), {"lib/main.dart", "lib/other.dart"})

    def test_empty_report_and_empty_sources_fail(self):
        for report, expected in [
            ("", {"lib/main.dart"}),
            ("", set()),
            (record(hits=()), {"lib/main.dart"}),
        ]:
            with self.subTest(report=report), self.assertRaises(ValueError):
                measure(report, expected)

    def test_malformed_and_truncated_records_fail(self):
        good = record()
        for report in [
            good.replace("DA:1,1", "DA:1,-1"),
            good.replace("DA:1,1", "DA:0,1"),
            good.replace("DA:1,1", "DA:1,no"),
            good.replace("DA:1,1", "DA:1"),
            good.replace("DA:2,0", "DA:1,0"),
            good.replace("LF:2", "LF:200"),
            good.replace("LH:1", "LH:2"),
            good.replace("LF:2\n", ""),
            good.replace("SF:lib/main.dart\n", ""),
            good.replace("end_of_record\n", ""),
            good.replace("end_of_record", "SF:lib/main.dart"),
            good.replace("lib/main.dart", "lib/unknown.dart"),
        ]:
            with self.subTest(report=report), self.assertRaises(ValueError):
                measure(report, {"lib/main.dart"})

    def test_threshold_uses_unrounded_percentage(self):
        self.assertTrue(meets_minimum(90, 100, 90))
        self.assertFalse(meets_minimum(89, 100, 90))
        self.assertFalse(meets_minimum(89999, 100000, 90))


if __name__ == "__main__":
    unittest.main()
