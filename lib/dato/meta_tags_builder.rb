require "dato/meta_tags/title"
require "dato/meta_tags/description"
require "dato/meta_tags/image"
require "dato/meta_tags/url"
require "dato/meta_tags/robots"
require "dato/meta_tags/og_locale"
require "dato/meta_tags/og_type"
require "dato/meta_tags/og_site_name"
require "dato/meta_tags/article_modified_time"
require "dato/meta_tags/article_publisher"
require "dato/meta_tags/twitter_card"
require "dato/meta_tags/twitter_site"

module Dato
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
    ]

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
