import math, strutils, sequtils, sugar, tables
import base, utils/utils

type Case = object
  digits: seq[set[char]]
  outputs: seq[set[char]]
type Day8* = ref object of Solution
  cases: seq[Case]

func toCharSet(s: string | seq[char]): set[char] =
  for ch in s:
    result.incl(ch)

proc newDay8*(path: string): Day8 =
  let lines = readFile(path).strip.splitLines
  var cases: seq[Case]
  for line in lines:
    let (digits, outputs) = line.split(" | ").map(
        s => s.splitWhitespace.map(toCharSet)).toTuple(2)
    cases.add(Case(digits: digits, outputs: outputs))
  Day8(cases: cases)

method solvePart1Int*(this: Day8): int =
  this.cases.map(c => c.outputs.filter(s => s.len in {2, 3, 4, 7}).len).sum

proc solveCase(c: Case): int =
  #   0:      1:      2:      3:      4:      5:      6:      7:      8:      9:
  #  aaaa    ....    aaaa    aaaa    ....    aaaa    aaaa    aaaa    aaaa    aaaa
  # b    c  .    c  .    c  .    c  b    c  b    .  b    .  .    c  b    c  b    c
  # b    c  .    c  .    c  .    c  b    c  b    .  b    .  .    c  b    c  b    c
  #  ....    ....    dddd    dddd    dddd    dddd    dddd    ....    dddd    dddd
  # e    f  .    f  e    .  .    f  .    f  .    f  e    f  .    f  e    f  .    f
  # e    f  .    f  e    .  .    f  .    f  .    f  e    f  .    f  e    f  .    f
  #  gggg    ....    gggg    gggg    ....    gggg    gggg    ....    gggg    gggg
  var charMap = initTable[char, char]()
  var lenToDigit: array[2 .. 7, seq[set[char]]]
  # len = 2: 1
  # len = 3: 7
  # len = 4: 4
  # len = 5: 2, 3, 5
  # len = 6: 0, 6, 9
  # len = 7: 8
  for digit in c.digits:
    lenToDigit[digit.len].add(digit)

  func only[T](s: set[T] | seq[T]): T =
    assert s.len == 1
    return s.toSeq[0]

  func mapChars(s: string): set[char] =
    s.map(c => charMap[c]).toCharSet

  let fullSet = {'a' .. 'g'}

  # 7 - 1 => a
  charMap['a'] = only(lenToDigit[3].only - lenToDigit[2].only)
  # 2 & 3 & 5 => adg
  let adg = lenToDigit[5].foldl(a * b)
  # ~0 | ~6 | ~9 => cde
  let cde = lenToDigit[6].map(s => fullSet - s).foldl(a + b)
  charMap['d'] = only(adg * cde)
  charMap['g'] = only(adg - "ad".mapChars)
  # 4 - 1 => bd
  charMap['b'] = only(lenToDigit[4].only - lenToDigit[2].only - "d".mapChars)
  # 5 - abdg => f
  let abdg = "abdg".mapChars
  charMap['f'] = only(lenToDigit[5].filter(x => abdg < x).only - abdg)
  # 1 - f => c
  charMap['c'] = only(lenToDigit[2].only - "f".mapChars)
  charMap['e'] = only(fullSet - "abcdfg".mapChars)

  let digitCodes = [
    "abcefg", "cf", "acdeg", "acdfg", "bcdf",
    "abdfg", "abdefg", "acf", "abcdefg", "abcdfg",
  ]
  let codeToDigit = digitCodes.map(mapChars).pairs.toSeq.map(ic => (ic[1], ic[0])).toTable
  return c.outputs.map(x => codeToDigit[x]).join("").parseInt


method solvePart2Int*(this: Day8): int =
  this.cases.map(solveCase).sum
