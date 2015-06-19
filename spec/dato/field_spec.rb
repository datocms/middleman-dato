require "spec_helper"

RSpec.describe Dato::Field do
  describe ".value" do
    let(:attribute) { "bar" }
    let(:field) { { field_type: "text" } }

    it "returns the field value" do
      expect(described_class.value(attribute, field)).to eq("bar")
    end

    context "if the field is marked to be localizable" do
      let(:field) { { field_type: "text", localized: true } }

      before do
        allow(I18n).to receive(:locale).and_return("en")
      end

      context "if it has a translation for the current locale" do
        let(:attribute) { { en: "baz" } }

        it "returns the field value translation" do
          expect(described_class.value(attribute, field)).to eq("baz")
        end
      end

      context "else" do
        let(:attribute) { { fr: "baz" } }

        it "returns nil" do
          expect(described_class.value(attribute, field)).to be_nil
        end
      end
    end

    describe "field types" do
      let(:client) { double("Client") }

      before do
        allow(Dato::Client).to receive(:new).and_return(client)
        allow(client).to receive(:records).and_return(data: [
          {
            id: 1,
            attributes: {},
            links: {
              content_type: {
                linkage: {
                  id: "foo",
                  type: "content_type"
                }
              }
            }
          }
        ])
        allow(client).to receive(:space).and_return(
          data: {
            links: {
              content_types: {
                linkage: [
                  {
                    id: "foo",
                    type: "content_type"
                  }
                ]
              }
            }
          },
          included: [
            {
              attributes: {
                name: "foo",
                singleton: false
              },
              id: "foo",
              links: {
                fields: {
                  linkage: []
                },
                singleton_record: {
                  linkage: nil
                }
              },
              type: "content_type"
            }
          ]
        )

        Dato::Repo.instance.connection_options = {}
        Dato::Repo.instance.sync!
      end

      [
        { type: "image", value: {}, result: Dato::Fields::File.new({}) },
        { type: "file", value: {}, result: Dato::Fields::File.new({}) },
        { type: "date", value: "2015-06-09", result: Date.new(2015, 6, 9) },
        { type: "seo", value: {}, result: Dato::Fields::Seo.new({}) },
        { type: "belongs_to", value: 1, result: Dato::Record.new({ id: 1 }, fields: {}) }
      ].each do |data|
        context "if the field has '#{data[:type]}' type" do
          let(:attribute) { data[:value] }
          let(:field) { { field_type: data[:type] } }

          it "converts the value to the specific type" do
            expect(described_class.value(attribute, field)).to eq(data[:result])
          end
        end
      end
    end
  end
end
