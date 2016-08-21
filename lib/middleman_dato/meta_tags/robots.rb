# frozen_string_literal: true
require 'middleman_dato/meta_tags/base'

module MiddlemanDato
  module MetaTags
    class Robots < Base
      def build
        builder.tag(:meta, name: 'robots', content: 'noindex') if no_index?
      end
    end
  end
end
