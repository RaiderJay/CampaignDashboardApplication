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
source("./IO.R")



print(TestCampdata)

winDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Win"),]
peopleDF <- TestCampdata[which(TestCampdata$IMO_LOE == "People"),]
innovateDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Innovate"),]

opApproach = vistime(TestCampdata, col.event = "IMO_Name", col.group = "IMO_LOE", title = "OP Approach", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
PeopleApproach = vistime(peopleDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: People", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
WinApproach = vistime(winDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Win", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
InnovateApproach = vistime(innovateDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Innovate", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")

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
                 tabPanel("Assesments"
                          #tags$img(src = "/images/300.jpeg", alt = "logo"),
                          #TotalSpeed,
                          #box(qrt1Speed), box(qrt2Speed), 
                          #box(qrt3Speed), box(qrt4Speed)
                          )
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
