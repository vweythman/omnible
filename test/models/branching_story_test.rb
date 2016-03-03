require 'test_helper'

class BranchingStoryTest < ActiveSupport::TestCase
  setup do
    @hope = works(:hope)
    @aqua = works(:aqua)
    @zinc = works(:zinc)
  end
  
  test "should count branchings" do
    puts
    puts @hope.branches.pluck(:title)
    @hope.branches.each do |branch|
      puts branch.parent_branchings.count
    end
    puts
    puts @hope.parent_branchings.count
    
  end

end
