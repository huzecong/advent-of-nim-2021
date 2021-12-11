import algorithm, sequtils, sugar, tables
import utils

type Point* = tuple[x, y: int]

func `+`*(x: Point, y: Point): Point = (x[0] + y[0], x[1] + y[1])
func `-`*(x: Point, y: Point): Point = (x[0] - y[0], x[1] - y[1])

type Board*[T] = seq[seq[T]]

func nRows*[T](board: Board[T]): int = board.len
func nCols*[T](board: Board[T]): int = board[0].len

template initBoard*[T](nRows, nCols: int, init: T = T()): Board[T] =
  newSeqWith(nRows, newSeqWith(nCols, init))
  
template initBoardLike*[T, PrevT](board: Board[PrevT], init: T = T()): Board[T] =
  newSeqWith(board.nRows, newSeqWith(board.nCols, init))

func `[]`*[T](board: Board[T], p: Point): T = board[p[0]][p[1]]

func `[]`*[T](board: var Board[T], p: Point): var T = board[p[0]][p[1]]

func `[]=`*[T](board: var Board[T], p: Point, val: T): void = board[p[0]][p[1]] = val

func inBounds*[T](board: Board[T], p: Point): bool =
  let (x, y) = p
  return 0 <= x and x < board.nRows and 0 <= y and y < board.nCols

const directions = {
  4: @[(0, 1), (1, 0), (0, -1), (-1, 0)],
  8: product([@[-1, 0, 1], @[-1, 0, 1]]).filterIt(it != [0, 0]).mapIt(toTuple(it, 2)),
}.toTable

func neighbors*[T](board: Board[T], p: Point, nDirs: int = 4): seq[Point] =
  if nDirs notIn {4, 8}:
    raise newException(ValueError, "'nDirs' must be 4 or 8")
  directions[nDirs].mapIt(it + p).filterIt(board.inBounds(it))

iterator points*[T](board: Board[T]): Point =
  for x in 0 ..< board.len:
    for y in 0 ..< board[x].len:
      yield (x, y)

iterator pairs*[T](board: Board[T]): (Point, T) =
  for p in board.points:
    yield (p, board[p])

func mapEach*[A, B](board: Board[A], fn: A -> B): Board[B] = board.mapIt(it.map(fn))

template mapEachIt*[T](board: Board[T], fn: untyped): untyped = board.mapIt(it.mapIt(fn))
