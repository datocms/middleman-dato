require 'middleman_dato/json_api_entity'

module MiddlemanDato
  RSpec.describe JsonApiEntity do
    subject(:object) { described_class.new(payload, data_source) }
    let(:payload) do
      {
        id: 'peter',
        type: 'person',
        attributes: {
          first_name: 'Peter',
          last_name: 'Griffin'
        },
        relationships: {
          children: {
            data: [
              { type: 'person', id: 'stewie' }
            ]
          },
          mother: {
            data: { type: 'person', id: 'thelma' }
          }
        }
      }
    end

    let(:data_source) do
      instance_double('MiddlemanDato::DataSource')
    end

    describe '#id' do
      it 'returns the object ID' do
        expect(object.id).to eq 'peter'
      end
    end

    describe '#type' do
      it 'returns the object type' do
        expect(object.type).to eq 'person'
      end
    end

    describe 'attributes' do
      it 'returns the attribute if it exists' do
        expect(object.respond_to?(:first_name)).to be_truthy
        expect(object.first_name).to eq 'Peter'
      end

      it 'returns NoMethodError if it doesnt' do
        expect(object.respond_to?(:foo_bar)).to be_falsy
        expect { object.foo_bar }.to raise_error NoMethodError
      end
    end

    describe '[]' do
      it 'returns the attribute if it exists' do
        expect(object[:first_name]).to eq 'Peter'
      end

      it 'returns nil if it doesnt' do
        expect(object[:foo_bar]).to be_nil
      end
    end

    describe '==' do
      context 'same id and type' do
        let(:other) do
          described_class.new({ id: 'peter', type: 'person' }, data_source)
        end

        it 'returns true' do
          expect(object == other).to be_truthy
        end
      end

      context 'different id and type' do
        let(:other) do
          described_class.new({ id: 'stewie', type: 'person' }, data_source)
        end

        it 'returns false' do
          expect(object == other).to be_falsy
        end
      end

      context 'different class' do
        let(:other) do
          12
        end

        it 'returns false' do
          expect(object == other).to be_falsy
        end
      end
    end

    describe 'links' do
      let(:stewie) { instance_double('MiddlemanDato::JsonApiObject') }
      let(:thelma) { instance_double('MiddlemanDato::JsonApiObject') }

      before do
        allow(data_source).to receive(:find_entity).with('person', 'stewie') { stewie }
        allow(data_source).to receive(:find_entity).with('person', 'thelma') { thelma }
      end

      context 'multiple linkages' do
        it 'returns the array of JsonApiObjects' do
          expect(object.children).to eq [stewie]
        end
      end

      context 'single linkage' do
        it 'returns the JsonApiObject' do
          expect(object.mother).to eq thelma
        end
      end

      it 'returns NoMethodError if it does not exist' do
        expect { object.father }.to raise_error NoMethodError
      end
    end
  end
end
