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
    css.concat " grid--rev" if index.odd?
    css
  end

  def project_image_tag(id)
    image_tag "project/#{id}.jpg"
  end

  def testimonial_image_tag(id)
    image_tag "project/testimonial/#{id}.jpg", class: 'quote__face'
  end

  def card_image_tag(id)
    image_tag "team/#{id}.jpg"
  end

  def link_to_github(nick)
    link_to image_tag('icn-github.svg'), "https://github.com/#{nick}"
  end

  def link_to_twitter(nick)
    link_to image_tag('icn-twitter.svg'), "https://twitter.com/#{nick}"
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
