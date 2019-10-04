class Picture < ApplicationRecord
  belongs_to :target, polymorphic: true
end
