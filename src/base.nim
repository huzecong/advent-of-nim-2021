type Solution* = ref object of RootObj

method solvePart1*(this: Solution): int {.base.} = 0
method solvePart2*(this: Solution): int {.base.} = 0
