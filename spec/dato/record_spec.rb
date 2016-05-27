module Dato
  RSpec.describe Record do
    subject(:record) { described_class.new(entity, repo) }
    let(:entity) do
      double(
        'Dato::JsonApiEntity(Record)',
        id: '14',
        content_type: content_type,
        title: "My titlè with àccents",
        body: 'Hi there',
        position: 2,
        updated_at: '2010-01-01T00:00'
      )
    end
    let(:repo) do
      instance_double('Dato::RecordsRepo')
    end
    let(:content_type) do
      double(
        'Dato::JsonApiEntity(Content Type)',
        singleton: is_singleton,
        api_key: 'work_item',
        fields: fields
      )
    end
    let(:is_singleton) { false }
    let(:fields) do
      [
        double(
          'Dato::JsonApiEntity(Field)',
          position: 1,
          api_key: 'title',
          localized: false,
          field_type: 'string',
          appeareance: { type: 'title' }
        ),
        double(
          'Dato::JsonApiEntity(Field)',
          position: 1,
          api_key: 'body',
          localized: false,
          field_type: 'text',
          appeareance: { type: 'plain' }
        )
      ]
    end

    describe '#slug' do
      context 'singleton' do
        let(:is_singleton) { true }

        it 'returns the parameterized content type api key' do
          expect(record.slug).to eq 'work-item'
        end
      end

      context 'non singleton, no title field' do
        let(:fields) { [] }

        it 'returns the ID' do
          expect(record.slug).to eq '14'
        end
      end

      context 'non singleton, title field' do
        it 'returns the ID + title' do
          expect(record.slug).to eq '14-my-title-with-accents'
        end
      end
    end

    describe '#attributes' do
      it 'returns an hash of the field values' do
        expected_attributes = {
          'title' => "My titlè with àccents",
          'body' => 'Hi there'
        }
        expect(record.attributes).to eq expected_attributes
      end
    end

    describe 'position' do
      it 'returns the entity position field' do
        expect(record.position).to eq 2
      end
    end

    describe 'updated_at' do
      it 'returns the entity updated_at field' do
        expect(record.updated_at).to be_a Time
      end
    end

    describe 'dynamic methods' do
      context 'existing field' do
        it 'returns the field value' do
          expect(record.respond_to?(:body)).to be_truthy
          expect(record.body).to eq 'Hi there'
        end

        context 'localized field' do
          let(:entity) do
            double(
              'Dato::JsonApiEntity(Record)',
              id: '14',
              content_type: content_type,
              title: { it: 'Foo', en: 'Bar' }
            )
          end

          let(:fields) do
            [
              double(
                'Dato::JsonApiEntity(Field)',
                position: 1,
                api_key: 'title',
                localized: true,
                field_type: 'string',
                appeareance: { type: 'plain' }
              )
            ]
          end

          it 'returns the value for the current locale' do
            I18n.with_locale(:it) do
              expect(record.title).to eq 'Foo'
            end
          end

          context 'non existing value' do
            it 'raises nil' do
              I18n.with_locale(:ru) do
                expect(record.title).to eq nil
              end
            end
          end
        end
      end

      context 'non existing field' do
        it 'raises NoMethodError' do
          expect(record.respond_to?(:qux)).to be_falsy
          expect { record.qux }.to raise_error NoMethodError
        end
      end

      context 'non existing field type' do
        let(:fields) do
          [
            double(
              'Dato::JsonApiEntity(Field)',
              position: 1,
              api_key: 'title',
              localized: true,
              field_type: 'rotfl'
            )
          ]
        end

        it 'raises RuntimeError' do
          expect { record.title }.to raise_error RuntimeError
        end
      end
    end

    context 'equality' do
      subject(:same_record) { described_class.new(entity, repo) }

      subject(:another_record) { described_class.new(another_entity, repo) }
      let(:another_entity) do
        double(
          'Dato::JsonApiEntity(Record)',
          id: '15'
        )
      end


      it 'two records are equal if their id is the same' do
        expect(record).to eq same_record
      end

      it 'else they\'re not' do
        expect(record).not_to eq another_record
        expect(record).not_to eq "foobar"
      end
    end
  end
end
