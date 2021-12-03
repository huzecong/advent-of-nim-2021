type Solution* = ref object of RootObj

method solvePart1Int*(this: Solution): int {.base.} = 0
method solvePart1*(this: Solution): string {.base.} = $this.solvePart1Int

method solvePart2Int*(this: Solution): int {.base.} = 0
method solvePart2*(this: Solution): string {.base.} = $this.solvePart2Int
