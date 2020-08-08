# frozen_string_literal: true

# name: discourse-chord-directory
# about: A plugin to make it easy to explore and find knowledge base-type articles in Discourse
# version: 0.1
# author: Justin DiRose
# url: https://github.com/discourse/discourse-chord-directory

enabled_site_setting :chord_directory_enabled

register_asset 'stylesheets/common/chord-directory.scss'
register_asset 'stylesheets/mobile/chord-directory.scss'

load File.expand_path('lib/chord_directory/engine.rb', __dir__)
load File.expand_path('lib/chord_directory/query.rb', __dir__)

after_initialize do
  require_dependency 'search'

  if SiteSetting.chord_directory_enabled
    if Search.respond_to? :advanced_filter
      Search.advanced_filter(/in:kb/) do |posts|
        selected_categories = SiteSetting.chord_directory_categories.split('|')
        if selected_categories
          categories = Category.where('id IN (?)', selected_categories).pluck(:id)
        end

        selected_tags = SiteSetting.chord_directory_tags.split('|')
        if selected_tags
          tags = Tag.where('name IN (?)', selected_tags).pluck(:id)
        end

        posts.where('category_id IN (?) OR topics.id IN (SELECT DISTINCT(tt.topic_id) FROM topic_tags tt WHERE tt.tag_id IN (?))', categories, tags)
      end
    end
  end
end
