import unittest

import aoc2021, base

suite "Verify solutions are correct":
    setup:
        proc checkDay(day: string, answer1: string, answer2: string) =
            let solution = getSolution(day)
            check(solution.solvePart1 == answer1)
            check(solution.solvePart2 == answer2)

    test "Day 1":
        checkDay("day1", $1665, $1702)
    test "Day 2":
        checkDay("day2", $1427868, $1568138742)
    test "Day 3":
        checkDay("day3", $4006064, $5941884)
