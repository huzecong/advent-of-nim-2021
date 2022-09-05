import algorithm, nre, options, sequtils, strutils, sugar
import base, utils/[board, graph]

type Day24* = ref object of Solution
  coefs: seq[seq[int]]

let pattern = re("""
inp w
mul x 0
add x z
mod x (-?\d+)
div z (-?\d+)
add x (-?\d+)
eql x w
eql x 0
mul y 0
add y (-?\d+)
mul y x
add y 1
mul z y
mul y 0
add y w
add y (-?\d+)
mul y x
add z y
""".strip)

proc newDay24*(path: string): Day24 =
  let input = readFile(path).strip
  let coefs = collect(newSeq):
    for match in input.findIter(pattern):
      match.captures.toSeq.mapIt(it.get.parseInt)

  assert coefs.len == 14
  #[
    [(26,  1,  12, 25,  6),
     (26,  1,  10, 25,  6),
     (26,  1,  13, 25,  3),
     (26, 26, -11, 25, 11),
     (26,  1,  13, 25,  9),
     (26, 26,  -1, 25,  3),
     (26,  1,  10, 25, 13),
     (26,  1,  11, 25,  6),
     (26, 26,   0, 25, 14),
     (26,  1,  10, 25, 10),
     (26, 26,  -5, 25, 12),
     (26, 26, -16, 25, 10),
     (26, 26,  -7, 25, 11),
     (26, 26, -11, 25, 15)]
  ]#
  for coef in coefs:
    assert coef.len == 5
    assert coef[0] == 26
    assert coef[1] == 1 or coef[1] == 26
    if coef[1] == 26:
      assert coef[2] <= 0
    else:
      assert coef[2] > 0
    assert coef[3] == 25

  Day24(coefs: coefs)

func compute(coefs: seq[seq[int]], number: string): int =
  let digits = number.mapIt(($it).parseInt)
  assert coefs.len == digits.len
  var z = 0
  for (coef, w) in zip(coefs, digits):
    let x = z mod 26 + coef[2]
    z = z div coef[1]
    if x != w:
      z = z * 26 + coef[4] + w
  return z

type Op = object
  remove: bool
  offset: int
  base: int

func newOp(offset, base: int, remove: bool = false): Op =
  Op(remove: offset <= 0, offset: offset, base: base)

const opers = @[
  newOp( 12,  6),
  newOp( 10,  6),
  newOp( 13,  3),
  newOp(-11, 11),  # remove
  newOp( 13,  9),
  newOp( -1,  3),  # remove
  newOp( 10, 13),
  newOp( 11,  6),
  newOp(  0, 14),  # remove
  newOp( 10, 10),
  newOp( -5, 12),  # remove
  newOp(-16, 10),  # remove
  newOp( -7, 11),  # remove
  newOp(-11, 15),  # remove
]

func compute(number: string): int =
  let digits = number.mapIt(($it).parseInt)
  var stack: seq[int]
  for (op, w) in zip(opers, digits):
    let x = (if stack.len == 0: 0 else: stack[^1]) + op.offset
    if op.remove and stack.len > 0: discard stack.pop
    if x != w:
      stack.add op.base + w
  return stack.foldl(a * 26 + b)

proc findSolution(hasChosen: seq[bool], debug: bool = false): Option[string] =
  if hasChosen.count(true) > 7 or hasChosen[^1] == true:
    return none(string)

  var stack: seq[int]
  var stackIdx: seq[int]
  # `stackIdx[i]` is the index of the value remaining in stack when computing the `i`-th digit
  # `x` at `i`-th timestamp: opers[stackIdx[i]].base + number[stackIdx[i]] + opers[i].offset
  for idx, (op, chosen) in zip(opers, hasChosen):
    stackIdx.add(if stack.len == 0: -1 else: stack[^1])
    if op.remove and stack.len > 0: discard stack.pop
    if chosen: stack.add idx
  
  if debug:
    echo stackIdx
  
  let n = hasChosen.len
  var numbers = newSeqWith(n, none(int))
  
  func get(i: int): (Op, bool, int) = (opers[i], hasChosen[i], stackIdx[i])

  func expect[T](x: var Option[T], val: T): bool =
    if x.isNone:
      x = some(val)
    elif x.get != val:
      return false
    return true
  
  var
    diffs = initBoard(n, n, none(int))
    noEq = initBoard(n, n, none(int))
  for i in 0 ..< n:
    diffs[i][i] = some(0)
  for i in 0 ..< n:
    let (op, chosen, sIdx) = get(i)
    if sIdx != -1:
      let diff = opers[sIdx].base + op.offset
      if not chosen:
        diffs[sIdx][i] = some(diff)
        diffs[i][sIdx] = some(-diff)
      else:
        noEq[sIdx][i] = some(diff)
        noEq[i][sIdx] = some(-diff)
  for k in 0 ..< n:
    for i in 0 .. k:
      for j in 0 .. k:
        if diffs[i][k].isSome and diffs[k][j].isSome:
          let diff = diffs[i][k].get + diffs[k][j].get
          if not diffs[i][j].expect(diff):
            return none(string)
  
  if debug:
    echo diffs.mapEach(x => (if x.isSome: $(x.get) else: " "))
    echo noEq.mapEach(x => (if x.isSome: $(x.get) else: " "))
  
  for i in 0 ..< n:
    let (op, chosen, sIdx) = get(i)
    if not chosen and sIdx == -1:
      numbers[i] = some(op.offset)
      for j in 0 ..< n:
        if diffs[i][j].isNone: continue
        let val = op.offset + diffs[i][j].get
        if val <= 0 or val > 9:
          return none(string)
        if not numbers[j].expect(val):
          return none(string)
  
  if debug:
    echo numbers
  
  func dfs(i: int): Option[string] =
    if i >= n:
      return some(numbers.mapIt($(it.get)).join(""))
    if numbers[i].isSome: return dfs(i + 1)
    let (op, _, _) = get(i)
    for digit in countdown(9, 1):
      var valid = true
      var newNumbers = newSeqWith(n, none(int))
      newNumbers[i] = some(digit)
      for j in 0 ..< n:
        if diffs[i][j].isSome:
          let val = op.offset + diffs[i][j].get
          if val <= 0 or val > 9:
            valid = false
          elif numbers[j].isSome and numbers[j].get != val:
            valid = false
          elif numbers[j].isNone:
            newNumbers[j] = some(val)
        if noEq[i][j].isSome and numbers[j].isSome:
          if digit + noEq[i][j].get == numbers[j].get:
            valid = false
        if not valid:
          break
      if valid:
        for j, num in newNumbers:
          if num.isSome:
            numbers[j] = num
        let val = dfs(i + 1)
        if val.isSome:
          return val
        for j, num in newNumbers:
          if num.isSome:
            numbers[j] = none(int)

  return dfs(0)

method solvePart1*(this: Day24): string =
  # echo compute(this.coefs, "13579246899999")
  # echo compute("13579246899999")
  for hasChosen in product(newSeqWith(opers.len, @[false, true])):
    let val = findSolution(hasChosen)
    if val.isSome:
      echo hasChosen, val.get
      if compute(val.get) != 0:
        discard findSolution(hasChosen, debug = true)
        break
      result = max(result, val.get)

method solvePart2Int*(this: Day24): int =
  discard
