# frozen_string_literal: true

# name: discourse-chord-directory
# about: A plugin to make it easy to explore and find users
# version: 0.1
# author: Tosin Sonuyi
# url: https://github.com/discourse/discourse-chord-directory

enabled_site_setting :chord_directory_enabled

register_asset 'stylesheets/common/knowledge-explorer.scss'
register_asset 'stylesheets/mobile/knowledge-explorer.scss'

load File.expand_path('lib/chord_directory/engine.rb', __dir__)
load File.expand_path('lib/chord_directory/query.rb', __dir__)


# user search query
# DB.query("WITH ucf_name AS (SELECT CONCAT('user_field_',id) AS name FROM user_fields WHERE name = 'Ask Me About') SELECT u.id AS user_id FROM users u JOIN user_custom_fields ucf ON ucf.user_id = u.id WHERE ucf.name = (SELECT name from ucf_name) AND ucf.value ~* 'nipsey'")

#user_search.rb use that insted, as this is the topic search model
after_initialize do
  require_dependency 'user_search'

  if SiteSetting.chord_directory_enabled
    # check if UserSearch has a class called :advanced_filter ..
    # it does NOT
    if UserSearch.respond_to? :advanced_filter
      UserSearch.advanced_filter(/in:kb/) do |posts|

        selected_groups = SiteSetting.chord_directory_groups.split('|')
        if selected_groups
          group_ids = Group.where('name IN (?)', selected_groups).pluck(:id)
        end

        # users.where('group_id IN (?)', groups)

        posts.where('category_id IN (?) OR topics.id IN (SELECT DISTINCT(tt.topic_id) FROM topic_tags tt WHERE tt.tag_id IN (?))', categories, tags)
      end
    end

    users = User.where(active: true).where(staged: false)
    selected_groups = SiteSetting.chord_directory_groups.split('|')
    if selected_groups
      group_ids = Group.where('name IN (?)', selected_groups).pluck(:id)
      users = users.distinct.joins("INNER JOIN group_users ON group_users.user_id = users.id")
        .where("group_users.group_id IN (?)", group_ids)
    end

    # user_ids = DB.query("Select DISTINCT user_id from group_users gu where gu.id IN (?)", group_ids)
    # users = UserSearch.new(groups: group_ids, include_staged_users: true)

    users
  end
end
