# frozen_string_literal: true
require 'middleman-core'
require 'middleman_dato/middleman_extension'

Middleman::Extensions.register(:dato) do
  MiddlemanDato::MiddlemanExtension
end
