import strutils, tables
import base, utils/[utils]

type
  PairCounts = CountTable[(char, char)]
  ReactTable = Table[(char, char), char]
type Day14* = ref object of Solution
  polymer: string
  reactions: ReactTable

proc newDay14*(path: string): Day14 =
  let blocks = readFile(path).strip.split("\n\n")
  var reactions: Table[(char, char), char]
  for line in blocks[1].splitLines:
    let (a, b) = line.split(" -> ").toTuple(2)
    assert a.len == 2 and b.len == 1
    reactions[(a[0], a[1])] = b[0]
  Day14(polymer: blocks[0], reactions: reactions)

func toPairCounts(polymer: string): PairCounts =
  for i in 1 ..< polymer.len:
    result.inc((polymer[i - 1], polymer[i]))
  result.inc((polymer[^1], '\0'))

func react(pairCounts: PairCounts, reactions: ReactTable): PairCounts =
  for pair, count in pairCounts:
    let (a, b) = pair
    if pair in reactions:
      let c = reactions[pair]
      result.inc((a, c), count)
      result.inc((c, b), count)
    else:
      result.inc(pair, count)

func compute(polymer: string, reactions: ReactTable, steps: int): int =
  var pairCounts = polymer.toPairCounts
  for _ in 1 .. steps:
    pairCounts = pairCounts.react(reactions)
  var polymerCount: CountTable[char]
  for pair, count in pairCounts:
    polymerCount.inc(pair[0], count)
  return polymerCount.largest[1] - polymerCount.smallest[1]

method solvePart1Int*(this: Day14): int =
  compute(this.polymer, this.reactions, steps = 10)

method solvePart2Int*(this: Day14): int =
  compute(this.polymer, this.reactions, steps = 40)
