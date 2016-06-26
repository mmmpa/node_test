require 'rails_helper'

RSpec.describe Node, type: :model do
  before :all do
    @owner = create(:owner)
    @owner2 = create(:owner)
    @owner3 = create(:owner)

    @root = create(:node, owner: @owner, name: :root)
    @node = @root.nodes.create(owner: @owner, name: :node)
    @leaf1 = @root.nodes.create(owner: @owner, name: :leaf1)
    @leaf2 = @node.nodes.create(owner: @owner, name: :leaf2)
    @leaf3 = @node.nodes.create(owner: @owner, name: :leaf3)

    @root2 = create(:node, owner: @owner2, name: :root2)
    @node2 = @root2.nodes.create(owner: @owner2, name: :node2)
    @leaf2_1 = @root2.nodes.create(owner: @owner2, name: :leaf2_1)
    @leaf2_2 = @node2.nodes.create(owner: @owner2, name: :leaf2_2)
    @node2_2 = @node2.nodes.create(owner: @owner2, name: :node2_2)
    @leaf2_3 = @node2_2.nodes.create(owner: @owner2, name: :leaf2_3)

    @root3 = create(:node, owner: @owner3, name: :root3)

    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end

  xcontext 'method' do
    it { expect(@root.root?).to be_truthy }
    it { expect(@leaf1.leaf?).to be_truthy }
    it { expect(@leaf2.leaf?).to be_truthy }
    it { expect(@node.root?).to be_falsey }
    it { expect(@node.leaf?).to be_falsey }
    it { expect(@owner.root.name).to eq('root') }
  end

  context 'sql' do
    it { expect(@owner.leaves.pluck(:name)).to match_array(%w(leaf1 leaf2 leaf3)) }
    it { expect(@owner2.leaves.pluck(:name)).to match_array(%w(leaf2_1 leaf2_2 leaf2_3)) }
    it { expect(@owner3.leaves.pluck(:name)).to match_array(%w(root3)) }
  end

  context 'each' do
    it { expect(@owner.root.pick_leaves.map(&:name)).to match_array(%w(leaf1 leaf2 leaf3)) }
    it { expect(@owner2.root.pick_leaves.map(&:name)).to match_array(%w(leaf2_1 leaf2_2 leaf2_3)) }
    it { expect(@owner3.root.pick_leaves.map(&:name)).to match_array(%w(root3)) }
  end
end
