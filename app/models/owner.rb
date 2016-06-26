class Owner < ActiveRecord::Base
  has_many :nodes

  def leaves
    nodes.includes(:nodes).references(:nodes).where(nodes_nodes: {id: nil})
  end

  def root
    nodes.find_by!(node_id: nil)
  end
end
