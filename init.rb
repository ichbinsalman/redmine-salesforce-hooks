require 'redmine'

require 'salesforce_rest'

Redmine::Plugin.register :salesforce do
  name 'Salesforce plugin'
  author 'Peak & Peak'
  description 'Plugin to connect to salesfroce rest services'
  version '1.0'
  url 'http://peakpeak.de'
  author_url 'http://peakpeak.de'
  settings partial: 'settings/salesforce', default: {}

end
