module Jekyll
  class ResponsiveImageTag < Liquid::Tag
    def initialize(tag_name, input, tokens)
      super
      @input = input
    end

    def render(context)
      split_input = @input.split("|")
      image = split_input[0].strip
      image_2x = split_input[1].strip
      options = JSON.parse(split_input[2])
      srcset = "/assets/images/#{image} 1x, /assets/images/#{image_2x} 2x"
      tag_options = options.merge(srcset: srcset)
      asset_path = '/assets/images/'
      # output = "image_tag #{image}, #{tag_options}"
      output = "<img "
      output += "src='#{asset_path}/#{image}' "
      tag_options.each do |k, v|
        output += "#{k}='#{v}' "
      end
      output += "/>"
      # <img src="/assets/images/ragnar.png" srcset="/assets/images/ragnar.png 1x, /assets/images/ragnar-2x.png 2x">
      # Render it on the page by returning it
      return output;
    end
  end
end

Liquid::Template.register_tag('responsive_image_tag', Jekyll::ResponsiveImageTag)