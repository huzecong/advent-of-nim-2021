import deques, math, strutils, sequtils, sugar
import base, utils/[board, iter, utils]

type Day11* = ref object of Solution
  board: Board[int]

proc newDay11*(path: string): Day11 =
  let board = readFile(path).strip.splitLines.mapIt(it.toSeq.map(parseInt))
  Day11(board: board)

func step(board: var Board[int]): int =
  # Returns number of flashes
  var newBoard = board.mapEach(x => x + 1)
  var flashed = initBoardLike(board, false)
  var queue: Deque[Point]
  for p, x in newBoard.entries:
    if x > 9:
      flashed[p] = true
      queue.addLast(p)

  while queue.len > 0:
    let cur = queue.popFirst
    for p in board.neighbors(cur, nDirs = 8):
      if flashed[p]: continue
      inc newBoard[p]
      if newBoard[p] > 9:
        flashed[p] = true
        queue.addLast(p)
  for p, x in flashed.entries:
    if x:
      inc result
      board[p] = 0
    else:
      board[p] = newBoard[p]

method solvePart1Int*(this: Day11): int =
  var board = this.board
  for i in 1 .. 100:
    result += board.step

method solvePart2Int*(this: Day11): int =
  var board = this.board
  for i in count(1):
    let cur = board.step
    if cur == board.nRows * board.nCols:
      return i
