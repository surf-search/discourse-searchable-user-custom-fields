class Admin::ChordDirectoryController < ApplicationController
  def reschedule
    ChordDirectory::Scheduler.new.reschedule!(at: Time.zone.parse(params.require(:at)))
    render json: { success: :ok }
  end

  def scheduled
    respond_with_time
  end

  private

  def respond_with_time
    render json: { at: ChordDirectory::Scheduler.new.current_job_time }
  end
end
