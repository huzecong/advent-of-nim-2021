import math, options, sugar, tables

type Iterable[T] = (iterator: T)

func toIter*[T](xs: Iterable[T]): Iterable[T] = xs

func toIter*[T](xs: seq[T]): Iterable[T] =
  (iterator: T =
    for x in xs:
      yield x)

func minMax*[T](xs: Iterable[T] | seq[T]): tuple[min: T, max: T] =
  var
    minVal = high(T)
    maxVal = low(T)
  let iter = toIter(xs)
  for x in iter():
    minVal = min(minVal, x)
    maxVal = max(maxVal, x)
  return (minVal, maxVal)

func filterMap*[A, B](xs: openArray[A], fn: A -> Option[B]): seq[B] =
  collect(newSeq):
    for x in xs:
      let val = fn(x)
      if val.isSome: val.get

iterator count*(init: int = 0): int =
  var x = init
  while true:
    yield x
    inc x

## Required to make `tables.keys` work with functions that expect an iterator.
func keys*[K, V](table: Table[K, V]): iterator: K =
  (iterator: K =
    for x in table.keys:
      yield x)

func flatten*[T](xss: seq[seq[T]]): seq[T] =
  collect(newSeqOfCap(xss.mapIt(it.len).sum)):
    for xs in xss:
      for x in xs:
        x
