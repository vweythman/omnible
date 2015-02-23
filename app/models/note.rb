class Note < ActiveRecord::Base
  belongs_to :work


  def main_title
    if title.empty?
      "Note"
    else
      title
    end
  end

  def self.null_state(work)
  	NullNote.new(work)
  end
end

class NullNote
  def initialize(work)
    @work = work
  end

  def main_title()
    "Notes about #{@work.main_title}"
  end

  def part_of
    :notes
  end

  def id
    nil
  end
end