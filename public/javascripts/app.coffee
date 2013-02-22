window.App = {}

$.get '/config.json', (config) ->
  App.config = config

  $ ->
    App.jobs = new App.Jobs
    App.jobsView = new App.JobsView(collection: App.jobs)
    App.jobsView.render()

    App.issues = new App.Issues()
    App.issuesView = new App.IssuesView(collection: App.issues)
    App.issuesView.render()

    App.openJiras = new App.OpenJiras()
    App.openJirasView = new App.OpenJirasView(collection: App.openJiras)
    App.openJirasView.render()

    App.closedJiras = new App.ClosedJiras()
    App.closedJirasView = new App.ClosedJirasView(collection: App.closedJiras)
    App.closedJirasView.render()