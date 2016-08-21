# frozen_string_literal: true
require 'middleman_dato/meta_tags/title'
require 'middleman_dato/meta_tags/description'
require 'middleman_dato/meta_tags/image'
require 'middleman_dato/meta_tags/url'
require 'middleman_dato/meta_tags/robots'
require 'middleman_dato/meta_tags/og_locale'
require 'middleman_dato/meta_tags/og_type'
require 'middleman_dato/meta_tags/og_site_name'
require 'middleman_dato/meta_tags/article_modified_time'
require 'middleman_dato/meta_tags/article_publisher'
require 'middleman_dato/meta_tags/twitter_card'
require 'middleman_dato/meta_tags/twitter_site'

module MiddlemanDato
  class MetaTagsBuilder
    META_TAGS = [
      MetaTags::Title,
      MetaTags::Description,
      MetaTags::Image,
      MetaTags::Url,
      MetaTags::Robots,
      MetaTags::OgLocale,
      MetaTags::OgType,
      MetaTags::OgSiteName,
      MetaTags::ArticleModifiedTime,
      MetaTags::ArticlePublisher,
      MetaTags::TwitterCard,
      MetaTags::TwitterSite
    ].freeze

    def initialize(*args)
      @args = args
    end

    def meta_tags
      META_TAGS.map do |klass|
        klass.new(*@args).build
      end.flatten.compact.join("\n")
    end
  end
end
