module ImagesHelper
  def can_delete_image?(image)
    signed_in? && current_user.profile_name == "omershwager"
  end
end
