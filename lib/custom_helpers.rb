module CustomHelpers
  def last_project?(project)
    project == data.projects.last
  end

  def reversible_grid(index)
    css = "grid"
    css.concat " grid--rev" if index.even?
    css
  end

  def responsive_image_tag(image, image_2x, options = {})
    srcset = "#{image_path(image)} 1x, #{image_path(image_2x)} 2x"
    image_tag image, options.merge(srcset: srcset)
  end

  def project_image_tag(image)
    responsive_image_tag "project/#{image}.png", "project/#{image}-2x.png"
  end

  def testimonial_image_tag(avatar)
    image_tag "project/testimonial/#{avatar}", class: 'quote-avatar'
  end

  def card_image_tag(avatar)
    image_tag "team/#{avatar}", class: 'card-avatar'
  end

  def link_to_github(nick)
    link_to "https://github.com/#{nick}" do
      %q(<i class="icon-github"></i>)
    end
  end

  def link_to_twitter(nick)
    link_to "https://twitter.com/#{nick}" do
      %q(<i class="icon-twitter"></i>)
    end
  end

  def ribbon(card)
    "ribbon" if card.player == "Łukasz Piestrzeniewicz"
  end
end
