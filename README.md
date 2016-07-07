# middleman-dato

[![Build Status](https://travis-ci.org/datocms/middleman-dato.svg?branch=master)](https://travis-ci.org/datocms/middleman-dato)

Middleman Dato is a Middleman extension to use the Middleman static site generator together with the API-driven DatoCMS, a fully customizable administrative backend for your static websites. 

This gem works for Middleman v3 and v4.

## Documentation and video tutorials

To learn more about DatoCMS and how you can use it with your Middleman website, head over to [our documentation](http://www.datocms.com/docs/) and [video tutorials](http://www.datocms.com/docs/tutorials/middleman_netlify/).

## Setup

```ruby
# config.rb

activate :dato,
  domain: 'lively-smoke-1134.admin.datocms.com',
  token: 'XXXYYY',
  base_url: 'http://www.mywebsite.com'

# feel free to use dato from now on:
#
# dato.articles.each do |article|
#   proxy "/articles/#{article.slug}.html", "/templates/article.html", locals: { article: article }
# end
```

## Middleman helpers

### `dato`

Using this helper you can access to any item stored in your site by item type. 
That is, if your site has an Item Type with `article` as API identifier, you can get 
the complete array of items with `dato.articles` (yep, the identifier pluralized). 

If a Item Type is marked as Singleton (ie. `about_page`) you don't need to pluralize and 
a call to `dato.about_page` directly returns the Item (or `nil`, if still hasn't been created
within the backend).

You can query any Item field value with a method called like the field API identifier.

If a Item Type has a String field with Title appeareance, than the item responds to `.slug`,
returning a slugified version of the title itself (or the item identifier, if the title is empty).

You can use this helper within Middleman `config.rb`, as well as within your views:

```ruby
<% dato.articles.each do |article| %>
  <div class="post">
    <h1><%= link_to article.title, "/articles/#{article.slug}.html" %></h1>
    <div>
      <%= article.main_content %>
    </div>
  </div>
<% end %>
```

Complex field types (ie. images, files, videos, SEO settings, etc.) implement specific methods 
you can use as well:

```ruby
article = dato.articles.first

article.cover_image.file.width(500).fit('crop').to_url
article.video.iframe_embed(800, 600)
```

Please [refer to the code](https://github.com/datocms/middleman-dato/tree/master/lib/middleman_dato/field_type) for more informations.

### `dato_meta_tags`

This helper takes any item with a SEO field and generates SEO, Facebook OpenGraph and Twitter card meta tags based on it:

```ruby
<%= dato_meta_tags(dato.homepage) %>
```

```html
<title>...</title>

<meta name="description" content="..."/>
<meta name="twitter:card" content="..." />
<meta name="twitter:description" content="..."/>
<meta name="twitter:image" content="..."/>
<meta name="twitter:site" content="..."/>
<meta name="twitter:title" content="..."/>
<meta name="twitter:url" content="..."/>

<meta property="og:description" content="..."/>
<meta property="og:image" content="..."/>
<meta property="og:locale" content="..." />
<meta property="og:site_name" content="..." />
<meta property="og:title" content="..."/>
<meta property="og:type" content="..." />
<meta property="og:url" content="..."/>

<link rel="canonical" href="..."/>
```

### `dato_favicon_meta_tags`

This helper generates meta tags based on the Favicon image specified within the Site:

```ruby
<%= dato_favicon_meta_tags(theme_color: '#D97C5F') %>
```

## Submitting a Pull Request

1. Fork it.
2. Create a branch (`git checkout -b some_bufix`)
3. Commit your changes (`git commit -am "Fix typos"`)
4. Push to the branch (`git push origin some_bugfix`)
5. Open a [Pull Request][1]
6. Enjoy a refreshing Diet Coke and wait

## Testing

To run the tests:

    $ rake

If nothing complains, congratulations!

[1]: http://github.com/datocms/middleman-dato/pulls
