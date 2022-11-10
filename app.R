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
#library("highcharter")
source("./IO.R")
source("./Utility.R")


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
                          get_OpApproach(TestCampdata, TestHigherData)
                 ),
                 tabPanel("Assesments"
                          #tags$img(src = "/images/300.jpeg", alt = "logo"),

                          )
               )),
      tabPanel(h4("People LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: People",
                         get_LOE(TestCampdata,"People")
                 ),
                 tabPanel("People: Assesments")
               )),
      tabPanel(h4("Win LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: Win",
                          get_LOE(TestCampdata,"Win")
                 ),
                 tabPanel("Win: Assesments")
               )),
      tabPanel(h4("Innovate LOE"),
               tabsetPanel(
                 tabPanel("Op Approach: Innovate",
                          get_LOE(TestCampdata,"Innovate")
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
