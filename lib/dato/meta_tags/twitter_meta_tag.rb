require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class TwitterMetaTag < Base
      def buildable?
        false
      end

      def build
        builder.tag(:meta, name: name, content: value) if buildable?
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
