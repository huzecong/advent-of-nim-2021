import algorithm, math, strutils, sequtils, tables
import base, utils/[board, utils]

type Day9* = ref object of Solution
  board: Board[int]

proc newDay9*(path: string): Day9 =
  let lines = readFile(path).strip.splitLines
  let board = lines.mapIt(it.toSeq.map(parseInt))
  Day9(board: board)

method solvePart1Int*(this: Day9): int =
  for p in this.board.points:
    let cur = this.board[p]
    if this.board.neighbors(p).allIt(this.board[it] > cur):
      result += cur + 1

method solvePart2Int*(this: Day9): int =
  var visit: Board[bool] = newSeqWith(
      this.board.len, newSeqWith(this.board[0].len, false))

  proc floodfill(p: Point): int =
    visit[p] = true
    result = 1
    for np in this.board.neighbors(p):
      if not (visit[np] or this.board[np] == 9):
        result += floodfill(np)

  var basins: seq[int]
  for p in this.board.points:
    if visit[p] or this.board[p] == 9: continue
    basins.add(max(result, floodfill(p)))
  basins.sort
  return basins[^3 .. ^1].prod
