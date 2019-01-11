require 'net/http'
require 'json'

module SalesforceRest
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def get_token
      begin
          uri = URI('https://test.salesforce.com/services/oauth2/token/')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path)
          req.content_type = 'application/x-www-form-urlencoded'
          req.set_form_data('grant_type' => 'password', 'client_id' => '', 'client_secret' => '', 'username' => '', 'password' => '')
          res = http.request(req)
          puts "response #{res.body}"
          return JSON.parse(res.body)
      rescue => e
          raise WorkflowError, "failed #{eabc} #{uri}"
      end
    end
  end
end
