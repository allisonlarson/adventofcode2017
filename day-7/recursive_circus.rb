class Node
  attr_reader :name
  attr_accessor :children, :weight, :parent, :unweighted
  def initialize(name: nil)
    @name = name
    @weight = 0
    @parent = nil
    @children = []
    @unweighted = false
  end

  REPOSITORY = []

  def self.find(program)
    REPOSITORY.find do |node|
      node.name == program
    end
  end

  def self.add_node(node)
    REPOSITORY << node
    node
  end

  def self.find_or_create(program_string, parent = nil)
    program, children = program_string.split("->")
    name, weight = program.split(" ")
    node = find(name) || add_node(Node.new(name: name))
    node.children += children.split(", ").map { |c| Node.find_or_create(c, node) } if children
    node.parent = parent if parent
    node.weight = weight.match(/\d+/).to_s.to_i if weight
    node
  end

  def amount
    if !children.empty?
      weight + children.map(&:amount).inject(:+)
    else
      weight
    end
  end

  def find_unweighted
    children.map(&:find_unweighted) unless children.empty?
    amounts = children.map(&:amount)
    if amounts.uniq.length > 1
      grouped_children = children.inject(Hash.new(0)) { |acc, child| acc[child.amount] += 1; acc }
      correct_weight = grouped_children.reject { |k,v| v == 1 }.keys.first
      problem_child = children.find { |c| c.amount != correct_weight }

      puts correct_weight - problem_child.children.map(&:amount).inject(:+)
    end
  end
end

input = ARGF.read
programs = input.split("\n")
nodes = programs.map { |program| Node.find_or_create(program) }
parent = nodes.find { |node| !node.parent }
puts parent.name
parent.find_unweighted
