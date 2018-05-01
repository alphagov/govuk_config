module GovukHealthcheck
  STATUSES = [
    OK = "ok".freeze,
    WARNING = "warning".freeze,
    CRITICAL = "critical".freeze,
  ].freeze

  class Checkup
    # @param checks [Array] Array of objects/classes that respond to `run`
    def initialize(checks)
      @checks = checks
    end

    def run
      {
        status: worst_status,
        checks: component_statuses,
      }
    end

  private

    def component_statuses
      @component_statuses ||= @checks.each_with_object({}) do |check, hash|
        check_result = check.details.merge(status: check.status)
        check_result[:message] = check.message if check.respond_to?(:message)

        hash[check.name] = check_result
      end
    end

    def worst_status
      if status?(CRITICAL)
        CRITICAL
      elsif status?(WARNING)
        WARNING
      else
        OK
      end
    end

    def status?(status)
      component_statuses.values.any? {|s| s[:status] == status }
    end
  end
end
