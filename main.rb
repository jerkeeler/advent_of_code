require 'optparse'
require 'fileutils'
require 'dotenv/load'
require 'faraday'
require 'nokogiri'

class Main
  def run
    @options = { example: false }
    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: main.rb DAY [options]'

      opts.on('-p', '--part PART', 'which day part to run') do |part|
        @options[:part] = part.to_i
      end

      opts.on('-e', '--example', 'whether to run the example or not') do
        @options[:example] = true
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
    FileUtils.cp('template.rb', day_file) unless File.exist?(day_file)
    save_example_file unless File.exist?("inputs/day_#{@day}_example.txt")
    save_input_file unless File.exist?("inputs/day_#{@day}.txt")
  end

  def save_example_file
    resp = Faraday.get("https://adventofcode.com/2024/day/#{@day}")
    doc = Nokogiri::HTML(resp.body)
    File.write("inputs/day_#{@day}_example.txt", doc.at_css('pre code').text)
  end

  def save_input_file
    resp = Faraday.get("https://adventofcode.com/2024/day/#{@day}/input") do |req|
      cookie_hash = { 'session': ENV['session'] }
      req.headers['Cookie'] = cookie_hash.map { |key, value| "#{key}=#{value}" }.join('; ')
    end
    File.write("inputs/day_#{@day}.txt", resp.body)
  end

  def run_day
    require_relative("day_#{@day}")
    input_file = @options[:example] ? "inputs/day_#{@day}_example.txt" : "inputs/day_#{@day}.txt"
    input = File.read(input_file).strip
    solution = Solution.new(input)
    solution.part1 if !@options.key?(:part) || @options[:part] == 1
    solution.part2 if !@options.key?(:part) || @options[:part] == 2
  end
end

cli = Main.new
cli.run
