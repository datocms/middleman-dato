require 'middleman_dato/items_repo'

module MiddlemanDato
  RSpec.describe ItemsRepo do
    subject(:repo) { described_class.new(entities_repo) }
    let(:entities_repo) do
      instance_double('MiddlemanDato::EntitiesRepo')
    end
    let(:item_type) do
      double('MiddlemanDato::JsonApiEntity', api_key: 'post', singleton: false)
    end
    let(:singleton_item_type) do
      double('MiddlemanDato::JsonApiEntity', api_key: 'homepage', singleton: true)
    end
    let(:item_entity) do
      double('MiddlemanDato::JsonApiEntity', item_type: item_type)
    end
    let(:singleton_item_entity) do
      double('MiddlemanDato::JsonApiEntity', item_type: singleton_item_type)
    end
    let(:item) do
      instance_double('MiddlemanDato::Item', id: '14')
    end
    let(:singleton_item) do
      instance_double('MiddlemanDato::Item', id: '22')
    end

    before do
      allow(entities_repo).to receive(:find_entities_of_type).with('item_type') do
        [item_type, singleton_item_type]
      end

      allow(entities_repo).to receive(:find_entities_of_type).with('item') do
        [item_entity, singleton_item_entity]
      end

      allow(Item).to receive(:new).with(item_entity, anything) do
        item
      end

      allow(Item).to receive(:new).with(singleton_item_entity, anything) do
        singleton_item
      end
    end

    describe '#find' do
      it 'returns the specified item' do
        expect(repo.find('14')).to eq item
        expect(repo.find('22')).to eq singleton_item
      end
    end

    describe 'item_types' do
      describe 'singleton' do
        it 'returns the associated item' do
          expect(repo.respond_to?(:homepage)).to be_truthy
          expect(repo.homepage).to eq singleton_item
        end
      end

      describe 'non-singleton' do
        it 'returns the associated items' do
          expect(repo.respond_to?(:posts)).to be_truthy
          expect(repo.posts).to eq [item]
        end
      end

      describe 'non existing content types' do
        it 'returns NoMethodError' do
          expect(repo.respond_to?(:foobars)).to be_falsy
          expect { repo.foobars }.to raise_error NoMethodError
        end
      end
    end

    describe ItemsRepo::ItemCollection do
      subject(:collection) { described_class.new(items) }
      let(:items) do
        [foo]
      end

      let(:foo) { double('MiddlemanDato::Item', id: '1', name: 'Foo') }

      describe '#[]' do
        it 'returns the item with the specified id or index' do
          expect(collection['1']).to eq foo
          expect(collection[0]).to eq foo
        end
      end

      describe '#keys' do
        it 'returns the list of ids' do
          expect(collection.keys).to eq ['1']
        end
      end

      describe '#each' do
        context 'with arity == 2' do
          it 'iterates with id and item' do
            collection.each do |a, b|
              expect(a).to eq '1'
              expect(b).to eq foo
            end
          end
        end

        context 'with arity != 2' do
          it 'iterates just like a regular array' do
            collection.each do |a|
              expect(a).to eq foo
            end
          end
        end
      end

      it '#values' do
        expect(collection.values).to eq [foo]
      end

      it '#sort_by' do
        expect(collection.sort_by(&:name)).to eq [foo]
      end
    end
  end
end
