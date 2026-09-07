"""Require measured line coverage for every Dart source in trainer/lib."""

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def measure(report: str, expected: set[str]) -> tuple[int, int]:
    """Read LCOV line hits, validating records before merging repeated sources."""
    sources: dict[str, dict[int, int]] = {}
    source = None
    lines: dict[int, int] = {}
    totals: dict[str, int] = {}
    for number, raw in enumerate(report.splitlines(), 1):
        try:
            if raw.startswith("SF:"):
                if source is not None:
                    raise ValueError("unterminated source record")
                source = raw[3:].replace("\\", "/")
                path = Path(source)
                if path.is_absolute():
                    source = path.relative_to(ROOT / "trainer").as_posix()
                if source not in expected:
                    raise ValueError(f"unexpected source: {source}")
                lines, totals = {}, {}
            elif raw.startswith("DA:"):
                if source is None:
                    raise ValueError("line hit outside a source record")
                fields = raw[3:].split(",")
                if len(fields) not in (2, 3):
                    raise ValueError("invalid DA record")
                line, hits = map(int, fields[:2])
                if line <= 0 or hits < 0 or line in lines:
                    raise ValueError("invalid or duplicate line hit")
                lines[line] = hits
            elif raw.startswith(("LF:", "LH:")):
                key = raw[:2]
                if source is None or key in totals:
                    raise ValueError("invalid or duplicate line summary")
                totals[key] = int(raw[3:])
            elif raw == "end_of_record":
                if source is None or not lines:
                    raise ValueError("missing source or empty line coverage")
                actual = {"LF": len(lines), "LH": sum(h > 0 for h in lines.values())}
                if totals != actual:
                    raise ValueError("missing or inconsistent LF/LH summary")
                merged = sources.setdefault(source, {})
                for line, hits in lines.items():
                    merged[line] = merged.get(line, 0) + hits
                source = None
        except ValueError as error:
            raise ValueError(f"LCOV line {number}: {error}") from error
    if source is not None:
        raise ValueError("unterminated source record")
    missing = expected - sources.keys()
    if missing:
        raise ValueError("sources missing from coverage: " + ", ".join(sorted(missing)))
    found = sum(len(lines) for lines in sources.values())
    if not found:
        raise ValueError("no measured lines")
    hit = sum(h > 0 for lines in sources.values() for h in lines.values())
    return hit, found


def meets_minimum(hit: int, found: int, minimum: float) -> bool:
    # Compare unrounded values: a displayed 90.00% may actually be below 90%.
    return hit * 100 >= minimum * found


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--report", type=Path, default=ROOT / "trainer/coverage/lcov.info"
    )
    parser.add_argument("--min", type=float, default=90, dest="minimum")
    args = parser.parse_args()
    if not 0 <= args.minimum <= 100:
        parser.error("--min must be between 0 and 100")
    expected = {
        path.relative_to(ROOT / "trainer").as_posix()
        for path in (ROOT / "trainer/lib").rglob("*.dart")
    }
    try:
        hit, found = measure(args.report.read_text(encoding="utf-8"), expected)
    except (OSError, ValueError) as error:
        print(f"FAIL coverage: {error}")
        return 1
    passed = meets_minimum(hit, found, args.minimum)
    print(
        f"{'PASS' if passed else 'FAIL'} coverage: {hit}/{found} lines "
        f"({100 * hit / found:.2f}%), minimum {args.minimum:g}%, "
        f"all {len(expected)} trainer/lib sources"
    )
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
