module Dato
  module FieldType
    RSpec.describe LatLon do
      subject(:latlon) { described_class.parse(attributes, nil) }
      let(:attributes) do
        {
          latitude: 12,
          longitude: 10
        }
      end

      it 'responds to latitude and longitude methods' do
        expect(latlon.latitude).to eq 12
        expect(latlon.longitude).to eq 10
      end
    end
  end
end
