class Maze
  def initialize(jump: false)
    @jump = jump
  end

  def steps(maze)
    steps = 0
    instruction = 0

    while maze[instruction]
      current = maze[instruction]
      maze[instruction] += ((@jump && current >= 3) ? -1 : 1)
      instruction = current + instruction
      steps += 1
    end
    steps
  end
end

require "minitest/autorun"
require "minitest/pride"

class MazeTest < Minitest::Test
  def test_it_counts_steps
    assert_equal 5, Maze.new.steps([0, 3, 0, 1, -3])
  end

  def test_it_jumps_steps
    assert_equal 10, Maze.new(jump: true).steps([0, 3, 0, 1, -3])
  end
end

