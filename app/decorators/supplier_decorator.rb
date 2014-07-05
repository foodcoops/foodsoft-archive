class SupplierDecorator < ApplicationDecorator
  delegate_all

  def email
    h.mail_to object.email
  end

  def url
    h.link_to object.url, object.url
  end

  def logo(version=nil)
    h.image_tag object.logo_url(version)
  end
  def logo_row
    h.image_tag object.logo_url(:row)
  end
  def logo_grid
    if object.logo
      h.image_tag object.logo_url(:grid) 
    else
      # @todo placeholder
      h.div style: 'width: 30px; height: 30px;'
    end
  end

end
