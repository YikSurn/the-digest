class User < ActiveRecord::Base
  # Has many articles sent to user
  has_and_belongs_to_many :article

  # Able to tag interests
  acts_as_taggable_on :interests

  # Password
  has_secure_password

  # Validations
  validates_presence_of :email, :first_name, :last_name, :username
    validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/, message: "%{value} is not a valid email" }
    validates :first_name, format: { with: /[[[:alpha:]]\s]+/, message: "%{value} is not a valid first name" }, length: { maximum: 30 }
    validates :last_name, format: { with: /[[:alpha:]]+/, message: "%{value} is not a valid last name" }, length: { maximum: 30 }
    validates :username, uniqueness: true

  validates :password, length: { minimum: 6 }, :allow_blank => true

  # Find a user by username, then check the username is the same
  def self.authenticate username, password
    user = User.find_by(username: username)
    # Check if user exists
    if user
      # User exists, authenticate with password
      if user.authenticate(password)
        return user
      else
        return nil
      end
    else
      return nil
    end
  end

end
