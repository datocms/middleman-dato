require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class OgMetaTag < Base
      def buildable?
        false
      end

      def build
        if buildable?
          builder.tag(:meta, property: name, content: value)
        end
      end

      def name
        raise NotImplementedError
      end

      def value
        raise NotImplementedError
      end
    end
  end
end
