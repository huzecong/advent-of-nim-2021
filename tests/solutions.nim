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
  test "Day 4":
    checkDay("day4", $10680, $31892)
  test "Day 5":
    checkDay("day5", $5306, $17787)
  test "Day 6":
    checkDay("day6", $358214, $1622533344325)
  test "Day 7":
    checkDay("day7", $353800, $98119739)
  test "Day 8":
    checkDay("day8", $261, $987553)
  test "Day 9":
    checkDay("day9", $506, $931200)
  test "Day 10":
    checkDay("day10", $464991, $3662008566)
  test "Day 11":
    checkDay("day11", $1640, $312)
