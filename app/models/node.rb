class Node < ActiveRecord::Base
  belongs_to :owner
  belongs_to :parent, class_name: Node, foreign_key: :node_id
  has_many :children, class_name: Node, foreign_key: :node_id
  has_many :nodes

  def leaf?
    nodes.empty?
  end

  def root?
    parent.nil?
  end

  def pick_leaves(picked = [])
    if leaf?
      return picked << self
    end

    nodes.inject(picked) do |a, node|
      node.pick_leaves(a)
    end
  end
end
