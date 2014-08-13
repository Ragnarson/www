activate :livereload
activate :autoprefixer

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

helpers do
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
    image_tag "project/testimonial/#{avatar}", class: 'quote__face'
  end

  def card_image_tag(avatar)
    image_tag "team/#{avatar}", class: 'card__avatar'
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

  def captcha_answer_tag
    "<input id=\"captcha-answer\" name=\"captcha_answer\" type=\"text\" size=\"10\" class=\"one-whole\" placeholder=\"four characters from captcha image\"/>"
  end

  def captcha_image_tag
    captcha_session = rand(9000) + 1000
    "<input name=\"captcha_session\" type=\"hidden\" value=\"#{captcha_session}\"/>\n" +
    "<img id=\"captcha-image\" src=\"http://captchator.com/captcha/image/#{captcha_session}\"/>"
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
  deploy.strategy = :force_push
end
