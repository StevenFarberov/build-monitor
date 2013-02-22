class App.ClosedJira extends Backbone.Model

class App.ClosedJiras extends Backbone.Collection
  model: App.ClosedJira
  jiras_by_date: []

  keepFetching: =>
    $.get "/closed_jiras.json", (jiras) =>
      this.jiras_by_date = []
      for jira in jiras
        index = jira.relative_date
        if this.jiras_by_date[index] == null || typeof this.jiras_by_date[index] == 'undefined'
          this.jiras_by_date[index] = 1
        else
          this.jiras_by_date[index] = this.jiras_by_date[index] + 1

      $('#closed_graph').empty()
      @reset(jiras)
      setTimeout(@keepFetching.bind(this), App.config.jira_update_interval)

class App.ClosedJirasView extends Backbone.View

  initialize: =>
    @collection.on 'reset', @render
    @collection.keepFetching()

  render: =>
    index = 1
    sum = 0

    for amount in @collection.jiras_by_date
      if (index == 7 || index == 14)
        if (typeof amount != 'undefined')
          $('#closed_graph').append('<div class="bar" id="closed_bar" style="height: ' + (20 * amount) + 'px; margin:1px"></div>')
          sum += amount
        else $('#closed_graph').append('<div class="bar" id="closed_bar" style="margin: 1px"></div>')
        $('#closed_graph').append('<div class="divider"></div>')

      else if (typeof amount != 'undefined')
        $('#closed_graph').append('<div class="bar" id="closed_bar" style="height: ' + (20 * amount) + 'px"></div>')
        sum += amount
      else $('#closed_graph').append('<div class="bar" id="closed_bar" ></div>')
      index++

    $('#numClosed').text(' ' + sum)