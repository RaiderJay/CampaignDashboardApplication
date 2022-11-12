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
library("rhandsontable")
library("markdown")
source("./IO.R")
source("./Utility.R")


ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
    dashboardSidebar( 
      sidebarMenu(id = "tabs", 
                  tags$div(class = "menu_class"),
                  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                    label = "Search...", icon = icon("magnifying-glass")),
                  menuItem("Dashboard", tabName = "dashboard", icon = icon("gauge")),
                  menuItem("Assesments:", tabName = "assesments", icon = icon("chart-line"),
                           menuSubItem("Summary Stats", icon = icon("chart-simple")),
                           menuSubItem("Critical Status", icon = icon("bell")),
                           menuSubItem("Dependency Graph", icon = icon("diagram-project")),
                           menuSubItem("Natural Language", icon = icon("book"))),
                  menuItem("Data", tabName = "data", icon = icon("database")),
                  menuItem("About", tabName = "about", icon = icon("circle-info"))
                  )
  ),
  dashboardBody( 
    tags$head( tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")),
    tabItems(
      tabItem(tabName = "dashboard", 
              tabsetPanel(
                tabPanel("Campaign Overview",
                         tabsetPanel(
                           tabPanel("Operational Approach",
                                    get_OpApproach(TestCampdata, TestHigherData)
                                    ),
                           tabPanel("Performance Stats",
                                    get_completionRate(TestCampdata, Sys.Date(), Sys.Date()+80)
                                    )
                         )
                ),
              tabPanel("People LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: People",
                                  get_LOE(TestCampdata,"People")
                                  ),
                         tabPanel("Performance Stats",
                                  get_completionRate(TestCampdata, Sys.Date(), Sys.Date()+80)
                                  )
                         )
                ),
              tabPanel("Win LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: Win",
                                  get_LOE(TestCampdata,"Win")
                         ),
                         tabPanel("Performance Stats",
                                  get_completionRate(TestCampdata, Sys.Date(), Sys.Date()+80)
                         )
                       )
              ),
              tabPanel("Innovate LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: Innovate",
                                  get_LOE(TestCampdata,"Innovate")
                         ),
                         tabPanel("Performance Stats",
                                  get_completionRate(TestCampdata, Sys.Date(), Sys.Date()+80)
                         )
                       )
              )

            )
      ),

      tabItem(tabName = "data",
              tabsetPanel(
                tabPanel("Campaign Data",
                         rhandsontable(TestCampdata, rowHeaders = NULL) %>% 
                           hot_cols("IMO_ID", allowInvalid = TRUE) %>% 
                           hot_cols(colWidths = 100)
                         ),
                tabPanel("Higher Unit",
                         rhandsontable(TestHigherData, rowHeaders = NULL) %>% 
                           hot_cols("Unit_Name", allowInvalid = TRUE) %>% 
                           hot_cols(colWidths = 100)
                ),
              )
      ),
      tabItem(tabName = "about",
              fluidPage(
                includeMarkdown("README.md")
              )
      )
    )
  )
)

server <- function(input, output) {
}


shinyApp(ui, server)
