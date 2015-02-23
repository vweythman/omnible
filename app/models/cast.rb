class Cast < ActiveRecord::Base
  belongs_to :work

  has_many :memberships
  has_many :characters, through: :memberships
  accepts_nested_attributes_for :memberships, :allow_destroy => true

  def main_title
  	"#{self.work.title}: #{self.title}"
  end

  def main_characters
  end

  def side_characters
  end

  def self.null_state
    NullCast.new
  end
end

class NullCast
  def id
    nil
  end

  def main_title(work)
    "Cast Pages for #{work.main_title}"
  end

  def part_of
    :casts
  end
end
