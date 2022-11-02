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
library(DT)
library(shinyjs)
library(sodium)
library(shinyauthr)

#@futre need to move passwords to json file salted and hased
user_base <- tibble::tibble(
  user = c("user1", "user2"),
  password = sapply(c("pass1", "pass2"), sodium::password_store),
  permissions = c("admin", "standard"),
  name = c("User One", "User Two")
)


ui <- dashboardPage(
  dashboardHeader(title = "Campaign Dashboard"),
  dashboardSidebar(
    menuItem("Login", tabName = "login", icon = icon("person")),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Database", tabName = "database", icon = icon("database")),
    menuItem("Data Entry", tabName = "data-entry", icon = icon("keyboard"))
    # button for login
    # button for dashboard
    # button for data view
    # button for data entry
  ),
  dashboardBody( 
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "dashboard.css")
    ),
    #loginpage
    
    # login section
    shinyauthr::loginUI(id = "login"),
    
    # Sidebar to show user info after login
    #uiOutput("sidebarpanel"),
    
    # Plot to show user info after login
    uiOutput("loginMessage")
  )
)

server <- function(input, output, session) {
  
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    log_out = reactive(logout_init())
  )
  
  # Logout to hide
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  output$sidebarpanel <- renderUI({
    
    # Show only when authenticated
    req(credentials()$user_auth)

    
    tagList(
      # Sidebar with a slider input
      column(width = 4,
             sliderInput("obs",
                         "Number of observations:",
                         min = 0,
                         max = 1000,
                         value = 500)
      ),
      
      column(width = 4,
             p(paste("You have", credentials()$info[["permissions"]],"permission"))
      )
    )
    
  })
  
  # Plot
  output$loginMessage<- renderUI({
    
    req(credentials()$user_auth)
    
    div(wellPanel(h2("This is some text")))
  })
  
  
}


shinyApp(ui, server)