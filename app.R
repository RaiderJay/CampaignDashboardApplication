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
#library("plotly")
library("vistime")
library("rhandsontable")
library("highcharter")
source("./IO.R")

#print(TestCampdata)
#save_data(TestCampdata,"./data/test.json")
#TestCampdata <- read_data("./data/test.json")

winDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Win"),]
peopleDF <- TestCampdata[which(TestCampdata$IMO_LOE == "People"),]
innovateDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Innovate"),]

opApproach <- vistime(TestCampdata, col.tooltip= "IMO_Desciption", col.event = "IMO_Name", col.group = "IMO_LOE", title = "OP Approach", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")

higherCal <- vistime(TestHigherData,optimize_y = TRUE, show_labels = TRUE, col.event = "Event_Name", col.group = "Unit_Name", col.start = "Start_date", col.end = "End_date")


PeopleApproach <- vistime(peopleDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: People", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
WinApproach <- vistime(winDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Win", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
InnovateApproach <- vistime(innovateDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Innovate", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")

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
                          opApproach %>% layout(
                            xaxis=list(range = c(Sys.Date(), Sys.Date()+183), tickfont=list(size=12, color="black"), 
                                       tickangle=-90, side="top"), 
                            yaxis=list( tickfont=list(size=14, color="black"),
                                        tickangle=90), 
                            title = list(text = "Op Approach", y = .985, 
                                         font = list(family="Arial Black", 
                                                     size = 18, color = "black")),
                            margin = list( l = 10, r = 10, b = 0, t = 100, pad = 0)
                          ),
                                                  
                          higherCal %>% layout(
                            xaxis=list(range = c(Sys.Date(), Sys.Date()+183), tickfont=list(size=12, color="black"), 
                                       tickangle=-90), 
                            yaxis=list( tickfont=list(size=14, color="black"), 
                                        tickangle=90),
                            title = list(text = "Higher HQs", y = .001, 
                                         font = list(family="Arial Black", 
                                                     size = 18, color = "black")),
                            margin = list(l = 10, r = 10, b = 0, t = 0, pad = 0),
                            height = 300
                         )
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
               )),
      tabPanel(h4("Data"),
               tabsetPanel(
                 tabPanel("Campaign Data",
                          rhandsontable(TestCampdata, rowHeaders = NULL) %>% hot_cols("IMO_ID", allowInvalid = TRUE) %>%
                            hot_cols(colWidths = 100)
                 ),
                 tabPanel("Higher HQ Data",
                 )
               ))
    )
  )
)

server <- function(input, output) {
}


shinyApp(ui, server)
