require "middleman-core"

Middleman::Extensions.register(:dato) do
  require "dato/middleman_extension"
  Dato::MiddlemanExtension
end
