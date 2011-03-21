class ApiKey < ActiveRecord::Base
  belongs_to :user

  def user= u
    self.user_id = u.id
    unless self.value
      self.value = Digest::SHA2.hexdigest(u.id.to_s + u.name.to_s + Time.now.to_s)
    end
  end
end
