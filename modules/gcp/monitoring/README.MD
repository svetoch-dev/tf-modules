# Monitoring module

## Log metrics:
 - You can create metrics based on logs. Default value - []
## Dashboards:
 - You can create dashboard views based on logs and/or metrics. Default value - []
 - The dashboard is made up of tiles. There are 4 types of tiles available so far:
		 - xyChart - graph by metrics values or with promql Queries
		 - logsPanel  - Panel with logs and its own filter
		 - timeTable - Panel with values in the form of a table (e.g. can be used as top values)
 - Tiles are placed on the dashboard using xPos, yPos, width and hight. When columns = 48 (default) is specified, the X axis along which the tiles are placed is divided into 48 cells. Therefore, the horizontal placement can be from 0 to 48 (the value for xPos). Recommended parameters for tiles: width 12/24/48, height - 16/32. If the first tile has a height of 16 and a width of 24, the next tile should be placed either below it (xPos=0, yPos=16) or to the side of it (xPos=24, yPos=0). 
 - Shielding. If shielding is required (e.g. in a promql filter or query string), you must use 3x backslashes to shield “. 
 - Some parameters do not need to be used for some tile types. These comments are added to input.tf of the module
 - An example of filling in the variables can be found in the file monitoring_variables.example .
