# frozen_string_literal: true

class ChordDirectoryConstraint
  def matches?(_request)
    SiteSetting.chord_directory_enabled
  end
end
