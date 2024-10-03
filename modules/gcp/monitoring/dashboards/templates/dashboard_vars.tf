locals {
  dashboards = [
    {
    display_name = "test dashboard",
    columns      = 48
    tiles        = [
      {
        position = {}
        type     = "xyChart"
        chart_model = "COLOR"
        datasets = [
          {
            promql = {
              query = "label_replace(\r\n  sum(rate(logging_googleapis_com:user_ConnectionErrorPOS{status_code=\"Connection error\"}[${__interval}])),\r\n  \"Connection_error\", \"Connection Error\", \"\", \"\"\r\n)",
            },
          },
          {
            promql = {
              query = "label_replace(\r\n  sum(rate(logging_googleapis_com:user_ConnectionErrorPOS{status_code!=\"Connection error\"}[${__interval}])),\r\n  \"Connection_error\", \"3хх/4xx/5xx http error\", \"\", \"\"\r\n)",
            },
          }
        ]
        yaxis = {}
      }
    ]
    }
  ]
}