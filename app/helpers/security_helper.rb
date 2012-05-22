module SecurityHelper
  def previous_tag
    hidden_field_tag :previous, params[:previous].blank? ? request.fullpath : params[:previous]
  end
end
