class Chapter < ActiveRecord::Base
  belongs_to :work

  def main_title
    if title.empty?
      "#{work.title} | Chapter #{self.position}"
    else
      "#{work.title} | #{title}"
    end
  end

  def simple_title
    current_title = "Chapter #{self.position}"
    current_title.concat " - #{self.title}" unless title.empty?
    current_title
  end

  def prev
    @prev.nil? ? 
      @prev = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position - 1)).first :
      @prev
  end

  def next
    @next.nil? ? 
      @next = Chapter.where("work_id = ? AND position = ?", self.work_id, (self.position + 1)).first :
      @next
  end

  def self.null_state(work)
    NullChapters.new(work)
  end
end

class NullChapters
  def initialize(work)
    @work = work
  end

  def main_title()
    "Chapters of #{@work.main_title}"
  end

  def part_of
    :chapters
  end

  def id
    nil
  end
end