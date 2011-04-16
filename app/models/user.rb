class User < ActiveRecord::Base
  has_many :api_keys
  has_many :authorizations
  has_many :snippets, :foreign_key => 'owner_id'
  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'], :nick => hash['user_info']['nickname'])
  end
end
