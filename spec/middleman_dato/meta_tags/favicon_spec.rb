require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

require 'pry'

module MiddlemanDato
  module MetaTags
    RSpec.describe Favicon do
      subject(:meta_tag) { described_class.new(builder, entity, theme_color) }
      let(:builder) { ::MockBuilder.new }
      let(:theme_color) { '#ffffff' }
      let(:application_name) { 'An app name' }
      let(:image_format) { 'image_format' }
      let(:entity) do
        double(
          'MiddlemanDato::JsonApiEntity',
          favicon: favicon,
          global_seo:  ActiveSupport::HashWithIndifferentAccess.new(
            site_name: application_name
          )
        )
      end
      let(:favicon) do
        ActiveSupport::HashWithIndifferentAccess.new(
          path: '/path/to/file',
          width: 1000,
          height: 1000,
          format: image_format,
          size: 10_000
        )
      end

      describe '#build_tags' do
        let(:result) { meta_tag.build_tags }

        it 'render the application-name' do
          meta = result.find { |t| t[0] == :meta && t[1][:name] == 'application-name' }
          expect(meta).to be_present
          expect(meta[1][:content]).to eq application_name
        end

        it 'render the theme-color' do
          meta = result.find { |t| t[0] == :meta && t[1][:name] == 'theme-color' }
          expect(meta).to be_present
          expect(meta[1][:content]).to eq theme_color
        end

        it 'render the msapplication-TileColor' do
          meta = result.find { |t| t[0] == :meta && t[1][:name] == 'msapplication-TileColor' }
          expect(meta).to be_present
          expect(meta[1][:content]).to eq theme_color
        end
      end

      describe '#image' do
        context 'when favicon is not present' do
          let(:favicon) { nil }

          it 'renders nil' do
            expect(meta_tag.image).to eq nil
          end
        end

        context 'else' do
          let(:image_obj) { double('MiddlemanDato::FieldType::Image', format: image_format) }

          it 'return the image parsed with MiddlemanDato::FieldType::Image' do
            allow(MiddlemanDato::FieldType::Image).to receive(:parse).and_return(image_obj)
            image = meta_tag.image
            expect(MiddlemanDato::FieldType::Image).to have_received(:parse)
              .with(favicon, nil)
            expect(image).to eq image_obj
          end
        end
      end

      describe '#url' do
        let(:image) { instance_double('MiddlemanDato::FieldType::Image', file: file) }
        let(:file) { instance_double('Imgix::Path') }
        let(:width) { 1 }
        let(:height) { 2 }

        let(:result) { meta_tag.url(width, height) }

        before do
          allow(meta_tag).to receive(:image).and_return(image)
          allow(file).to receive(:width).and_return(file)
          allow(file).to receive(:height).and_return(file)
          allow(file).to receive(:to_url)
          result
        end

        it 'generates the url for that size' do
          expect(meta_tag).to have_received(:image)
          expect(image).to have_received(:file)
          expect(file).to have_received(:width).with(width)
          expect(file).to have_received(:height).with(height)
          expect(file).to have_received(:to_url)
        end

        context 'without height' do
          let(:result) { meta_tag.url(width) }

          it 'call height with width value' do
            expect(file).to have_received(:height).with(width)
          end
        end
      end

      describe '#build_apple_icon_tags' do
        let(:result) { meta_tag.build_apple_icon_tags }
        let(:image_url) { '/path/to/image' }

        before do
          allow(meta_tag).to receive(:url).and_return(image_url)
          result
        end

        it 'render an apple-touch-icon link for each size' do
          described_class::APPLE_TOUCH_ICON_SIZES.each do |apple_icon_size|
            meta = result.find do |t|
              t[0] == :link &&
                t[1][:rel] == 'apple-touch-icon' &&
                t[1][:sizes] == "#{apple_icon_size}x#{apple_icon_size}"
            end

            expect(meta_tag).to have_received(:url).with(apple_icon_size)
            expect(meta).to be_present
            expect(meta[1][:href]).to eq image_url
          end
        end
      end

      describe '#build_apple_icon_tags' do
        let(:result) { meta_tag.build_icon_tags }
        let(:image) { instance_double('MiddlemanDato::FieldType::Image', format: format) }
        let(:format) { 'png' }
        let(:image_url) { '/path/to/image' }

        before do
          allow(meta_tag).to receive(:url).and_return(image_url)
          allow(meta_tag).to receive(:image).and_return(image)
          result
        end

        it 'render an icon link for each size' do
          described_class::ICON_SIZES.each do |icon_size|
            meta = result.find do |t|
              t[0] == :link &&
                t[1][:rel] == 'icon' &&
                t[1][:sizes] == "#{icon_size}x#{icon_size}"
            end

            expect(meta_tag).to have_received(:url).with(icon_size)
            expect(meta).to be_present
            expect(meta[1][:href]).to eq image_url
          end
        end
      end

      describe '#build_application_tags' do
        let(:result) { meta_tag.build_application_tags }
        let(:image) { instance_double('MiddlemanDato::FieldType::Image', format: format) }
        let(:format) { 'png' }
        let(:image_url) { '/path/to/image' }

        before do
          allow(meta_tag).to receive(:url).and_return(image_url)
          allow(meta_tag).to receive(:image).and_return(image)
          result
        end

        it 'render application meta for each size' do
          described_class::APPLICATION_SIZES.each do |size|
            meta = result.find do |t|
              t[0] == :meta &&
                t[1][:name] == "msapplication-square#{size}x#{size}logo"
            end
            expect(meta_tag).to have_received(:url).with(size)
            expect(meta).to be_present
            expect(meta[1][:content]).to eq image_url
          end
        end
      end
    end
  end
end
