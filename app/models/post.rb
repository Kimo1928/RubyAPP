class Post < ApplicationRecord
    belongs_to :author, class_name: 'User', foreign_key: 'author_id'
    has_many :comments, dependent: :destroy
        
    
    validate :must_have_at_least_one_tag

    def must_have_at_least_one_tag
     if tags.blank? || tags.split(',').map(&:strip).reject(&:empty?).empty?
    errors.add(:tags, "must have at least one tag")
        end
    end

  end
  
