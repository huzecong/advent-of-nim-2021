import macros, tables

macro toTuple*[T](s: openArray[T], length: static[int]): untyped =
  result = newNimNode(nnkPar)
  for i in 0 ..< length:
    result.add nnkBracketExpr.newTree(s, newLit(i))

type Iterable[T] = (iterator: T)

func minMax*[T](iter: Iterable[T]): tuple[min: T, max: T] =
  var
    minVal = high(T)
    maxVal = low(T)
  for x in iter():
    minVal = min(minVal, x)
    maxVal = max(maxVal, x)
  return (minVal, maxVal)

## Required to make `tables.keys` work with functions that expect an iterator.
func keys*[K, V](table: Table[K, V]): iterator: K =
  (iterator: K =
    for x in table.keys:
      yield x)