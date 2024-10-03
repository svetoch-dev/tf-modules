{
  "displayName": "${display_name}",
  "dashboardFilters": [],
  "mosaicLayout": {
    "columns": ${columns},
    "tiles": [
      %{ for tile in tiles ~}
      {
        "xPos": ${tile.position.xpos},
        "yPos": ${tile.position.ypos},
        "width": ${tile.position.width},
        "height": ${tile.position.height},
        "widget" : {
          "title": "${tile.title}",
          %{ if tile.type == "logsPanel" ~}
          "logsPanel": {
            "filter": "${tile.filter}",
            "resourceNames": [
                "projects/${tile.project_id}",
              ]
          %{ endif ~}
          %{ if tile.type == "timeTable" ~}
          "timeSeriesTable": {
            %{ if tile.columns != null ~}
            "columnSettings": [
              %{ for column in tile.columns ~}
              {
                "alignment": "${column.alignment}",
                "column": "${column.column}",
                "visible": ${column.visible}
              },
              %{ endfor ~}
            ]
            %{ endif ~}
          %{ endif ~}
          %{ if tile.type == "xyChart" ~}
          "xyChart" : {  
            "chartOptions": {
              "mode": "${tile.chart_mode}"
            },
            "tresholds" : [
              %{ for treshold in tile.tresholds ~}
              ${treshold},
              %{ endfor ~}
            ],
            "yAxis" : {
              "label": "${tile.yaxis.label}",
              "scale": "${tile.yaxis.scale}"
            }
          %{ endif ~}
            "dataSets": [
              %{ for dataset in tile.datasets}
              {
                "breakdowns": [],
                "dimensions": [],
                "measures": [],
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
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
                      "groupByFields": ${dataset.filter.aggregation.labels},
                      "perSeriesAligner": "${dataset.filter.aggregation.aligner}"
                    },
                    %{ endif ~}
                    "filter": "${dataset.filter.query}",
                    %{ if dataset.filter.time_series_filter != null ~}
                    "pickTimeSeriesFilter": {
                      "direction": "${dataset.filter.time_series_filter.direction}",
                      "numTimeSeries": ${dataset.filter.time_series_filter.num_series},
                      "rankingMethod": "${dataset.filter.time_series_filter.ranking_method}"
                    }
                    %{ endif ~}
                  }
                  %{ endif ~}
                }
              },
              %{ endfor ~}
            ],
          }
        }
      },
      %{ endfor ~}
    ]
  }
}
