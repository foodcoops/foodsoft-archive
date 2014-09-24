class ArticleDecorator < ApplicationDecorator
  delegate_all

  def name
    h.link_to object.name, h.admin_article_path(object)
  end

  def price
    if object.price.price
      title = ["net #{h.number_to_currency object.price.price}"]
      title << "deposit #{h.number_to_currency object.price.deposit}" if object.price.deposit and object.price.deposit != 0
      title << "tax (#{h.number_to_percentage object.price.tax}) #{h.number_to_currency object.price.tax_price}" if object.price.tax and object.price.tax != 0
      title << "gross #{h.number_to_currency object.price.gross_price}"
    else
      title = []
    end
    h.content_tag :span, title: title.join(', ') do
      h.number_to_currency object.price.price
    end
  end

  # @todo waiting for bootstrap
  def price_with_tooltip
    tooltip  = h.content_tag :tr do
                 h.content_tag(:th, ArticlePrice.human_attribute_name(:price)) +
                 h.content_tag(:td, h.number_to_currency(object.price.price)) +
                 h.content_tag(:td, nil)
               end
    tooltip += h.content_tag :tr do
                 h.content_tag(:th, ArticlePrice.human_attribute_name(:deposit)) +
                 h.content_tag(:td, h.number_to_currency(object.price.deposit)) +
                 h.content_tag(:td, nil)
               end if object.price.deposit
    tooltip += h.content_tag :tr do
                 h.content_tag(:th, ArticlePrice.human_attribute_name(:tax)) +
                 h.content_tag(:td, h.number_to_currency(object.price.tax_price)) +
                 h.content_tag(:td, h.number_to_percentage(object.price.tax))
               end if object.price.tax
    tooltip += h.content_tag :tr do
                 h.content_tag(:th, ArticlePrice.human_attribute_name(:gross_price)) +
                 h.content_tag(:td, h.number_to_currency(object.price.gross_price)) +
                 h.content_tag(:td, nil)
               end
    tooltip = h.content_tag(:table, h.content_tag(:tbody, tooltip))
    h.content_tag :span, data: {title: tooltip, toggle: 'tooltip'} do
      h.number_to_currency object.price.price
    end
  end

  def url
    h.link_to object.url, object.url
  end

end
