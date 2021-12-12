import strutils, tables
import base, utils/utils

type Graph[T] = Table[T, seq[T]]
type Day12* = ref object of Solution
  graph: Graph[string]

proc newDay12*(path: string): Day12 =
  let lines = readFile(path).strip.splitLines
  var graph: Graph[string]
  for line in lines:
    let (x, y) = line.split("-").toTuple(2)
    graph.mgetOrPut(x, @[]).add(y)
    graph.mgetOrPut(y, @[]).add(x)
  Day12(graph: graph)

proc countPaths(graph: Graph[string], allowTwice: bool): int =
  var count: int
  var visited: Table[string, bool]
  var visitedTwice: bool = false
  # var stack: seq[string]
  for node in graph.keys:
    visited[node] = false

  template toggle(x: var bool, body: untyped): void =
    assert not x
    x = true
    body
    x = false

  template tryVisit(node: string, body: untyped): void =
    if not node[0].isLowerAscii():
      body
    elif not visited[node]:
      toggle(visited[node]):
        body
    elif not (node == "start" or node == "end") and
        allowTwice and not visitedTwice:
      toggle(visitedTwice):
        body

  proc dfs(x: string): void =
    if x == "end":
      inc count
    else:
      for node in graph[x]:
        tryVisit(node):
          # stack.add(node)
          dfs(node)
          # discard stack.pop

  tryVisit("start"):
    dfs("start")
  return count

method solvePart1Int*(this: Day12): int =
  countPaths(this.graph, allowTwice = false)

method solvePart2Int*(this: Day12): int =
  countPaths(this.graph, allowTwice = true)
