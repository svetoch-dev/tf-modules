{
  "displayName": "${display_name}",
  "dashboardFilters": [],
  "mosaicLayout": {
    "columns": ${columns},
    "tiles": [
      %{ for idx, tile in jsondecode(tiles) ~}
      {
        %{ for posparam, value in tile.position ~}
        "${posparam}": ${value},
        %{ endfor ~}
        "widget" : {
          "title": "${tile.title}",
          %{ if tile.type == "logsPanel" ~}
          "logsPanel": {
            "filter": "${tile.logsPanel.filter}",
            "resourceNames": [
                %{ for ind_res, resource in tile.logsPanel.resourceNames ~} 
                "${resource}" %{ if ind_res != (length(tile.logsPanel.resourceNames)-1) ~}, %{ endif ~} 
                %{ endfor ~}
              ]
          %{ endif ~}
          %{ if tile.type == "timeTable" ~}
          "timeSeriesTable": {
            "metricVisualization": ${tile.metric_visual},
            %{ if tile.columns != null ~}
            "columnSettings": [
              %{ for ind_columns, column in tile.columns ~}
              {
                %{ if column.alignment != "" ~}
                "alignment": "${column.alignment}",
                %{ endif ~}
                "column": "${column.column}",
                "visible": "${column.visible}"
              } %{ if ind_columns != (length(tile.columns)-1) ~}, %{ endif ~}
              %{ endfor ~}
            ],
            %{ endif ~}
          %{ endif ~}
          %{ if tile.type == "xyChart" ~}
          "xyChart" : {  
            "chartOptions": {
              "mode": "${tile.chart_mode}"
            },
            %{ if tile.thresholds != [] ~}
            "thresholds" : [
              %{ for treshold in tile.thresholds ~}
              ${treshold},
              %{ endfor ~}
            ],
            %{ else ~}
            "thresholds": [],
            %{ endif ~}
            "yAxis" : {
              "label": "${tile.yaxis.label}",
              "scale": "${tile.yaxis.scale}"
            },
          %{ endif ~}
            %{ if tile.type != "logsPanel" ~}
            "dataSets": [
              %{ for index, dataset in tile.datasets}
              {
                %{ if tile.type != "timeTable" ~}
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "plotType": "LINE",
                "targetAxis": "Y1",
                %{ endif ~}
                "timeSeriesQuery": {
                  %{ if tile.type == "timeTable" ~}
                  "outputFullDuration": true,
                  %{ endif ~}
                  %{ if dataset.promql != null ~}
                  "prometheusQuery": "${dataset.promql.query}",
                  "unitOverride": "${dataset.promql.unit}"
                  %{ endif ~}
                  %{ if dataset.filter != null ~}
                  "timeSeriesFilter": {
                    %{ if dataset.filter.aggregation != null ~}
                    "aggregation": {
                      "alignmentPeriod": "${dataset.filter.aggregation.alighment_period}",
                      "crossSeriesReducer": "${dataset.filter.aggregation.reducer}",
                      "groupByFields": [ 
                        %{ for ind_lab, label in dataset.filter.aggregation.labels ~} 
                        "${label}" %{ if ind_lab != (length(dataset.filter.aggregation.labels)-1) ~}, %{ endif ~} 
                        %{ endfor ~} ],
                      "perSeriesAligner": "${dataset.filter.aggregation.aligner}"
                    },
                    %{ endif ~}
                    "filter": "${dataset.filter.query}" %{ if dataset.time_series_filter != null ~} ,
                    "pickTimeSeriesFilter": {
                      "direction": "${dataset.time_series_filter.direction}",
                      "numTimeSeries": ${dataset.time_series_filter.num_series},
                      "rankingMethod": "${dataset.time_series_filter.ranking_method}"
                    }
                    %{ endif ~}
                  }
                  %{ endif ~}
                }
              }%{ if index != (length(tile.datasets)-1) ~}, %{ endif ~}
              %{ endfor ~}
            ]
            %{ endif ~}
          }
        }
      }%{ if idx != (length(jsondecode(tiles))-1) ~}, %{ endif ~}
      %{ endfor ~}
    ]
  }
}
