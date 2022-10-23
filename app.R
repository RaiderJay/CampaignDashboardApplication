#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#


#install.packages("shinydashboard")
#install.packages("sys")
#install.packages("plotly")
#install.packages("vistime")
#install.packages("curl")

library("shiny")
library("shinydashboard")
library("sys")
library("plotly")
library("vistime")


df <- read.csv("./data/TestDataCamplan.csv")
df$start_date <- as.Date(df$start_date, format = "%Y-%m-%d")
df$end_date <- as.Date(df$end_date, format = "%Y-%m-%d" )

winDF <- df[which(df$LOE == "Win"),]
peopleDF <- df[which(df$LOE == "People"),]
innovateDF <- df[which(df$LOE == "Innovate"),]


opApproach = vistime(df, col.event = "IMO_Name", col.group = "LOE", title = "OP Approach", col.start = "start_date", col.end = "end_date")
PeopleApproach = vistime(peopleDF, col.event = "IMO_Name", col.group = "Sub_LOE", title = "OP Approach: People", col.start = "start_date", col.end = "end_date")
WinApproach = vistime(winDF, col.event = "IMO_Name", col.group = "Sub_LOE", title = "OP Approach: Win", col.start = "start_date", col.end = "end_date")
InnovateApproach = vistime(innovateDF, col.event = "IMO_Name", col.group = "Sub_LOE", title = "OP Approach: Innovate", col.start = "start_date", col.end = "end_date")

Qrt1Speed <- plot_ly(
  domain = list(x = c(0, 1), y = c(0, 1)),
  value = 4,
  title = list(text = "Quarter 1 FY 23 IMO Performance"),
  type = "indicator",
  mode = "gauge+number+delta",
  delta = list(reference = 0),
  gauge = list(
    axis =list(range = list(NULL, 10)),
    bar = list(color = "darkblue"),
    steps = list(
      list(range = c(0, 3), color = "red"),
      list(range = c(3, 7), color = "orange"),
      list(range = c(7, 10), color = "green")),
    threshold = list(
      line = list(color = "red", width = 4),
      thickness = 0.75,
      value = 4))) 

ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
  dashboardSidebar(
    actionButton("Dashboard","Dashboard"),
    actionButton("DataInput","Data Input")
  ),
  dashboardBody( 
    tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")),
    tabsetPanel(
      tabPanel(h4("Campaign Overview"),
               tabsetPanel(
                 tabPanel("Operational Approach",
                          opApproach,
                          sliderInput("DatesMerge","Dates:",
                                      min = Sys.Date() - 30,
                                      max = as.Date("2024-10-01","%Y-%m-%d"),
                                      value= c(Sys.Date(),Sys.Date() + 180),
                                      timeFormat="%Y-%m-%d")
                 ),
                 tabPanel("Assesments",
                          #tags$img(src = "/images/300.jpeg", alt = "logo"),
                          Qrt1Speed)
               )),
      tabPanel(h4("People LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: People",
                          PeopleApproach
                 ),
                 tabPanel("People: Assesments")
               )),
      tabPanel(h4("Win LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: Win",
                          WinApproach
                 ),
                 tabPanel("Win: Assesments")
               )),
      tabPanel(h4("Innovate LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: Innovate",
                          InnovateApproach
                 ),
                 tabPanel("Innovate: Assesments")
               ))
    )
  )
)

server <- function(input, output) {
}


shinyApp(ui, server)