class Folder < ActiveRecord::Base   
  
  validates_presence_of :name

  validates_presence_of :slug
  validates_format_of :slug, :with => %r{^([-_A-Za-z0-9]*|/)$}
  validates_uniqueness_of :slug, :scope => :parent_id

  has_many :assets, :dependent => :destroy

  acts_as_tree :order => "name"

  belongs_to :created_by,
             :class_name => "User",
             :foreign_key => "created_by"
  belongs_to :updated_by,
             :class_name => "User",
             :foreign_key => "updated_by"
end
