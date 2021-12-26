import math, sequtils, strformat, strutils, sugar
import base, utils/[iter]

type Day16* = ref object of Solution
  bits: seq[int]

func toBits(ch: char): seq[int] =
  let value = (if ch in {'0' .. '9'}: ch.ord - '0'.ord else: ch.ord - 'A'.ord + 10)
  countdown(3, 0).toSeq.mapIt(value shr it and 1)

proc newDay16*(path: string): Day16 =
  let input = readFile(path).strip
  let bits = input.map(toBits).flatten
  Day16(bits: bits)

type Scanner = object
  bits: seq[int]
  pos: int

func newScanner(bits: seq[int]): Scanner = Scanner(bits: bits, pos: 0)

func read(scanner: var Scanner, nBits: int = 1): int =
  for _ in 1 .. nBits:
    result = result * 2 + scanner.bits[scanner.pos]
    inc scanner.pos

type
  PacketType = enum Literal, Operator
  TypeID = enum
    Sum = 0
    Product = 1
    Minimum = 2
    Maximum = 3
    GreaterThan = 5
    LessThan = 6
    EqualTo = 7
  Packet[T] = ref object
    version: int
    length: int
    case packetType: PacketType
      of Literal:
        value: T
      of Operator:
        typeID: TypeID
        subpackets: seq[Packet[T]]

proc parse(scanner: var Scanner): Packet[int] =
  let
    start = scanner.pos
    version = scanner.read(3)
    typeID = scanner.read(3)
  if typeID == 4:
    var value = 0
    while true:
      let
        prefix = scanner.read(1)
        payload = scanner.read(4)
      value = value shl 4 or payload
      if prefix == 0: break
    result = Packet[int](packetType: Literal, value: value,
        version: version, length: scanner.pos - start)
  else: # operator
    let lengthType = scanner.read(1)
    var subpackets: seq[Packet[int]]
    if lengthType == 0:
      let subpacketLength = scanner.read(15)
      var totalLength = 0
      while totalLength < subpacketLength:
        let packet = scanner.parse
        subpackets.add(packet)
        totalLength += packet.length
    else:
      let numSubpackets = scanner.read(11)
      for _ in 1 .. numSubpackets:
        subpackets.add(scanner.parse)
    result = Packet[int](packetType: Operator, subpackets: subpackets,
        typeID: TypeID(typeID), version: version, length: scanner.pos - start)

func map[T, R](packet: Packet[T], operatorFn: (TypeID, openArray[R]) -> R,
    literalFn: Packet[T] -> R): R =
  case packet.packetType:
    of Literal: literalFn(packet)
    of Operator: operatorFn(packet.subpackets.mapIt(it.map(operatorFn, literalFn)))

proc solveWithComputeFn(bits: seq[int], computeFn: Packet[int] -> int): int =
  var scanner = newScanner(bits)
  let packet = scanner.parse
  return computeFn(packet)

method solvePart1Int*(this: Day16): int =
  func compute(p: Packet[int]): int =
    case p.packetType:
      of Literal: p.version
      of Operator: p.version + p.subpackets.map(compute).sum

  return solveWithComputeFn(this.bits, compute)

method solvePart2Int*(this: Day16): int =
  func compute(p: Packet[int]): int =
    case p.packetType:
      of Literal: result = p.value
      of Operator:
        let xs = p.subpackets.map(compute)
        result = case p.typeID:
          of Sum: sum(xs)
          of Product: prod(xs)
          of Minimum: min(xs)
          of Maximum: max(xs)
          of GreaterThan: int(xs[0] > xs[1])
          of LessThan: int(xs[0] < xs[1])
          of EqualTo: int(xs[0] == xs[1])

  return solveWithComputeFn(this.bits, compute)
