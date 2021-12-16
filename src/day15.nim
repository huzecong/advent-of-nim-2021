import deques, strutils, sequtils
import base, utils/[board, utils]

type Day15* = ref object of Solution
  board: Board[int]

proc newDay15*(path: string): Day15 =
  let board = readFile(path).strip.splitLines.mapIt(it.toSeq.map(parseInt))
  Day15(board: board)

func shortestPath[T](board: Board[T], source: Point, target: Point): T =
  var
    distance: Board[T] = initBoardLike(board, init = high(T))
    inQueue: Board[bool] = initBoardLike(board, init = false)
    queue: Deque[Point]
  distance[source] = 0
  queue.addLast(source)
  inQueue[source] = true

  while queue.len > 0:
    let cur = queue.popFirst
    inQueue[cur] = false
    for p in board.neighbors(cur):
      if distance[p] > distance[cur] + board[p]:
        distance[p] = distance[cur] + board[p]
        if not inQueue[p]:
          queue.addLast(p)
          inQueue[p] = true
  return distance[target]

method solvePart1Int*(this: Day15): int =
  this.board.shortestPath((0, 0), (this.board.nRows - 1, this.board.nCols - 1))

method solvePart2Int*(this: Day15): int =
  var newBoard = initBoard(this.board.nRows * 5, this.board.nCols * 5, init = 0)
  for i in 0 ..< 5:
    for j in 0 ..< 5:
      for x in 0 ..< this.board.nRows:
        for y in 0 ..< this.board.nCols:
          newBoard[(i * this.board.nRows + x, j * this.board.nCols + y)] =
            (this.board[(x, y)] - 1 + i + j) mod 9 + 1
  newBoard.shortestPath((0, 0), (newBoard.nRows - 1, newBoard.nCols - 1))
