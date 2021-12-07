import math, strutils, sequtils, sugar, tables
import base

type BingoBoard[T] = object
  nRows, nCols: int
  board: seq[seq[T]]
  mark: seq[seq[bool]]
  index: Table[T, (int, int)]

func initBingoBoard[T](board: seq[seq[T]]): BingoBoard[T] =
  let
    nRows = board.len
    nCols = board[0].len
  var index = initTable[T, (int, int)]()
  for i, row in board:
    for j, x in row:
      index[x] = (i, j)
  let mark = newSeqWith(nRows, newSeqWith(nCols, false))
  BingoBoard[T](nRows: nRows, nCols: nCols,
      board: board.deepCopy, mark: mark, index: index)

proc markNumber[T](board: var BingoBoard[T], number: T): bool =
  if number notin board.index: return false
  let (i, j) = board.index[number]
  board.mark[i][j] = true
  return true

func bingo[T](board: BingoBoard[T]): bool =
  board.mark.any(row => row.all(x => x)) or
      toSeq(0 ..< board.nCols).any(y => toSeq(0 ..< board.nRows).all(
          x => board.mark[x][y]))

func getUnmarkedSum[T](board: BingoBoard[T]): T =
  let unmarked = collect(newSeq):
    for i, row in board.board:
      for j, x in row:
        if not board.mark[i][j]: x
  return sum(unmarked)

type Day4* = ref object of Solution
  numbers: seq[int]
  boards: seq[BingoBoard[int]]

proc newDay4*(path: string): Day4 =
  let blocks = readFile(path).strip.split("\n\n")
  let numbers = blocks[0].split(",").map(parseInt)
  let boards = blocks[1..^1].map(blk => blk.splitLines.map(
        line => line.splitWhitespace.map(parseInt)).initBingoBoard)
  Day4(numbers: numbers, boards: boards)

method solvePart1Int*(this: Day4): int =
  var boards = this.boards
  for num in this.numbers:
    for board in boards.mitems:
      if board.markNumber(num) and board.bingo:
        return num * board.getUnmarkedSum
  assert false

method solvePart2Int*(this: Day4): int =
  var
    boards = this.boards
    hasWon = newSeqWith(boards.len, false)
    winCount = 0
  for num in this.numbers:
    for i, board in boards.mpairs:
      if not hasWon[i] and board.markNumber(num) and board.bingo:
        hasWon[i] = true
        inc winCount
        if winCount == boards.len:
          return num * board.getUnmarkedSum
  assert false
