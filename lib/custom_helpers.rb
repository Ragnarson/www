module CustomHelpers
  def last_project?(project)
    project == data.projects.last
  end

  def reversible_grid(index)
    css = "grid"
    css.concat " grid--rev" if index.even?
    css
  end

  def project_image_tag(image)
    image_tag "project/#{image}", class: 'thumbnail'
  end

  def testimonial_image_tag(avatar)
    image_tag "project/testimonial/#{avatar}", class: 'quote-avatar'
  end

  def card_image_tag(avatar)
    image_tag "team/#{avatar}", class: 'card-avatar'
  end

  def link_to_github(nick)
    link_to image_tag('icn-github.svg'), "https://github.com/#{nick}"
  end

  def link_to_twitter(nick)
    link_to image_tag('icn-twitter.svg'), "https://twitter.com/#{nick}"
  end

  def ribbon(card)
    "ribbon" if card.player == "Łukasz Piestrzeniewicz"
  end
end


