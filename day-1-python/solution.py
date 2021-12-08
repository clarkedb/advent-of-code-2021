import numpy as np

def count_of_positive_deltas(arr):
  return np.sum(np.diff(arr) > 0)

def part1(input):
  return count_of_positive_deltas(input)

def part2(input):
  window_sums = (input + np.roll(input, -1) + np.roll(input, -2))[:-2]
  return count_of_positive_deltas(window_sums)

if __name__ == '__main__':
  input = np.loadtxt('./input.txt')
  sol_part_1 = part1(input)
  sol_part_2 = part2(input)

  print("1:", sol_part_1)
  print("2:", sol_part_2)
