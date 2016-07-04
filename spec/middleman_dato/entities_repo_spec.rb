require 'middleman_dato/json_api_entity'

module MiddlemanDato
  RSpec.describe EntitiesRepo do
    subject(:source) { described_class.new(payload) }

    describe '#entities' do
      context 'a payload with a data key' do
        context 'object' do
          let(:payload) do
            { data: { id: 'bar', type: 'item' } }
          end

          it 'inserts the object into entities' do
            expect(source.entities['item']['bar']).to be_a JsonApiEntity
          end
        end

        context 'array' do
          let(:payload) do
            { data: [{ id: 'bar', type: 'item' }] }
          end

          it 'inserts the objects into entities' do
            expect(source.entities['item']['bar']).to be_a JsonApiEntity
          end
        end
      end

      context 'a payload with an included key' do
        let(:payload) do
          { included: [{ id: 'bar', type: 'item' }] }
        end

        it 'inserts the objects into entities' do
          expect(source.entities['item']['bar']).to be_a JsonApiEntity
        end
      end
    end
  end
end
