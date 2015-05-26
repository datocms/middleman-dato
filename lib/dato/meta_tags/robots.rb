require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class Robots < Base
      def build
        if no_index?
          builder.tag(:meta, name: "robots", content: "noindex")
        end
      end
    end
  end
end



