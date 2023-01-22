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

  def delete(value, root = @root)
    if root.nil?
      puts "Delete failed, value not contained in tree!"
      return
    end
    if value > root.data
      root.right = delete(value, root.right)
    elsif value < root.data
      root.left = delete(value, root.left)
    else
      if root.left.nil?
        tmp = root.right
        root = nil
        return tmp
      elsif root.right.nil?
        tmp = root.left
        root = nil
        return tmp
      else
        tmp = look_min(root.right)
        root.data = tmp.data
        root.right = delete(tmp.data, root.right)
      end
    end
    root
  end

  def look_min(root)
    tmp = root
    until tmp.left.nil?
      tmp = tmp.left
    end
    tmp
  end

  def find(value)
    tmp = @root
    until tmp.nil? || tmp.data == value
      tmp = tmp.left if value < tmp.data
      tmp = tmp.right if value > tmp.data
    end
    puts "Value not found." if tmp.nil?
    tmp
  end

  def level_order
    unless block_given?
      arr = []
      queue = [@root]
      until queue.empty?
        arr.push queue[0].data
        queue.push queue[0].left if !queue[0].left.nil?
        queue.push queue[0].right if !queue[0].right.nil?
        queue.shift
      end
      return arr
    end

    queue = [@root]
    until queue.empty?
      yield queue[0]
      queue.push queue[0].left if !queue[0].left.nil?
      queue.push queue[0].right if !queue[0].right.nil?
      queue.shift
    end
  end

  def preorder(root = @root, arr = [], &block)
    return if root.nil?

    block_given? ? block.call(root) : arr.push(root.data)
    preorder(root.left, arr, &block)
    preorder(root.right, arr, &block)
    arr
  end

  def inorder(root = @root, arr = [], &block)
    return if root.nil?

    inorder(root.left, arr, &block)
    block_given? ? block.call(root) : arr.push(root.data)
    inorder(root.right, arr, &block)
    arr
  end

  def postorder(root = @root, arr = [], &block)
    return if root.nil?

    postorder(root.left, arr, &block)
    postorder(root.right, arr, &block)
    block_given? ? block.call(root) : arr.push(root.data)
    arr
  end

  def height(root)
    return -1 if root.nil?

    left_branch = height(root.left)
    right_branch = height(root.right)
    return [left_branch, right_branch].max + 1
  end

  def depth(root)
    tmp = @root
    depth = 0
    until tmp == root
      tmp = tmp.left if root.data < tmp.data
      tmp = tmp.right if root.data > tmp.data
      depth += 1
    end
    depth
  end

  def balanced?
    l = self.height(@root.left)
    r = self.height(@root.right)
    ([l, r].max - [l, r].min) <= 1
  end

  def rebalance
    return if self.balanced?

    arr = self.inorder
    @root = self.build_tree(arr)
  end
end

tree = Tree.new([2, 5, 1, 1, 3, 8, 6, 7, 4, 9])

# tree.delete(3)

# node = tree.find(6)

# tree.level_order { |node| puts "My name is #{node.data}" }

# p tree.level_order

# tree.preorder { |node| puts "My name is #{node.data}" }

# p tree.preorder

# tree.inorder { |node| puts "My name isha #{node.data}" }

# p tree.inorder

# tree.postorder { |node| puts "My name is #{node.data}" }

# p tree.postorder

# p tree.height(node)

# p tree.depth(node)

tree.insert(10)

tree.insert(11)

tree.insert(12)

tree.rebalance

tree.pretty_print()

p tree.balanced?