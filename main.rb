require 'optparse'
require 'fileutils'
require 'dotenv/load'
require 'faraday'

class Main
  def run
    @options = {}
    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: main.rb DAY [options]'

      opts.on('-p', '--part PART', 'which day part to run') do |part|
        @options[:part] = part.to_i
      end
    end

    opt_parser.parse!(ARGV)
    @day = ARGV.shift
    if @day.nil?
      puts('Error: DAY is a required arguments')
      exit 1
    end

    setup_day
    run_day
  end

  private

  def setup_day
    day_file = "day_#{@day}.rb"
    inputs_day_file = "inputs/day_#{@day}.txt"
    FileUtils.cp('template.rb', day_file) unless File.exist?(day_file)
    return if File.exist?(inputs_day_file)

    resp = Faraday.get("https://adventofcode.com/2024/day/#{@day}/input") do |req|
      cookie_hash = { 'session': ENV['session'] }
      req.headers['Cookie'] = cookie_hash.map { |key, value| "#{key}=#{value}" }.join('; ')
    end
    File.write(inputs_day_file, resp.body)
  end

  def run_day
    require_relative("day_#{@day}")
    input = File.read("inputs/day_#{@day}.txt").strip
    solution = Solution.new(input)
    solution.part1 if !@options.key?(:part) || @options[:part] == 1
    solution.part2 if !@options.key?(:part) || @options[:part] == 2
  end
end

cli = Main.new
cli.run
