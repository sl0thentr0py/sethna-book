require 'set'
require 'rmagick'
require 'pry'

class Network
  attr_accessor :neighbours

  def initialize
    @neighbours = {}
  end

  def has_node?(node)
    @neighbours.has_key?(node)
  end

  def add_node(node)
    @neighbours[node] ||= Set.new
  end

  def add_edge(node1, node2)
    return if node1 == node2
    @neighbours[node1] << node2
    @neighbours[node2] << node1
  end

  def nodes
    @neighbours.keys
  end

  def display_circle_graph(window_size: 600, window_margin: 0.02, dot_size: 3)
    img = Magick::Image.new(window_size, window_size)
    gc = Magick::Draw.new

    center = window_size / 2
    radius = (1.0 - 2 * window_margin) * window_size / 2.0
    len = nodes.size
    positions = {}

    nodes.sort.each do |node|
      theta = (2.0 * Math::PI * node) / len
      x = radius * Math.cos(theta) + center
      y = radius * Math.sin(theta) + center
      positions[node] = [x, y]
      gc.circle(x, y, x + dot_size, y)
    end

    nodes.each do |node|
      neighbours[node].each do |neighbour|
        next unless neighbour > node
        sx, sy = positions[node]
        ex, ey = positions[neighbour]
        gc.line(sx, sy, ex, ey)
      end
    end

    gc.draw(img)
    img.display
  end
end

class SmallWorldNetwork < Network
  def self.init(l, z, p)
    n = Network.new
    nodes = (0...l).to_a
    nodes.each { |i| n.add_node(i) }

    l.times do |i|
      (z / 2).times do |j|
        n.add_edge(i, (i + j + 1) % l)
        n.add_edge(i, (i - j - 1) % l)
      end
    end

    ((l * z * p) / 2.0).round.times do
      n.add_edge(nodes.sample, nodes.sample)
    end

    n
  end
end

n = SmallWorldNetwork.init(100, 10, 0.2)
n.display_circle_graph
