# Package

version       = "0.1.0"
author        = "Zecong Hu"
description   = "Solutions to advent-of-code 2021"
license       = "MIT"
srcDir        = "src"
bin           = @["aoc2021"]


# Dependencies

requires "nim >= 1.6.0"
requires "argparse >= 2"

task test, "Runs the test suite":
  exec "nim c -r tests/tester"

task lint, "Lint all code files":
  exec "nimpretty src/*.nim tests/*.nim"