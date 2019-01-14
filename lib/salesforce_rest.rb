require 'net/http'
require 'json'

module SalesforceRest
  module_function
  def get_token
    begin
        uri = URI('https://test.salesforce.com/services/oauth2/token')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path)
        req.set_form_data({'grant_type' => 'password', 'client_id' => Setting.plugin_salesforce['client_id'], 'client_secret' => Setting.plugin_salesforce['client_secret'], 'username' => Setting.plugin_salesforce['username'], 'password' => Setting.plugin_salesforce['password']})
        res = http.request(req)
        puts "response #{res.body}"
        return JSON.parse(res.body)['access_token']
    rescue => e
        raise WorkflowError, "failed #{e} #{uri}"
    end
  end

  module_function
  def update_project(project)
    logger = Logger.new(STDOUT)
    token_details = get_token()
    uri = URI.parse("#{token_details['instance_url']}/services/apexrest/redmine/project/#{project['id']}")
    request = Net::HTTP::Patch.new(uri)
    request["Authorization"] = "Bearer #{token_details['access_token']}"
    request.content_type = "application/json"
    request.body = JSON.dump({
      "REDMINE_Description__c" => project['description'],
      "REDMINE_Go_Live_Date__c" => project['go_live_date'],
      "REDMINE_Status__c" => project['status'],
      "Name" => project['name']
    })

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
