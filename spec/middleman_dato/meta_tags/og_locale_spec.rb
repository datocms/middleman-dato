require 'spec_helper'

module MiddlemanDato
  module MetaTags
    RSpec.describe OgLocale do
      subject(:meta_tag) { described_class.new(builder, base_url, space, record) }
      let(:builder) { ::MockBuilder.new }
      let(:base_url) { nil }
      let(:space) { nil }
      let(:record) { nil }

      describe '#value' do
        it 'returns the current locale' do
          I18n.with_locale(:it) do
            expect(meta_tag.value).to eq 'it_IT'
          end
        end
      end
    end
  end
end
