class SpiralMemory
  def initialize
    @nodes = Hash.new { |h, k| h[k] = {} }
  end

  def value(value)
    x, y = generate_graph_to_value(value)
    @nodes[x][y]
  end

  def value_larger_than(value)
    x, y = generate_graph_to_value(value, :larger_than)
    @nodes[x][y]
  end

  def steps(value)
    x, y = generate_graph_to_value(value)
    x.abs + y.abs
  end

  def generate_graph_to_value(value, set=nil)
    x = 0
    y = 0
    radius = 1
    direction = 1
    count = 1
    count_reached = false
    @nodes[x][y] = 1
    until count_reached
      count_reached = count == value

      while (!count_reached) && x * direction < radius
        count += 1
        x += direction
        node_value = add_node_with_value(x,y)
        if set && node_value > value
          count_reached = true
        elsif !set
          count_reached = count == value
        end
      end

      while (!count_reached) && y * direction < radius
        count += 1
        y += direction
        node_value = add_node_with_value(x,y)
        if set && node_value > value
          count_reached = true
        elsif !set
          count_reached = count == value
        end
      end

      direction = direction * -1

      while (!count_reached) && x * direction < radius
        count += 1
        x += direction
        node_value = add_node_with_value(x,y)
        if set && node_value > value
          count_reached = true
        elsif !set
          count_reached = count == value
        end
      end

      while (!count_reached) && y * direction < radius
        count += 1
        y += direction
        node_value = add_node_with_value(x,y)
        if set && node_value > value
          count_reached = true
        elsif !set
          count_reached = count == value
        end
      end

      radius += 1
      direction = direction * -1
    end
    [x,y]
  end

  def add_node_with_value(x,y)
    @nodes[x][y] =
      (@nodes[x+1][y] || 0) +
      (@nodes[x+1][y+1] || 0) +
      (@nodes[x][y+1] || 0) +
      (@nodes[x-1][y+1] || 0) +
      (@nodes[x-1][y] || 0) +
      (@nodes[x-1][y-1] || 0) +
      (@nodes[x][y-1] || 0) +
      (@nodes[x+1][y-1] || 0)
  end
end

puts SpiralMemory.new.steps(347991)
puts SpiralMemory.new.value_larger_than(347991)

require 'minitest/autorun'
require 'minitest/pride'

class SpiralMemoryTest < Minitest::Test
  def test_it_finds_manhattan_distance
    spiral_memory = SpiralMemory.new
    assert_equal 0, spiral_memory.steps(1)
    assert_equal 3, spiral_memory.steps(12)
    assert_equal 2, spiral_memory.steps(23)
    assert_equal 31, spiral_memory.steps(1024)
  end

  def test_it_returns_the_values
    assert_equal 1, SpiralMemory.new.value(1)
    assert_equal 1, SpiralMemory.new.value(2)
    assert_equal 2, SpiralMemory.new.value(3)
    assert_equal 4, SpiralMemory.new.value(4)
    assert_equal 5, SpiralMemory.new.value(5)
    assert_equal 11, SpiralMemory.new.value(7)
    assert_equal 59, SpiralMemory.new.value(13)
  end

  def test_it_returns_the_value_larger_than_given
    assert_equal 10, SpiralMemory.new.value_larger_than(5)
    assert_equal 304, SpiralMemory.new.value_larger_than(147)
  end
end
