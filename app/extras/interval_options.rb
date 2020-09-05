require "enum_site_setting"

module ChordDirectory
  class IntervalOptions < EnumSiteSetting
    def self.valid_value?(val)
      values.any? { |v| v[:value].to_s == val.to_s }
    end

    def self.values
      @values ||= [
        { name: 'chord_directory.interval_days', value: 'days' },
        { name: 'chord_directory.interval_weeks', value: 'weeks' },
        { name: 'chord_directory.interval_months', value: 'months' }
      ]
    end

    def self.translate_names?
      true
    end
  end
end
