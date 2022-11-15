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

Campdata <- TestCampdata

stats <- get_camp_stats(Campdata)

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
                                    get_OpApproach(Campdata, TestHigherData)
                                    ),
                           tabPanel("Performance Stats",
                                    get_completionRate(Campdata, Sys.Date(), Sys.Date()+80)
                                    )
                         )
                ),
              tabPanel("People LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: People",
                                  get_LOE(Campdata,"People")
                                  ),
                         tabPanel("Performance Stats",
                                  get_completionRate(Campdata, Sys.Date(), Sys.Date()+80)
                                  )
                         )
                ),
              tabPanel("Win LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: Win",
                                  get_LOE(Campdata,"Win")
                         ),
                         tabPanel("Performance Stats",
                                  get_completionRate(Campdata, Sys.Date(), Sys.Date()+80)
                         )
                       )
              ),
              tabPanel("Innovate LOE",
                       tabsetPanel(
                         tabPanel("Op Approach: Innovate",
                                  get_LOE(Campdata,"Innovate")
                         ),
                         tabPanel("Performance Stats",
                                  get_completionRate(Campdata, Sys.Date(), Sys.Date()+80)
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
                                  icon = icon("building-columns"), width = 3,
                                  fill = TRUE, color="blue"),
                          infoBox("Total IMOs Completed", stats[["total_complete"]], 
                                  icon = icon("list-check"), width = 3,
                                  fill = TRUE, color="green"),
                          infoBox("Total IMOs Outstanding", stats[["total_outstanding"]], 
                                  icon = icon("clipboard-list"), width = 3,
                                  fill = TRUE, color="yellow"),
                          infoBox("Total IMOs Currently Overdue", stats[["total_overdue"]], 
                                  icon = icon("clock"), width = 3,
                                  fill = TRUE, color="red")), 
                         fluidRow(
                           get_total_stats_charts(Campdata),
                         ),
                         fluidRow(
                          infoBox("Off Track Higher Assistance", stats[["Off_Higher"]],
                                  icon = icon("triangle-exclamation"),
                                  fill = TRUE, color="maroon", width = 3),
                          infoBox("Off Track Staff Assistance", stats[["Off_Staff"]],
                                  icon = icon("circle-exclamation"),
                                  fill = TRUE, color="red", width = 3),
                          infoBox("Off Track Section Internal", stats[["Off_Sec"]],
                                  icon = icon("exclamation"),
                                  fill = TRUE, color="yellow", width = 3),
                          infoBox("On Track", stats[["OT"]], 
                                  icon = icon("circle-check"),
                                  fill = TRUE, color="green", width = 3)
                        ),
                          fluidRow(
                          get_current_status(Campdata)
                          )
              )
          )
      ),
      tabItem(tabName = "crit",
              tabsetPanel(
                tabPanel( "critical stats",
                  fluidRow(
                    infoBox("Off Track Higher Assistance", stats[["Off_Higher"]],
                        icon = icon("triangle-exclamation"), fill = TRUE, 
                        color="maroon", width = 4),
                  rhandsontable(get_otHigher(Campdata), width = 800, height = 200, rowHeaders = NULL) %>% 
                    hot_cols(colWidths = 100)
                  ),
                  fluidRow(
                    infoBox("Off Track Staff Assistance", stats[["Off_Staff"]],
                            icon = icon("circle-exclamation"),
                            fill = TRUE, color="red", width = 4),
                    rhandsontable(get_otStaff(Campdata), width = 800, height = 200, rowHeaders = NULL) %>% 
                      hot_cols(colWidths = 100)
                  ),
                  fluidRow(
                    infoBox("Off Track Section Internal", stats[["Off_Sec"]],
                            icon = icon("exclamation"),
                            fill = TRUE, color="yellow", width = 4),
                    rhandsontable(get_otSec(Campdata), width = 800, height = 200, rowHeaders = NULL) %>% 
                      hot_cols(colWidths = 100)
                  ),
                  fluidRow(
                    infoBox("On Track", stats[["OT"]], 
                            icon = icon("circle-check"),
                            fill = TRUE, color="green", width = 4),
                    rhandsontable(get_onT(Campdata), width = 800, height = 200, rowHeaders = NULL) %>% 
                      hot_cols(colWidths = 100)
                  )
                )
              )
      ),
      tabItem(tabName = "dep",
              
              tabsetPanel(
                tabPanel("dependancy Graph", "test"
                         #get_dep(Campdata)
                         )
              )
      ),
      
      tabItem(tabName = "data",
              tabsetPanel(
                tabPanel("Campaign Data",
                         rhandsontable(Campdata, rowHeaders = NULL) %>% 
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
