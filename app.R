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

## get relevent non-plot related data move to utility in future or make class

stats <- get_camp_stats(TestCampdata)

ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
    dashboardSidebar( 
      sidebarMenu(id = "tabs", 
                  tags$div(class = "menu_class"),
                  sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                    label = "Search...", icon = icon("magnifying-glass")),
                  menuItem("Dashboard", tabName = "dashboard", icon = icon("gauge")),
                  menuItem("Assesments:", icon = icon("chart-line"),
                           menuSubItem("Summary Stats",  tabName = "stat", icon = icon("chart-simple")),
                           menuSubItem("Critical Status", tabName = "crit", icon = icon("bell")),
                           menuSubItem("Dependency Graph", tabName = "dep", icon = icon("diagram-project")),
                           menuSubItem("Natural Language", tabName = "nlp", icon = icon("book"))),
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

      tabItem(tabName = "stat",
              tabsetPanel(
                tabPanel("Total Campaign Stats",
                         fluidRow(
                          infoBox("Total IMOs", stats[["total_imo"]], 
                                  icon = icon("building-columns"), 
                                  fill = TRUE, color="blue"),
                          infoBox("Total IMOs Completed", stats[["total_complete"]], 
                                  icon = icon("list-check"), 
                                  fill = TRUE, color="green"),
                          infoBox("Total IMOs Outstanding", stats[["total_outstanding"]], 
                                  icon = icon("clipboard-list"), 
                                  fill = TRUE, color="yellow"),
                          infoBox("Total IMOs Overdue", stats[["total_overdue"]], 
                                  icon = icon("clock"), 
                                  fill = TRUE, color="red"),
                          infoBox("Off Track Higher Assistance", stats[["Off_Higher"]], 
                                  fill = TRUE, color="maroon"),
                          infoBox("Off Track Staff Assistance", stats[["Off_Staff"]], 
                                  fill = TRUE, color="red"),
                          infoBox("Off Track Section Internal", stats[["Off_Sec"]], 
                                  fill = TRUE, color="yellow"),
                          infoBox("On Track", stats[["OT"]], 
                                  fill = TRUE, color="green")
                         #get_Actual_by_month(TestCampdata)
                )
              )
          )
      ),
      tabItem(tabName = "crit", "critical stats",
              
      ),
      tabItem(tabName = "dep",
              
              tabsetPanel(
                tabPanel("dependancy Graph", "test"
                         #get_dep(TestCampdata)
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
