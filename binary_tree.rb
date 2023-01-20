class Node
  attr_accessor :data, :left, :right
  
  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :arr, :root

  def initialize(array)
    @arr = array.sort.uniq
    @root = self.build_tree(@arr)
  end

  def build_tree(sorted_array)
    return nil if sorted_array.empty?

    mid = sorted_array.length / 2
    root = Node.new(sorted_array[mid])
    root.left = build_tree(sorted_array[...mid])
    root.right = build_tree(sorted_array[mid + 1...])

    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    tmp = @root
    loop do
      if value > tmp.data
        if tmp.right.nil?
          tmp.right = Node.new(value)
          break
        else
          tmp = tmp.right
        end
      else
        if tmp.left.nil?
          tmp.left = Node.new(value)
          break
        else
          tmp = tmp.left
        end
      end
    end
  end
end

tree = Tree.new([2, 5, 1, 1, 6, 7, 4, 9])

tree.insert(8)

tree.pretty_print()