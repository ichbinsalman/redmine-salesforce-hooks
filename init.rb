require 'redmine'

require 'salesforce_rest'

Redmine::Plugin.register :redmine_salesforce_hooks do
  name 'Salesforce plugin'
  author 'Peak & Peak'
  description 'Plugin to connect salesforce rest services'
  version '1.0'
  url 'http://peakpeak.de'
  author_url 'http://peakpeak.de'
  settings partial: 'settings/redmine_salesforce_hooks', default: {}

end
