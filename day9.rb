class StreamProcessor
  attr_reader :score, :garbage_score
  def initialize(stream)
    @is_garbage = false
    @ignore_char = false
    @nesting = 0
    @score = 0
    @garbage_score = 0
    process_stream(stream)
  end

  private

  def process_stream(stream)
    stream.chars.each do |char|
      if @ignore_char
        @ignore_char = false
        next
      end

      case char
      when "!" then @ignore_char = true
      when "{" then open_group
      when "}" then close_group
      when "<" then open_garbage
      when ">" then close_garbage
      else count_char
      end
    end
  end

  def open_group
    count_char
    return if @is_garbage
    @nesting += 1
  end

  def close_group
    count_char
    return if @is_garbage
    @score += @nesting
    @nesting -= 1
  end

  def open_garbage
    count_char
    @is_garbage = true
  end

  def close_garbage
    @is_garbage = false
  end

  def count_char
    @garbage_score += 1 if @is_garbage
  end
end

require "minitest/autorun"
require "minitest/pride"

class StreamProcessorTest < Minitest::Test
  def test_it_scores_groups
    assert_equal 1, StreamProcessor.new("{}").score
    assert_equal 6, StreamProcessor.new("{{{}}}").score
    assert_equal 5, StreamProcessor.new("{{},{}}").score
    assert_equal 16, StreamProcessor.new("{{{},{},{{}}}}").score
  end

  def test_it_scores_groups_without_garbage
    assert_equal 1, StreamProcessor.new("{<a>,<a>,<a>,<a>}").score
    assert_equal 9, StreamProcessor.new("{{<ab>},{<ab>},{<ab>},{<ab>}}").score
    assert_equal 9, StreamProcessor.new("{{<!!>},{<!!>},{<!!>},{<!!>}}").score
    assert_equal 3, StreamProcessor.new("{{<a!>},{<a!>},{<a!>},{<ab>}}").score
  end

  def test_it_scores_garbage
    assert_equal 0, StreamProcessor.new("<>").garbage_score
    assert_equal 17, StreamProcessor.new("<random characters>").garbage_score
    assert_equal 3, StreamProcessor.new("<<<<>").garbage_score
    assert_equal 2, StreamProcessor.new("<{!>}>").garbage_score
    assert_equal 0, StreamProcessor.new("<!!>").garbage_score
    assert_equal 0, StreamProcessor.new("<!!!>>").garbage_score
    assert_equal 10, StreamProcessor.new("<{o\"i!a,<{i<a>").garbage_score
  end
end

stream_processor = StreamProcessor.new(File.read("./inputs/day9.txt"))
puts stream_processor.score
puts stream_processor.garbage_score
