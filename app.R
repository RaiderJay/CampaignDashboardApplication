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
source("./IO.R")
source("./Utility.R")


ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
    dashboardSidebar(
      sidebarMenu(id = "tabs",
                  tags$div(class = "menu_class",
                           sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                                             label = "Search..."),
                           menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
                           menuItem("Assesments", tabName = "Assesments", icon = icon("chart-line")),
                           menuItem("Data", tabName = "data", icon = icon("database"))
                           )
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

      tabItem(tabName = "data", "test2")
    )
    
    #tabsetPanel(  tabName = "dashboard",
    #  tabPanel("Campaign Overview",
    #           tabsetPanel(
    #             tabPanel("Operational Approach",
    #                      get_OpApproach(TestCampdata, TestHigherData)
    #             ),
    #             tabPanel("Assesments",
    #                      get_completionRate(TestCampdata, Sys.Date(), Sys.Date()+80)
    #             )
    #           )),
    #  tabPanel("People LOE",
    #           tabsetPanel(
    #             tabPanel("Op Approach: People",
    #                     get_LOE(TestCampdata,"People")
    #             ),
    #             tabPanel("People: Assesments")
    #           )),
    #  tabPanel("Win LOE",
    #           tabsetPanel(
    #             tabPanel("Op Approach: Win",
    #                      get_LOE(TestCampdata,"Win")
    #             ),
    #             tabPanel("Win: Assesments")
    #           )),
    #  tabPanel("Innovate LOE",
    #           tabsetPanel(
    #             tabPanel("Op Approach: Innovate",
    #                      get_LOE(TestCampdata,"Innovate")
    #             ),
    #             tabPanel("Innovate: Assesments")
    #           )),
    #  tabPanel("Data",
    #           tabsetPanel(
    #             tabPanel("Campaign Data",
    #                      rhandsontable(TestCampdata, rowHeaders = NULL) %>% hot_cols("IMO_ID", allowInvalid = TRUE) %>%
    #                        hot_cols(colWidths = 100)
    #             ),
    #             tabPanel("Higher HQ Data",
    #             )
    #           ))
    #)
  )
)

server <- function(input, output) {
}


shinyApp(ui, server)
