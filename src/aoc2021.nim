# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.

import std/strformat, strutils, os
import base, day1, day2, day3

proc getSolution(day: int): Solution =
    let path = &"inputs/day{day}.txt"
    case day
        of 1: initDay1(path)
        of 2: initDay2(path)
        of 3: initDay3(path)
        else: raise newException(ValueError, &"Invalid day {day}")

when isMainModule:
    if paramCount() < 1:
        echo "usage: aoc2021 [day]"
        quit 1

    let day = paramStr(1).parseInt
    let solution = getSolution(day)

    let ans1 = solution.solvePart1
    echo "Part 1: ", ans1

    let ans2 = solution.solvePart2
    echo "Part 2: ", ans2
