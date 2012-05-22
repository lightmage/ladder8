require 'image'

class Avatar < Image
  def Avatar.directory
    super 'avatars'
  end
end
