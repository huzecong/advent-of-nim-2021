import algorithm, math, strutils, sequtils, sugar, tables
import base

type
  Board[T] = seq[seq[T]]
  Point = (int, int)

func `[]`[T](board: Board[T], p: Point): T = board[p[0]][p[1]]

func `[]=`[T](board: var Board[T], p: Point, val: T): void = board[p[0]][p[1]] = val

func inBounds[T](board: Board[T], p: Point): bool =
  let (x, y) = p
  return 0 <= x and x < board.len and 0 <= y and y < board[0].len

func `+`(x: Point, y: Point): Point = (x[0] + y[0], x[1] + y[1])

const directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

func neighbors[T](board: Board[T], p: Point): seq[Point] =
  directions.mapIt(it + p).filterIt(board.inBounds(it))

iterator points[T](board: Board[T]): Point =
  for x in 0 ..< board.len:
    for y in 0 ..< board[x].len:
      yield (x, y)

type Day9* = ref object of Solution
  board: seq[seq[int]]

proc newDay9*(path: string): Day9 =
  let lines = readFile(path).strip.splitLines
  let board = lines.mapIt(it.toSeq.map(c => c.int - '0'.int))
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
