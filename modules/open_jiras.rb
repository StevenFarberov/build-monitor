require 'active_support/all'
require_relative 'jira'

def fetch_all_open_jiras()
  login()

  jql = "assignee in (rharmon, pkhadloya, sfarberov, wcamarao, rmurthi, ajiang, asobiepanek, sfarberov) AND status not in (Resolved, Closed, Rejected)"


  {:amount => $jira_service.issues_from_jql_search(jql).length}
end

def fetch_open_jiras()
  login()

  jql = 'created >= "-3w" and assignee in (rharmon, pkhadloya, wcamarao, rmurthi, ajiang, asobiepanek, sfarberov) AND status not in (Resolved, Closed, Rejected)'

  $jira_service.issues_from_jql_search(jql).map do |jira|
    seconds = jira.create_time - 3.weeks.ago
    days = (seconds/86400).ceil
    {
        :relative_date => days
    }
  end
end