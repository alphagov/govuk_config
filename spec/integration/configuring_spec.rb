require "spec_helper"

RSpec.describe "Requiring govuk_app_config" do
  it "correctly initialises error tracking" do
    ClimateControl.modify SENTRY_CURRENT_ENV: "integration-or-somesuch", GOVUK_DATA_SYNC_PERIOD: "22:00-08:00" do
      require "govuk_app_config"

      expect(Raven.configuration.current_environment).to eql("integration-or-somesuch")
      expect { Raven.configuration.before_send.call("foo") }.not_to raise_error
      expect { Raven.configuration.transport_failure_callback.call("foo") }.not_to raise_error
    end
  end
end
