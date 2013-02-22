class App.Issue extends Backbone.Model

class App.Issues extends Backbone.Collection
  model: App.Issue

  amount: =>
    Math.floor( $(window).outerHeight() / 76 ) - 2

  keepFetching: =>
    $.get "/issues/amount/#{@amount() * 2}.json", (issues) =>
      @reset(issues)
      setTimeout(@keepFetching.bind(this), App.config.jira_update_interval)

class App.IssuesView extends Backbone.View
  el: '#jira'

  initialize: =>
    @template = @$el.find('#issue-template').html()
    @template = "{{#issues}} #{@template} {{/issues}}"
    @collection.on 'reset', @render
    @collection.keepFetching()
    @$issues1 = @$el.find('#issues1')
    @$issues2 = @$el.find('#issues2')

  render: (issues) =>
    return unless issues?
    arr = issues.toArray()
    col1 = arr.splice(0, arr.length / 2)
    col2 = arr

    console.log(arr)

    issuesAttributes1 = { issues: col1.map (issue) -> issue.attributes }
    @$issues1.html Mustache.render @template, issuesAttributes1

    issuesAttributes2 = { issues: col2.map (issue) -> issue.attributes }
    @$issues2.html Mustache.render @template, issuesAttributes2