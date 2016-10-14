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
      asset_path = '/assets/images'
      srcset = "#{asset_path}/#{image} 1x, #{asset_path}/#{image_2x} 2x"
      tag_options = options.merge(srcset: srcset)
      output = "<img "
      output += "src='#{asset_path}/#{image}' "
      tag_options.each do |k, v|
        output += "#{k}='#{v}' "
      end
      output += "/>"
    end
  end
end

Liquid::Template.register_tag('responsive_image_tag', Jekyll::ResponsiveImageTag)