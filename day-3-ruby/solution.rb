# frozen_string_literal: false

def detect_power_consumption(input)
  report = input.split
  l = report.first.length
  m = report.length / 2

  count = [0] * l
  report.each do |v|
    (0..l).each do |i|
      count[i] += 1 if v[i] == '1'
    end
  end

  bits = ''
  count.each do |c|
    bit = c > m ? '1' : '0'
    bits << bit
  end

  bit_mask = ('1' * l).to_i(2)
  gamma = bits.to_i(2)
  epsilon = (gamma ^ bit_mask)

  [epsilon, gamma]
end

def detect_life_support_rating(input)
  report = input.split
  oxygen = detect_rating(report, bit_criteria: 1).to_i(2)
  c02 = detect_rating(report, bit_criteria: 0).to_i(2)

  [oxygen, c02]
end

def detect_rating(report, bit_criteria:)
  i = 0
  search_values = report
  while search_values.length > 1
    ones = []
    zeros = []
    search_values.each do |v|
      if v[i] == '1'
        ones << v
      else
        zeros << v
      end
    end
    search_values = if bit_criteria == 1
                      ones.length >= zeros.length ? ones : zeros
                    else
                      zeros.length <= ones.length ? zeros : ones
                    end
    i += 1
  end

  search_values.first
end

if $PROGRAM_NAME == __FILE__
  input = File.read('./input.txt')
  epsilon, gamma = detect_power_consumption(input)
  oxygen, c02 = detect_life_support_rating(input)

  power_consumption = epsilon * gamma
  life_support_rating = oxygen * c02

  puts "power consumption: #{power_consumption}"
  puts "life support rating: #{life_support_rating}"
end
