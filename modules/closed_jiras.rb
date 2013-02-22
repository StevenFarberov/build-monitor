require 'active_support/all'
require_relative 'jira'

def fetch_closed_jiras()
  login()

  jql = 'updated >= "-3w" and assignee in (rharmon,pkhadloya, wcamarao,rmurthi, ajiang, asobiepanek, sfarberov) and status in(Resolved,Closed,Rejected)'

  $jira_service.issues_from_jql_search(jql).map do |jira|
    seconds = jira.create_time - 3.weeks.ago
    days = (seconds/86400).ceil
    {
        :relative_date => days
    }
  end
end