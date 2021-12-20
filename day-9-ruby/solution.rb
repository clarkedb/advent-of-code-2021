# frozen_string_literal: true

def basin_size(data, low_point)
  counted = []
  i, j = low_point
  n = data[i][j]
  l = data.length
  m = data.first.length
  size = 0

  search = lambda do |x, y, prev|
    # beyond boundary
    return if x.negative? || y.negative? || x >= l || y >= m

    # check if consecutively increasing
    current = data[x][y]
    return unless current > prev && current < 9

    unless counted.include?([x, y])
      size += 1
      counted << [x, y]
    end

    # search left
    search.call(x - 1, y, current)

    # search right
    search.call(x + 1, y, current)

    # search up
    search.call(x, y - 1, current)

    # search down
    search.call(x, y + 1, current)
  end

  search.call(i, j, n - 1)

  size
end

if $PROGRAM_NAME == __FILE__
  filename = ARGV.first
  unless filename
    p 'No file provided'
    exit(1)
  end

  risk_level_total = 0

  low_points = []

  input = File.read(filename)
  data = input.split.map { |r| r.chars.map(&:to_i) }
  l = data.length
  m = data.first.length

  data.each_with_index do |r, i|
    r.each_with_index do |n, j|
      adj = [
        i > 0 ? data[i - 1][j] : 10,
        i < (l - 1) ? data[i + 1][j] : 10,
        j > 0 ? r[j - 1] : 10,
        j < (m - 1) ? r[j + 1] : 10
      ]
      next unless n < adj.min

      low_points << [i, j]
      risk_level = n + 1
      risk_level_total += risk_level
    end
  end

  p "Sum of risk levels: #{risk_level_total}"

  basin_sizes = low_points.map do |low_point|
    basin_size(data, low_point)
  end

  largest_basins_product = basin_sizes.sort.reverse[0..2].inject(:*)
  p "Product of three largest basin sizes: #{largest_basins_product}"
end
