Gem::Specification.new do |spec|
  spec.name        = 'lec-dv'
  spec.licenses    = ['Apache-2.0']
  spec.summary     = 'An application that can be easily deployed and configured to export strongDM query logs'
  spec.description = 'The application acts as a syslog concentrator. Customers that want to export their strongDM query logs to a third party logging service can use the application to do so. They configure the application for the appropriate target. Deploy the application. Configure their strongDM gateways to logs to a syslog destination and set the destination to the address of the logging application host.'
  spec.authors     = ["StrongDM"]
  spec.homepage    = 'https://strongdm.github.io/log-export-container/'
  spec.metadata    = { "source_code_uri" => "https://github.com/strongdm/log-export-container" }
  spec.files       = ["create-conf.rb", "conf-utils.rb", "start.rb"] + Dir['fluentd/**/*.rb'] + Dir['fluentd/**/*.conf']
  spec.executables = ["log-export-container"]
  spec.version     = ENV['LEC_VERSION'] || '0.0.0'

  spec.add_dependency 'fluentd'
  spec.add_dependency 'fluent'
  spec.add_dependency 'fluent-plugin-rewrite-tag-filter'
  spec.add_dependency 'fluent-plugin-s3'
  spec.add_dependency 'fluent-plugin-cloudwatch-logs'
  spec.add_dependency 'fluent-plugin-splunk-hec'
  spec.add_dependency 'fluent-plugin-datadog'
  spec.add_dependency 'fluent-plugin-azure-loganalytics'
  spec.add_dependency 'fluent-plugin-sumologic_output'
  spec.add_dependency 'fluent-plugin-sanitizer'
  spec.add_dependency 'fluent-plugin-kafka'
  spec.add_dependency 'fluent-plugin-mongo'
  spec.add_dependency 'fluent-plugin-logzio'
  spec.add_dependency 'fluent-plugin-grafana-loki'
  spec.add_dependency 'fluent-plugin-remote_syslog'
  spec.add_dependency 'fluent-plugin-elasticsearch', '5.2.4'
  spec.add_dependency 'fluent-plugin-bigquery'
  spec.add_dependency 'fluent-plugin-prometheus'
  spec.add_dependency 'test-unit'
  spec.add_dependency 'rspec'
end
