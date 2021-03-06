class Job < ActiveRecord::Base
	validates_presence_of :company_name, :company_email, :type_id, :location_id, :title, :description, :how_to_apply
	validates_format_of :company_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"
	
	belongs_to :type
	belongs_to :location
	
	searchable_on :company_name, :title, :description, :how_to_apply, :location_name, :type_name #see http://github.com/wvanbergen/scoped_search/tree/master
	named_scope :recent, lambda { { :conditions => ['created_at > ?', 4.week.ago], :order => 'created_at DESC' } }
	
	before_save :set_action_key
	
	private
	
	def set_action_key
		self.action_key = ActiveSupport::SecureRandom.hex(16) if self.action_key.nil?
	end
end
