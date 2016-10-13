module Jekyll
  module ProjectImageTagFilter
    def project_image_tag(image)
      asset_path = '/assets/images/project'
      srcset = "#{asset_path}/#{image}.png 1x, #{asset_path}/#{image}-2x.png 2x"
      output = "<img "
      output += "src='#{asset_path}/#{image}.png' "
      output += "srcset='#{srcset}' "
      output += "/>"
      return output
    end
  end
end

Liquid::Template.register_filter(Jekyll::ProjectImageTagFilter)
