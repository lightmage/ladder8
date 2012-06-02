$ ->
  if $('#code').length > 0
    $('#code a').prop 'href', '/security/code?player=' + $('#player_nick').val()

  if $('#player_nick').length > 0
    $('#player_nick').observe_field 1, ->
      $('#code a').prop 'href', '/security/code?player=' + this.value

  if $('#chart-container').length > 0
    options =
      chart:
        backgroundColor: '#f5f5f5'
        defaultSeriesType: 'line'
        height: 250
        renderTo: 'chart-container'
      legend:
        enabled: false
      plotOptions:
        line:
          marker:
            enabled: false
            states:
              hover:
                enabled: true
                lineWidth: 2
                radius: 4
      series: [{color: '#0088cc'}]
      tooltip:
        crosshairs: true
        formatter: ->
          '<b>Game:</b> ' + this.x + ' <b>Rating:</b> ' + this.y.toFixed(3)
      title:
        text: null
      xAxis:
        allowDecimals: false
        title:
          text: null
      yAxis:
        allowDecimals: true
        title:
          text: null

    $.get $(location).attr('href') + '/ratings', (ratings) ->
      options.series[0].data = $.parseJSON(ratings)
      new Highcharts.Chart options
