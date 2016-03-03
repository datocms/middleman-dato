space = Dato::Space.new(
  domain: 'admin.cucistorie.it',
  api_host: 'http://127.0.0.1:3001',
  token: 'xZqr1G8vRFOMnLe9ofn7w4Yr590SKhxjZ46v4tw1WXc'
)

space.refresh!
puts space.records_repo.creations.size
puts space.records_repo.creations.first.attributes.inspect
puts space.records_repo.creations.first.name
puts space.records_repo.creations.first.slug
puts space.records_repo.creations.first.cover_image.file.to_url
