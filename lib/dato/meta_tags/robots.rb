require 'dato/meta_tags/base'

module Dato
  module MetaTags
    class Robots < Base
      def build
        builder.tag(:meta, name: 'robots', content: 'noindex') if no_index?
      end
    end
  end
end
