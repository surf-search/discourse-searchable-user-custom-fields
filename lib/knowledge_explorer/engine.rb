# frozen_string_literal: true

module ::ChordDirectory
  class Engine < ::Rails::Engine
    isolate_namespace ChordDirectory

    config.after_initialize do
      Discourse::Application.routes.append do
        mount ::ChordDirectory::Engine, at: '/docs'
        get '/chord-directory', to: redirect("/docs")
      end
    end
  end
end
