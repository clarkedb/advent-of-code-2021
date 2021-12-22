# frozen_string_literal: true

if $PROGRAM_NAME == __FILE__
  filename = ARGV.first
  unless filename
    p 'No file provided'
    exit(1)
  end
  input = File.read(filename)

  left = ['<', '(', '{', '[']
  right = ['>', ')', '}', ']']
  error_points = { '>' => 25_137, ')' => 3, '}' => 1197, ']' => 57 }
  incomplete_points = { '<' => 4, '(' => 1, '{' => 3, '[' => 2 }

  error_scores = []
  incomplete_scores = []
  lines = input.split
  lines.each do |line|
    stack = []
    corrupt = false
    line.chars.each do |ch|
      if left.include?(ch)
        stack.push(ch)
      elsif right.include?(ch)
        top = stack.pop
        expected = right[left.find_index(top)]
        if ch != expected
          corrupt = true
          error_scores << error_points[ch]
          break
        end
      end
    end

    # check if incomplete
    next if corrupt || stack.length.zero?

    score = 0
    stack.length.times do
      score *= 5
      next_left = stack.pop
      score += incomplete_points[next_left]
    end
    incomplete_scores << score
  end

  winning_incomplete_score = incomplete_scores.sort[incomplete_scores.length / 2]
  p "Total syntax error score: #{error_scores.sum}"
  p "Winning autocomplete score: #{winning_incomplete_score}"
end
