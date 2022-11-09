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
library("rhandsontable")
library("highcharter")
source("./IO.R")

#print(TestCampdata)
#save_data(TestCampdata,"./data/test.json")
#TestCampdata <- read_data("./data/test.json")

winDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Win"),]
peopleDF <- TestCampdata[which(TestCampdata$IMO_LOE == "People"),]
innovateDF <- TestCampdata[which(TestCampdata$IMO_LOE == "Innovate"),]

opApproach <- vistime(TestCampdata, linewidth = 20, col.tooltip= "IMO_Desciption", col.event = "IMO_Name", col.group = "IMO_LOE", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")

higherCal <- vistime(TestHigherData,linewidth = 15, optimize_y = TRUE, show_labels = TRUE, col.event = "Event_Name", col.group = "Unit_Name", col.start = "Start_date", col.end = "End_date")

PeopleApproach <- vistime(peopleDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: People", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
WinApproach <- vistime(winDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Win", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
InnovateApproach <- vistime(innovateDF, col.event = "IMO_Name", col.group = "IMO_SubLOE", title = "OP Approach: Innovate", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")

ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
  dashboardSidebar( div(class = "test",
    actionButton("Dashboard","Dashboard"),
    actionButton("DataInput","Data Input"))
  ),
  dashboardBody( 
    tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")),
    tabsetPanel(
      tabPanel(h4("Campaign Overview"),
               tabsetPanel(
                 tabPanel("Operational Approach",
                          fig <- subplot(opApproach,higherCal, heights = c(.6,.3), nrows = 2, shareX = TRUE)  %>%
                            layout(height = 750,
                                   xaxis=list(range = c(Sys.Date(), 
                                                        Sys.Date()+183), 
                                              tickfont=list(size=12, color="black"), 
                                              tickangle=-90, side="bottom",
                                              tick0=Sys.Date(),
                                              dtick = "M1"
                                              #minor_dtick = 86400000.0,
                                              #minor_griddash="dash"
                                   ),
                                   yaxis=list(tickfont=list(size=14, color="black")),
                                   title = list(text = "Operational Approach", 
                                                font = list(
                                                  family="Arial Black", 
                                                  size = 18, color = "black"))
                            )
                 ),
                 tabPanel("Assesments",
                          #tags$img(src = "/images/300.jpeg", alt = "logo"),

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
