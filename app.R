#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
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


ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
  dashboardSidebar(
    
  ),
  dashboardBody(

    
    tags$head(tags$style(HTML('
                          /* logo */
                          .skin-blue .main-header .logo {
                          background-color: rgb(68, 76, 56); color: rgb(255,255,255);
                          font-weight: bold;font-size: 18px;text-align: Right;
                          }

                          /* logo when hovered */

                          .skin-blue .main-header .logo:hover {
                          background-color: rgb(63, 71, 51);
                          }


                          /* navbar (rest of the header) */
                          .skin-blue .main-header .navbar {
                          background-color: rgb(68, 76, 56);
                          }

                          /* main sidebar */
                          .skin-blue .main-sidebar {
                          background-color: rgb(0,0,0);
                          }

                          /* main body */
                          .skin-blue .main-body {
                          background-color: rgb(0,0,0);
                          }

                          /* active selected tab in the sidebarmenu */
                          .skin-blue .main-sidebar .sidebar .sidebar-menu .active a{
                          background-color: rgb(107,194,0);
                          color: rgb(255,255,255);font-weight: bold;font-size: 18px;
                          }

                          /* other links in the sidebarmenu */
                          .skin-blue .main-sidebar .sidebar .sidebar-menu a{
                          background-color: rgb(255,125,125);
                          color: rgb(255,255,255);font-weight: bold;
                          }

                          /* other links in the sidebarmenu when hovered */
                          .skin-blue .main-sidebar .sidebar .sidebar-menu a:hover{
                          background-color: rgb(232,245,251);color: rgb(0,144,197);font-weight: bold;
                          }

                          /* toggle button color  */
                          .skin-blue .main-header .navbar .sidebar-toggle{
                          background-color: rgb(73, 81, 61);color:rgb(0,0,0);
                          }

                          /* toggle button when hovered  */
                          .skin-blue .main-header .navbar .sidebar-toggle:hover{
                          background-color: rgb(63, 71, 51);color:rgb(255,255,255);
                          }

                           '))),
    
    
    tabsetPanel(
      tabPanel(h4("Campaign Overview"),
               tabsetPanel(
                 tabPanel("Op Approach",
                          opApproach,
                          #p <- plot_ly(),
                          #opApproach,
                          #sliderInput("DatesMerge","Dates:",
                          #            min = Sys.Date() - 30,
                          #            max = as.Date("2024-10-01","%Y-%m-%d"),    
                          #            value= c(Sys.Date(),Sys.Date() + 180),
                          #            timeFormat="%Y-%m-%d")
                 ),
                 tabPanel("Assesments")
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
  output$plot11 <- renderPlot({
    hist(rnorm(cases[[input$case]][input$num]))
  })
}


shinyApp(ui, server)