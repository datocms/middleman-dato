require "spec_helper"

module Dato::MetaTags
  RSpec.describe Image do
    subject(:meta_tag) { described_class.new(builder, base_url, space, record) }
    let(:builder) { MockBuilder.new }
    let(:base_url) { nil }
    let(:space) { nil }
    let(:record) {
      double(
        "Record",
        fields: { foo: field },
        foo: image,
        singleton?: false
      )
    }

    let(:field) {
      { field_type: "image" }
    }

    let(:image) {
      double(
        "Field",
        attributes: { width: 300, height: 300 },
        file: double("File", format: double("Imgix", to_url: "http://google.com"))
      )
    }

    describe ".value" do
      it "returns the current locale" do
        expect(meta_tag.image).to eq "http://google.com"
      end
    end
  end
end
