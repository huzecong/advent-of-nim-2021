import algorithm, math, strutils, sequtils, sugar, tables
import base

type Day10* = ref object of Solution
  lines: seq[string]

proc newDay10*(path: string): Day10 =
  let lines = readFile(path).strip.splitLines
  Day10(lines: lines)

const openBrackets = {'(', '[', '<', '{'}
const openToClose = {'{': '}', '(': ')', '[': ']', '<': '>'}.toTable

type
  MatchResultKind = enum Unmatched, Matched
  MatchResult = object
    case kind: MatchResultKind
      of Unmatched: closeBracket: char
      of Matched: stack: seq[char]

func matchBrackets(s: string): MatchResult =
  var stack: seq[char]
  for ch in s:
    if ch in openBrackets:
      stack.add(ch)
    else:
      let open = stack.pop
      if openToClose[open] != ch:
        return MatchResult(kind: Unmatched, closeBracket: ch)
  return MatchResult(kind: Matched, stack: stack)

func scorePart1(s: string): int =
  const scores = {')': 3, ']': 57, '}': 1197, '>': 25137}.toTable
  let matchResult = matchBrackets(s)
  return case matchResult.kind
    of Matched: 0
    of Unmatched: scores[matchResult.closeBracket]

method solvePart1Int*(this: Day10): int =
  this.lines.map(scorePart1).sum

func scorePart2(s: string): int =
  const scores = {'(': 1, '[': 2, '{': 3, '<': 4}.toTable
  let matchResult = matchBrackets(s)
  return case matchResult.kind
    of Matched: matchResult.stack.reversed.foldl(a * 5 + scores[b], first = 0)
    of Unmatched: 0

method solvePart2Int*(this: Day10): int =
  let scores = this.lines.map(scorePart2).filter(x => x > 0).sorted
  return scores[scores.len div 2]
