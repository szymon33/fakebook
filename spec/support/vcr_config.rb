require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost     = true
  c.cassette_library_dir = "spec/fixtures/http"
end
