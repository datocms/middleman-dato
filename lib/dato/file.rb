require "imgix"

module Dato
  class File
    attr_reader :attributes

    def initialize(data)
      @attributes = data.with_indifferent_access
    end

    def file
      @file ||= Imgix::Client.new(host: 'dato-images.imgix.net')
        .path(attributes[:path])
    end
  end
end
