require 'singleton'

module MiddlemanDato
  class Watcher
    include Singleton

    def initialize
      @site_id = nil
      @apps = []
      @watcher = nil
    end

    def watch(app, loader, site_id)
      @app = app
      @loader = loader

      if site_id != @site_id
        if @watcher && @watcher.connected?
          @apps = []
          @watcher.disconnect!
        end

        @apps = [ app.object_id ]
        @site_id = site_id
        @watcher = Dato::Watch::SiteChangeWatcher.new(site_id).connect do
          print "DatoCMS content changed, refreshing data..."
          @loader.load
          puts " done!"
          @app.sitemap.rebuild_resource_list!(:touched_dato_content)
        end
      else
        @apps[@apps.size - 1] = app.object_id
      end
    end

    def shutdown(app)
      if @watcher && @watcher.connected? && @apps == [ app.object_id ]
        @watcher.disconnect!
      end

      @apps.delete(app.object_id)
    end
  end
end
