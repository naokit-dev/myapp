module ArticlesHelper

  def generate_guest_password
    SecureRandom.hex(4)
  end


end
