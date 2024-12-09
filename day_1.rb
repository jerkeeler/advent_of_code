class Solution
  def initialize(data)
    @data = data.split("\n").map { |line| line.split.map { |c| c.strip.to_i } }
    @list1 = @data.map(&:first)
    @list2 = @data.map(&:last)
  end

  def part1
    puts("Result part1: #{sum_of_distance}")
  end

  def sum_of_distance
    sorted1 = @list1.sort
    sorted2 = @list2.sort
    sorted1.zip(sorted2).sum { |a, b| (a - b).abs }
  end

  def part2
    puts("Result part2 #{similiarity}")
  end

  def similiarity
    tally = @list2.tally
    tally.default = 0
    @list1.map { |v| tally[v] * v }.sum
  end
end
