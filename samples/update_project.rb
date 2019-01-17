=begin

before project update:

@salesforce_update = changed? && !new_record?

after project update:

if @salesforce_update
  data = JSON.dump({
      "REDMINE_Description__c" => description,
      "Name" => name
    })
  details = {
    'id' => id,
    'data' => data
  }
  SalesforceRest.update_object('project', details)
end

=end
