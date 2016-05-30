require 'spec_helper'

module MiddlemanDato
  module MetaTags
    RSpec.describe Image do
      subject(:meta_tag) { described_class.new(builder, base_url, space, record) }
      let(:builder) { ::MockBuilder.new }
      let(:base_url) { nil }
      let(:space) { nil }
      let(:record) do
        double(
          'MiddlemanDato::Record',
          fields: [double('MiddlemanDato::JsonApiEntity', api_key: 'foo', field_type: 'image')],
          foo: image,
          singleton?: false
        )
      end

      let(:field) do
        { field_type: 'image' }
      end

      let(:image) do
        double(
          'MiddlemanDato::JsonApiEntity',
          width: 300,
          height: 300,
          file: double('File', format: double('Imgix', to_url: 'http://google.com'))
        )
      end

      describe '.value' do
        it 'returns the current locale' do
          expect(meta_tag.image).to eq 'http://google.com'
        end
      end
    end
  end
end
