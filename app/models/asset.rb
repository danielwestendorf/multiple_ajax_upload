class Asset < ActiveRecord::Base
  named_scope :primary, :conditions => { :parent_id => nil }
  
  has_attachment :storage => :file_system,
                 :thumbnails => {:thumb => '150x150>'}
  
  validates_presence_of :filename, :message => "- Trying to upload nothing?" #keeps a new record from being saved without a filename
end
