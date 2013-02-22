# Model

class App.OpenJira extends Backbone.Model

# Collection

class App.OpenJiras extends Backbone.Collection
  model: App.OpenJira
  jiras_by_date: []

  keepFetching: =>
    $.get "/open_jiras.json", (jiras) =>
      this.jiras_by_date = []
      for jira in jiras
        index = jira.relative_date
        if this.jiras_by_date[index] == null || typeof this.jiras_by_date[index] == 'undefined'
          this.jiras_by_date[index] = 1
        else
          this.jiras_by_date[index] = this.jiras_by_date[index] + 1

      $('#open_graph').empty()
      @reset(jiras)
      setTimeout(@keepFetching.bind(this), App.config.jira_update_interval)

    $.get "/all_open_jiras.json", (result) =>
      $('#totalOpen').text(" " + result.amount)

# View

class App.OpenJirasView extends Backbone.View

  initialize: =>
    @collection.on 'reset', @render
    @collection.keepFetching()

  render: =>
    sum = 0
    index = 1

    for amount in this.collection.jiras_by_date
      if (index == 7 || index == 14)
        if (typeof amount != 'undefined')
          $('#open_graph').append('<div class="bar" id="open_bar" style="height: ' + (20 * amount) + 'px; margin:1px"></div>')
          sum += amount
        else $('#open_graph').append('<div class="bar" id="open_bar" style="margin: 1px"></div>')
        $('#open_graph').append('<div class="divider"></div>')

      else if (typeof amount != 'undefined')
        $('#open_graph').append('<div class="bar" id="open_bar" style="height: ' + (20 * amount) + 'px"></div>')
        sum += amount
      else $('#open_graph').append('<div class="bar" id="open_bar" ></div>')
      index++

    $('#recentOpen').text(" " + sum)

