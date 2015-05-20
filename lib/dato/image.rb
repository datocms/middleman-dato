module Dato
  class Image
    attr_reader :attributes

    def initialize(data)
      @attributes = data.with_indifferent_access
    end

    def url
      "http://dato-images.herokuapp.com/image/h_150/#{attributes[:path]}"
    end
  end
end
