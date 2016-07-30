class Cost < ActiveRecord::Base
  self.table_name = 'costs'

  scope :latest_two, lambda { |profile|
    where(profile: profile).order(time: :desc).limit(2)
  }

  def self.upsert(attr)
    cost = find_by(attr)
    create(attr) unless cost
  end
end
