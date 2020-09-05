module Jobs
  class IndexUserSearchData < ::Jobs::Base
    sidekiq_options queue: :low

    def execute(args = {})
      return if !SiteSetting.chord_directory_enabled
      return log_no_index unless directory_fields.presence
      ::ChordDirectory::CustomFieldAdder.new(users).add_custom_fields_to_user_search_data(directory_fields)
    ensure
      at = SiteSetting.chord_directory_interval_number.send(SiteSetting.chord_directory_interval_type).from_now
      ::ChordDirectory::Scheduler.new.reschedule!(at: at)
    end

    private

    def directory_fields
      @directory_fields ||= UserField.where(name:SiteSetting.chord_directory_ucfs.split('|')).pluck(:id).map {|x| "user_field_#{x}"}
    end

    def users
      @users = User.where(active: true).where(staged: false)
    end

    def log_no_index
      Rails.logger.warn "No re-indexing of user search data occurred. Directory fields returned: #{directory_fields}"
    end
  end
end
