# frozen_string_literal: true

# name: chord-directory-plus
# about: A plugin to make it easy to explore and find users
# version: 0.1
# author: Tosin Sonuyi
# url: https://github.com/weallwegot/chord-directory-plus

enabled_site_setting :chord_directory_enabled

CHORD_DIRECTORY_SITE_SETTINGS = [
  "chord_directory_enabled",
  "chord_directory_interval_type",
  "chord_directory_interval_number",
  "chord_directory_ucfs"
].freeze

def chord_directory_require(path)
  require Rails.root.join('plugins', 'discourse-searchable-user-custom-fields', 'app', path).to_s
end

register_asset 'stylesheets/mingle.scss'
chord_directory_require 'extras/interval_options'

after_initialize do
  chord_directory_require 'controllers/admin/chord_directory_controller'
  chord_directory_require 'jobs/regular/index_user_search_data'
  chord_directory_require 'services/userfield_indexer'
  chord_directory_require 'services/scheduler'


  Discourse::Application.routes.append do
    namespace :admin, constraints: StaffConstraint.new do
      get  "chord_directory_indexing/scheduled"  => "chord_directory_indexing#scheduled"
      post "chord_directory_indexing/reschedule" => "chord_directory_indexing#reschedule"
    end
  end

  DiscourseEvent.on(:site_setting_changed) do |setting|
    if CHORD_DIRECTORY_SITE_SETTINGS.include?(setting.to_s)
      Rails.logger.info "Chord directory Setting #{setting} has been changed"
      SiteSetting.refresh!
      at = SiteSetting.chord_directory_interval_number.send(SiteSetting.chord_directory_interval_type).from_now
      Rails.logger.info "Chord directory Index Scheduled at #{at}"
      ChordDirectory::Scheduler.new.reschedule!(at: at)
    end
  end
end
