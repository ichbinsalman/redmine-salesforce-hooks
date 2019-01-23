require 'net/http'
require 'json'

module SalesforceRest
  module_function
  def get_token
    begin
        login_url = 'https://test.salesforce.com'
        if !Setting.plugin_redmine_salesforce_hooks['login_url'].nil? && !Setting.plugin_redmine_salesforce_hooks['login_url'].empty?
          login_url = Setting.plugin_redmine_salesforce_hooks['login_url']
        end
        uri = URI("#{login_url}/services/oauth2/token")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data({'grant_type' => 'password', 'client_id' => Setting.plugin_redmine_salesforce_hooks['client_id'], 'client_secret' => Setting.plugin_redmine_salesforce_hooks['client_secret'], 'username' => Setting.plugin_redmine_salesforce_hooks['username'], 'password' => Setting.plugin_redmine_salesforce_hooks['password']})
        res = http.request(req)
        return JSON.parse(res.body)
    rescue => e
        raise WorkflowError, "failed #{e} #{uri}"
    end
  end

  module_function
  def update_object(name, details)
    logger = Logger.new(STDOUT)
    token_details = get_token()
    uri = URI.parse("#{token_details['instance_url']}/services/apexrest/redmine/#{name}/#{details['id']}")
    request = Net::HTTP::Patch.new(uri)
    request["Authorization"] = "Bearer #{token_details['access_token']}"
    request.content_type = "application/json"
    request.body = details['data']

    logger.info("sending salesforce request")

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    logger.info(response.code)
    logger.info(response.body)
  end

  module_function
  def delete_object(name, id)
    logger = Logger.new(STDOUT)
    token_details = get_token()
    uri = URI.parse("#{token_details['instance_url']}/services/apexrest/redmine/#{name}/#{id}")
    request = Net::HTTP::Delete.new(uri)
    request["Authorization"] = "Bearer #{token_details['access_token']}"
    req_options = {
      use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    logger.info(response.code)
    logger.info(response.body)
  end
end
