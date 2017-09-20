require "statsd"
require "forwardable"

module GovukStatsd
  extend SingleForwardable
  def_delegators :client, :increment, :time, :gauge

  def self.client
    @statsd_client ||= begin
      statsd_client = ::Statsd.new("localhost")
      statsd_client.namespace = ENV["GOVUK_STATSD_PREFIX"].to_s
      statsd_client
    end
  end
end