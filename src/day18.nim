import algorithm, sequtils, strformat, strutils, sugar
import base, utils/utils

type
  SNodeKind = enum Number, Pair
  SNode = ref object
    parent: SNode
    case kind: SNodeKind
      of Number: number: int
      of Pair: left, right: SNode

type Day18* = ref object of Solution
  numbers: seq[SNode]

func newPairNode(left: SNode, right: SNode, parent: SNode = nil): SNode =
  result = SNode(kind: Pair, left: left, right: right, parent: parent)
  left.parent = result
  right.parent = result

func parseSNode(s: string): SNode =
  var stack: seq[SNode]
  for (token, isSep) in tokenize(s, {'[', ']', ','}):
    if not isSep:
      stack.add(SNode(kind: Number, number: parseInt(token)))
    else:
      for ch in token:
        case ch:
          of ']':
            assert stack.len >= 2
            let
              right = stack.pop
              left = stack.pop
              node = SNode(kind: Pair, left: left, right: right)
            stack.add(node)
            left.parent = node
            right.parent = node
          of '[', ',': discard
          else: raise newException(ValueError, "Invalid Snailfish string")
  assert stack.len == 1
  return stack[0]

func prevNumber(node: SNode): SNode =
  var p = node
  while p.parent != nil and p.parent.left == p:
    p = p.parent
  if p.parent == nil:
    return nil
  p = p.parent.left
  while p.kind == Pair:
    p = p.right
  return p

func nextNumber(node: SNode): SNode =
  var p = node
  while p.parent != nil and p.parent.right == p:
    p = p.parent
  if p.parent == nil:
    return nil
  p = p.parent.right
  while p.kind == Pair:
    p = p.left
  return p

func `$`(node: SNode): string =
  case node.kind:
    of Number: $node.number
    of Pair: &"[{node.left}, {node.right}]"

proc newDay18*(path: string): Day18 =
  let numbers = readFile(path).strip.splitLines.map(parseSNode)
  Day18(numbers: numbers)

func map(node: SNode, fn: (int, int) -> int): int =
  case node.kind:
    of Number: node.number
    of Pair: fn(node.left.map(fn), node.right.map(fn))

func tryExplode(node: var SNode, depth: int = 1): bool =
  if node.kind == Pair:
    if depth > 4 and node.left.kind == Number and node.right.kind == Number:
      let
        prev = node.prevNumber
        next = node.nextNumber
      if prev != nil: prev.number += node.left.number
      if next != nil: next.number += node.right.number
      node = SNode(kind: Number, number: 0, parent: node.parent)
      return true
    elif tryExplode(node.left, depth + 1): return true
    elif tryExplode(node.right, depth + 1): return true
  return false

func trySplit(node: var SNode): bool =
  if node.kind == Number:
    if node.number >= 10:
      let
        left = SNode(kind: Number, number: node.number div 2)
        right = SNode(kind: Number, number: (node.number + 1) div 2)
      node = newPairNode(left, right, node.parent)
      return true
  elif trySplit(node.left): return true
  elif trySPlit(node.right): return true
  return false

func addNodes(left: SNode, right: SNode): SNode =
  var node = newPairNode(left.deepCopy, right.deepCopy)
  while tryExplode(node) or trySplit(node):
    discard
  return node

method solvePart1Int*(this: Day18): int =
  var node = this.numbers[0]
  for num in this.numbers[1 .. ^1]:
    node = addNodes(node, num)
  return node.map((x, y) => 3 * x + 2 * y)

method solvePart2Int*(this: Day18): int =
  for (a, b) in product([this.numbers, this.numbers]).map(xs => xs.toTuple(2)):
    result = max(result, addNodes(a, b).map((x, y) => 3 * x + 2 * y))
