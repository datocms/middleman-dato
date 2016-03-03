require 'spec_helper'

module Dato
  module MetaTags
    RSpec.describe ArticleModifiedTime do
      subject(:meta_tag) { described_class.new(builder, base_url, space, record) }
      let(:builder) { ::MockBuilder.new }
      let(:base_url) { nil }
      let(:space) { nil }
      let(:record) do
        double('Record', updated_at: Time.now, singleton?: false)
      end

      describe '.value' do
        context 'if record is not singleton' do
          it 'returns an ISO 8601 time representation' do
            expect(meta_tag.value).not_to be_nil
          end
        end
      end
    end
  end
end
