module ChordDirectory
  class Scheduler
    def reschedule!(at:)
      unschedule!
      if SiteSetting.chord_directory_enabled
        Rails.logger.info "Rescheduling next user_search_data indexing for #{SiteSetting.chord_direcotry_interval_number} #{SiteSetting.chord_directory_interval_type} from now"
        Jobs.enqueue_at(at, :IndexUserSearchData)
        MessageBus.publish '/IndexUserSearchData', { at: at }
      else
        Rails.logger.info "Chord directory has been disabled, next re-indexing has not been scheduled"
      end
    end

    def unschedule!
      current_job&.delete
    end

    def current_job_time
      current_job&.at
    end

    private

    def current_job
      Sidekiq::ScheduledSet.new.detect { |j| j.item['class'] == 'Jobs::IndexUserSearchData' }
    end
  end
end
