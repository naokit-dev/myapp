module ArticlesHelper
  
  def guest_token
    SecureRandom.hex(4)
  end

end
