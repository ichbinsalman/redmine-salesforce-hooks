require 'net/http'
require 'json'

module SalesforceRest
  module_function
  def get_token
    begin
        uri = URI('https://test.salesforce.com/services/oauth2/token/')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path)
        req.content_type = 'application/x-www-form-urlencoded'
        req.set_form_data('grant_type' => 'password', 'client_id' => Setting.plugin_salesforce['client_id'], 'client_secret' => Setting.plugin_salesforce['client_secret'], 'username' => Setting.plugin_salesforce['username'], 'password' => Setting.plugin_salesforce['password'])
        res = http.request(req)
        puts "response #{res.body}"
        return JSON.parse(res.body)
    rescue => e
        raise WorkflowError, "failed #{e} #{uri}"
    end
  end
end
