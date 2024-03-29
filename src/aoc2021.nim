import strformat, strutils, sugar, times
import argparse
import base, day1, day2, day3, day4, day5, day6, day7, day8, day9, day10, day11,
    day12, day13, day14, day15, day16, day17, day18, day24, day25

proc getSolution*(problem: string, input: string = ""): Solution =
  # `problem` is a string of form `dayX`
  let path = if input.len == 0: &"inputs/{problem}.txt" else: input
  case problem
    of "day1": newDay1(path)
    of "day2": newDay2(path)
    of "day3": newDay3(path)
    of "day4": newDay4(path)
    of "day5": newDay5(path)
    of "day6": newDay6(path)
    of "day7": newDay7(path)
    of "day8": newDay8(path)
    of "day9": newDay9(path)
    of "day10": newDay10(path)
    of "day11": newDay11(path)
    of "day12": newDay12(path)
    of "day13": newDay13(path)
    of "day14": newDay14(path)
    of "day15": newDay15(path)
    of "day16": newDay16(path)
    of "day17": newDay17(path)
    of "day18": newDay18(path)
    of "day24": newDay24(path)
    of "day25": newDay25(path)
    else: raise newException(ValueError, &"Invalid problem: {problem}")

proc main(problem: string, input: string = "",
        profile: bool = false) =
  let solution = getSolution(problem, input)

  proc run(part: int, solveFn: () -> string) =
    let startTime = cpuTime()
    let ans = solveFn()
    if profile:
      let elapsedTime = cpuTime() - startTime
      echo &"Part {part} took {elapsedtime:.3f}s"
    echo &"Part {part} answer: {ans}"

  echo &"Solving problem {problem}"
  run(1, () => solution.solvePart1)
  run(2, () => solution.solvePart2)

when isMainModule:
  {.warning[Deprecated]: off.}
  var p = newParser:
    help("Solve Advent of Code 2021 problems")
    arg("problem", help = "Problem to solve (e.g. day14)")
    option("--input", help = "Path to input file")
    flag("--profile", help = "Profile run time")
    run:
      main(opts.problem, opts.input, profile = opts.profile)
  p.run
