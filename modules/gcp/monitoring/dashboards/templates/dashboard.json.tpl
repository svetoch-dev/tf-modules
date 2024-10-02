{
  "displayName": "${display_name}",
  "gridLayout": {
    "columns": ${columns},
    "widgets": [
      %{ for widget in widgets ~}
      {
        "title": "${widget.title}",
        %{ if widget.type == "xyChart" ~}
        "xyChart": {
          "dataSets": [{
            %{ if widget.promql != "" ~}
            "timeSeriesQuery": {
              "prometheusQuery": "${widget.promql}"
            },
            %{ else ~}
            "timeSeriesFilter": {
              "filter": "${widget.filter}",
              "aggregation": {
                "perSeriesAligner": "ALIGN_RATE"
              }
            },
            %{ endif ~}
            "plotType": "${widget.plot_type}"
          }],
          "yAxis": {
            "label": "${widget.y_axis_label}",
            "scale": "${widget.scale}"
          }
        }
        %{ elseif widget.type == "timeSeriesTable" ~}
        "timeSeriesTable": {
          "columnSettings": [
            %{ for column in widget.columns ~}
            {
              "column": "${column.name}",
              "visible": ${column.visible}
            }
            %{ if length(widget.columns) != 1 ~}, %{ endif ~}
            %{ endfor ~}
          ],
          "dataSets": [{
            "timeSeriesQuery": {
              "timeSeriesFilter": {
                "filter": "${widget.filter}",
                "aggregation": {
                  "perSeriesAligner": "ALIGN_RATE"
                }
              }
            }
          }]
        }
        %{ elseif widget.type == "logsPanel" ~}
        "logsPanel": {
          "filter": "${widget.filter}"
        }
        %{ endif ~}
      }
      %{ if length(widgets) != 1 ~}, %{ endif ~}
      %{ endfor ~}
    ]
  }
}
