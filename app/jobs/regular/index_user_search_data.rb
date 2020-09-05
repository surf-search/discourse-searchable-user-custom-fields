module Jobs
  class IndexUserSearchData < ::Jobs::Base
    sidekiq_options queue: :low

    def execute(args = {})
      return if !SiteSetting.chord_directory_enabled
      return log_no_index unless ucf_names.presence
      ::ChordDirectory::CustomFieldAdder.new(searchable_users).enable_searchable_ucfs(ucf_names)
    ensure
      at = SiteSetting.chord_directory_interval_number.send(SiteSetting.chord_directory_interval_type).from_now
      ::ChordDirectory::Scheduler.new.reschedule!(at: at)
    end

    private

    def ucf_names
      @ucf_names ||= UserField.where(name:SiteSetting.chord_directory_ucfs.split('|')).pluck(:id).map {|x| "user_field_#{x}"}
    end

    def searchable_users
      @searchable_users = User.where(active: true).where(staged: false)
    end

    def log_no_index
      Rails.logger.warn "No re-indexing of user search data occurred. Directory fields returned: #{ucf_names}"
    end
  end
end
