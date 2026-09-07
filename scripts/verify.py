"""Run Neovim regressions with isolated state; never read/write user sessions.

python scripts/verify.py [--data PATH] [--install]
--data is the installed nvim-data directory (default: platform standard).
--install permits first-time dependency installation into the isolated directory.
"""

from __future__ import annotations
import argparse
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data", type=Path)
    parser.add_argument("--install", action="store_true")
    parser.add_argument(
        "--tools",
        action="store_true",
        help="Validate installed parsers and actual Lua/JSON formatters",
    )
    parser.add_argument(
        "--lsp-file",
        action="append",
        default=[],
        metavar="SERVER=PATH",
        help="Read a real project file and require its server to attach and answer",
    )
    args = parser.parse_args()
    nvim = shutil.which("nvim")
    if not nvim:
        parser.error("Neovim 0.12+ must be on PATH")
    base = ROOT / "tmp"
    base.mkdir(exist_ok=True)
    # Short paths avoid Windows' per-component limit in Lua's compiled cache.
    sandbox = Path(tempfile.mkdtemp(prefix="nv-"))
    env = os.environ.copy()
    env["NVIM_APPNAME"] = "nvim"
    for name in ("CONFIG", "DATA", "STATE", "CACHE"):
        env[f"XDG_{name}_HOME"] = str(sandbox / name.lower())
    env["NVIM_OFFLINE"] = "1"
    config = sandbox / "config/nvim"
    shutil.copytree(ROOT / ".config/nvim", config)
    env["NVIM_TEST_CONFIG"] = str(config)
    env["NVIM_TEST_ROOT"] = str(ROOT)
    data = sandbox / "data" / ("nvim-data" if os.name == "nt" else "nvim")
    data.mkdir(parents=True)
    default_data = (
        Path(os.environ.get("LOCALAPPDATA", "")) / "nvim-data"
        if os.name == "nt"
        else Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share"))
        / "nvim"
    )
    installed = (args.data or default_data).resolve()
    if not args.install:
        for folder in ("lazy", "mason", "site"):
            source = installed / folder
            if source.is_dir():
                target = data / folder
                if os.name == "nt":
                    # Use a structured PowerShell command with literal quoted paths.
                    def q(value):
                        return "'" + str(value).replace("'", "''") + "'"

                    subprocess.run(
                        [
                            "powershell",
                            "-NoProfile",
                            "-Command",
                            f"New-Item -ItemType Junction -Path {q(target)} -Target {q(source)} | Out-Null",
                        ],
                        check=True,
                    )
                else:
                    target.symlink_to(source, target_is_directory=True)
        if not (data / "lazy/lazy.nvim").is_dir():
            parser.error("No installed plugins found. Use --data PATH or --install.")
    commands = [
        ("regression", [nvim, "--clean", "-l", "tests/regression.lua"]),
    ]
    if args.install:
        install_env = env.copy()
        install_env.pop("NVIM_OFFLINE")
        result = subprocess.run(
            [
                nvim,
                "--headless",
                "-u",
                "tests/integration_init.lua",
                "+Lazy! restore",
                "+qa",
            ],
            cwd=ROOT,
            env=install_env,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=600,
        )
        (sandbox / "install.log").write_bytes(result.stdout)
        if result.returncode:
            print(result.stdout.decode("utf-8", errors="replace"))
            return 1
    commands.append(
        (
            "integration",
            [
                nvim,
                "--headless",
                "-u",
                "tests/integration_init.lua",
                "+lua dofile('tests/integration.lua')",
            ],
        )
    )
    if args.tools:
        commands.append(
            (
                "tools",
                [
                    nvim,
                    "--headless",
                    "-u",
                    "tests/integration_init.lua",
                    "+lua dofile('tests/tools.lua')",
                ],
            )
        )
    language_files = {}
    for item in args.lsp_file:
        name, path = item.split("=", 1)
        path = Path(path).resolve()
        if not path.is_file():
            parser.error(f"LSP file is missing: {path}")
        language_files[f"lsp-{name}"] = (name, path)
        commands.append(
            (
                f"lsp-{name}",
                [
                    nvim,
                    "--headless",
                    "-u",
                    "tests/integration_init.lua",
                    "+lua dofile('tests/lsp.lua')",
                ],
            )
        )
    failures = 0
    for name, cmd in commands:
        try:
            run_env = env.copy()
            if name in language_files:
                server, path = language_files[name]
                run_env.update(NVIM_TEST_FILE=str(path), NVIM_TEST_LSP=server)
            result = subprocess.run(
                cmd,
                cwd=ROOT,
                env=run_env,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=120,
            )
            text = result.stdout.decode("utf-8", errors="replace")
            (sandbox / f"{name}.log").write_text(text, encoding="utf-8")
            print(text)
            bad = (
                result.returncode != 0
                or bool(re.search(r"Error detected|E\d{3,}:|FAIL ", text))
                or "RESULT" not in text
            )
            failures += int(bad)
        except subprocess.TimeoutExpired as exc:
            (sandbox / f"{name}.log").write_bytes(exc.stdout or b"")
            print(f"FAIL {name}: timed out")
            failures += 1
    print(f"Logs: {sandbox}\nRESULT verify: {failures} failed suites")
    return int(failures > 0)


if __name__ == "__main__":
    sys.exit(main())
