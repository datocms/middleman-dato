require 'dato/records_repo'

module Dato
  RSpec.describe RecordsRepo do
    subject(:repo) { described_class.new(entities_repo) }
    let(:entities_repo) do
      instance_double('Dato::EntitiesRepo')
    end
    let(:content_type) do
      double('Dato::JsonApiEntity', api_key: 'post', singleton: false)
    end
    let(:singleton_content_type) do
      double('Dato::JsonApiEntity', api_key: 'homepage', singleton: true)
    end
    let(:record_entity) do
      double('Dato::JsonApiEntity', content_type: content_type)
    end
    let(:singleton_record_entity) do
      double('Dato::JsonApiEntity', content_type: singleton_content_type)
    end
    let(:record) do
      instance_double('Dato::Record', id: '14')
    end
    let(:singleton_record) do
      instance_double('Dato::Record', id: '22')
    end

    before do
      allow(entities_repo).to receive(:find_entities_of_type).with('content_type') do
        [content_type, singleton_content_type]
      end

      allow(entities_repo).to receive(:find_entities_of_type).with('record') do
        [record_entity, singleton_record_entity]
      end

      allow(Record).to receive(:new).with(record_entity, anything) do
        record
      end

      allow(Record).to receive(:new).with(singleton_record_entity, anything) do
        singleton_record
      end
    end

    describe '#find' do
      it 'returns the specified record' do
        expect(repo.find('14')).to eq record
        expect(repo.find('22')).to eq singleton_record
      end
    end

    describe 'content_types' do
      describe 'singleton' do
        it 'returns the associated record' do
          expect(repo.respond_to?(:homepage)).to be_truthy
          expect(repo.homepage).to eq singleton_record
        end
      end

      describe 'non-singleton' do
        it 'returns the associated records' do
          expect(repo.respond_to?(:posts)).to be_truthy
          expect(repo.posts).to eq [record]
        end
      end

      describe 'non existing content types' do
        it 'returns NoMethodError' do
          expect(repo.respond_to?(:foobars)).to be_falsy
          expect { repo.foobars }.to raise_error NoMethodError
        end
      end
    end

    describe RecordsRepo::RecordCollection do
      subject(:collection) { described_class.new(items) }
      let(:items) do
        [foo]
      end

      let(:foo) { double('Dato::Record', id: '1', name: 'Foo') }

      describe '#[]' do
        it 'returns the record with the specified id or index' do
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
          it 'iterates with id and record' do
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
