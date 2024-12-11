class Solution
  def initialize(data)
    @data = data
    @lines = data.split("\n")
  end

  def part1
    pattern = /mul\((\d{1,3}),(\d{1,3})\)/
    all_matches = @data.scan(pattern)
    multiplied = all_matches.map { |x, y| x.to_i * y.to_i }.sum
    puts(multiplied)
  end

  def part2
    pattern = /mul\((\d{1,3}),(\d{1,3})\)/
    operations = []
    offset = 0
    while match = @data.match(pattern, offset)
      operations << { match: match[0], index: match.begin(0), x: match[1].to_i, y: match[2].to_i }
      offset = match.end(0)
    end

    do_dont_pattern = /do(?:n't)?\(\)/
    do_donts = []
    offset = 0
    while match = @data.match(do_dont_pattern, offset)
      do_donts << { match: match[0], index: match.begin(0), enable: !match[0].include?("don't") }
      offset = match.end(0)
    end

    sum = 0
    enable = true
    next_do_dont = do_donts.shift
    until operations.empty?
      current_operation = operations.shift
      if !next_do_dont.nil? && current_operation[:index] > next_do_dont[:index]
        enable = next_do_dont[:enable]
        next_do_dont = do_donts.shift
      end

      sum += current_operation[:x] * current_operation[:y] if enable
    end

    puts(sum)
  end
end
