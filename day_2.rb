class Solution
  def initialize(data)
    @data = data
    @reports = data.split("\n").map { |line| line.split.map { |c| c.strip.to_i } }
  end

  def part1
    num_safe = @reports.count { |report| safe?(report) }
    puts(num_safe)
  end

  def safe?(report)
    monotonic?(report) && valid_steps?(report)
  end

  def ascending?(report)
    report.each_cons(2).all? { |a, b| a < b }
  end

  def descending?(report)
    report.each_cons(2).all? { |a, b| a > b }
  end

  def monotonic?(report)
    ascending?(report) || descending?(report)
  end

  def valid_steps?(report)
    report.each_cons(2).all? do |a, b|
      diff = (a - b).abs
      diff.positive? && diff <= 3
    end
  end

  def part2
    unsafe_reports = @reports.reject { |report| safe?(report) }
    num_safe = @reports.length - unsafe_reports.length
    safe_with_dampener = unsafe_reports.count { |report| safe_with_dampener?(report) }
    puts(safe_with_dampener + num_safe)
  end

  def find_first_bad_jump(report)
    report.each_cons(2).find_index { |a, b| (a - b).abs.zero? || (a - b).abs > 3 }
  end

  def first_not_ascending(report)
    report.each_cons(2).find_index { |a, b| a > b }
  end

  def first_not_descending(report)
    report.each_cons(2).find_index { |a, b| a < b }
  end

  def safe_with_dampener?(report, recursive: true)
    first_bad_jump = find_first_bad_jump(report)
    first_idx_not_ascending = first_not_ascending(report)
    first_idx_not_descending = first_not_descending(report)
    return first_bad_jump.nil? && (first_idx_not_ascending.nil? || first_idx_not_descending.nil?) unless recursive

    # For each index that is bad, create a new report without that index and see if it is safe. For now, brute force
    # by also checking indexes that are +1 to the problem index and seeing if that fixes things.
    [
      first_bad_jump,
      first_bad_jump.nil? ? nil : first_bad_jump + 1,
      first_idx_not_descending,
      first_idx_not_descending.nil? ? nil : first_idx_not_descending + 1,
      first_idx_not_ascending,
      first_idx_not_ascending.nil? ? nil : first_idx_not_ascending + 1
    ].compact.map do |idx|
      report.reject.with_index do |_, i|
        i == idx
      end
    end.any? { |fixed_report| safe_with_dampener?(fixed_report, recursive: false) }
  end
end
