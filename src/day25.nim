import sequtils, strutils, tables
import base, utils/board

type Unit = enum Empty = ".", Right = ">", Down = "v"
type Day25* = ref object of Solution
  board: Board[Unit]

proc newDay25*(path: string): Day25 =
  let board = readFile(path).strip.splitLines.mapIt(it.mapIt(parseEnum[Unit]($it)))
  Day25(board: board)

const delta = {Right: (0, 1), Down: (1, 0)}.toTable

func move(board: Board[Unit]): Board[Unit] =
  var newBoard = initBoardLike(board, Empty)
  for p in board.points:
    if board[p] == Right:
      let np = board.wrap(p + delta[board[p]])
      if board[np] == Empty:
        newBoard[np] = board[p]
      else:
        newBoard[p] = board[p]
  for p in board.points:
    if board[p] == Down:
      let np = board.wrap(p + delta[board[p]])
      if board[np] != Down and newBoard[np] == Empty:
        newBoard[np] = board[p]
      else:
        newBoard[p] = board[p]
  return newBoard

method solvePart1Int*(this: Day25): int =
  var board = this.board
  while true:
    inc result
    let newBoard = board.move
    if newBoard == board:
      break
    board = newBoard

method solvePart2Int*(this: Day25): int =
  discard
