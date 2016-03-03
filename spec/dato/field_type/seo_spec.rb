module Dato
  module FieldType
    RSpec.describe Seo do
      subject(:seo) { described_class.parse(attributes, nil) }
      let(:attributes) do
        {
          title: 'title',
          description: 'description',
          image: {
            path: '/foo.png',
            format: 'jpg',
            size: 4000,
            width: 20,
            height: 20
          }
        }
      end

      it 'responds to title, description and image methods' do
        expect(seo.title).to eq 'title'
        expect(seo.description).to eq 'description'
        expect(seo.image).to be_a Dato::FieldType::Image
        expect(seo.image.path).to eq '/foo.png'
        expect(seo.image.format).to eq 'jpg'
        expect(seo.image.size).to eq 4000
        expect(seo.image.width).to eq 20
        expect(seo.image.height).to eq 20
      end
    end
  end
end
