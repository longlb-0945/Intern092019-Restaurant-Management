module Image
  def attach_image params
    if params[:user][:image].blank?
      if params[:action].eql? "create"
        image.attach(io: File.open(Rails.root
          .join("app", "assets", "images", default_image(params))),
          filename: default_image(params))
      end
    else
      image.attach params[:user][:image]
    end
  end

  def default_image params
    if params.keys.include? "user"
      "default_user.png"
    elsif params.keys.include? "category"
      "category.png"
    elsif params.keys.include? "product"
      "product_default.png"
    end
  end
end
