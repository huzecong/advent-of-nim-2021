import std/lists

type
  DList = DoublyLinkedList
  DNode = DoublyLinkedNode

proc insertAfter*[T](list: var DList[T], node: DNode[T],
    newNode: DNode[T]): DNode[T] {.discardable.} =
  if node != nil:
    newNode.prev = node
    newNode.prev.next = newNode
  else:
    list.head = newNode
  if node != nil and node.next != nil:
    newNode.next = node.next
    newNode.next.prev = newNode
  else:
    list.tail = newNode
  return newNode

proc insertAfter*[T](list: var DList[T], node: DNode[T], val: T):
    DNode[T] {.discardable.} =
  list.insertAfter(node, newDoublyLinkedNode(val))

proc insertBefore*[T](list: var DList[T], node: DNode[T],
    newNode: DNode[T]): DNode[T] {.discardable.} =
  list.insertAfter(node.prev, newNode)

proc insertBefore*[T](list: var DList[T], node: DNode[T], val: T):
    DNode[T] {.discardable.} =
  list.insertBefore(node, newDoublyLinkedNode(val))
