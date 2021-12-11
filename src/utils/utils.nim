import macros

macro toTuple*[T](s: openArray[T], length: static[int]): untyped =
  result = newNimNode(nnkPar)
  for i in 0 ..< length:
    result.add nnkBracketExpr.newTree(s, newLit(i))

func parseInt*(c: char): int = c.int - '0'.int
