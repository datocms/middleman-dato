require 'middleman-core'

Middleman::Extensions.register(:dato) do
  require 'middleman_dato/middleman_extension'
  MiddlemanDato::MiddlemanExtension
end
