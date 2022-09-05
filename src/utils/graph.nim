import tables

type
  Graph*[T, W = int] = object
    labelToNode: Table[T, int]
    nodeToLabel: seq[T]
    edges: Table[int, seq[(int, W)]]

func nNodes*[T, W](graph: Graph[T, W]): int = graph.nodeToLabel.len

func nEdges*[T, W](graph: Graph[T, W]): int = graph.edges.values.map(len).sum

func addNode*[T, W](graph: var Graph[T, W], label: T): void =
  if label notIn graph.labelToNode:
    let id = graph.nodeToLabel.len
    graph.nodeToLabel.add(label)
    graph.labelToNode[label] = id
    graph.edges[id] = @[]

func addEdge*[T, W](graph: var Graph[T, W], a: T, b: T, weight: W = 0): void =
  graph.addNode(a)
  graph.addNode(b)
  graph.edges[graph.labelToNode[a]].add((graph.labelToNode[b], weight))

iterator neighbors*[T, W](graph: Graph[T, W], node: T): tuple[node: T, weight: W] =
  for (next, w) in graph.edges[node]:
    yield (graph.nodeToLabel[next], w)
