

library(shiny)
library(shinydashboard)
library(epiR)
library(shinythemes)


# Define UI for application that draws a histogram
ui <- dashboardPage(
    skin = "black",
    # Application title
    dashboardHeader(title = "Poitiers Health Data"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Sample Size Calculator", tabName = "SSC", icon = icon("users",class ="fa-solid fa-users"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "SSC",
                    fluidRow(
                        tabsetPanel(
                            
                            ##########################################
                            ############### CALCULATOR ###############
                            ##########################################
                            tabPanel("PRESENTATION",
                                    p("Welcome to the CHU of Poitier Sample Size Application!
                                    This application is devoted to the calculation of the number of 
                                    patient required for a clinical trial in order to ensure his 
                                    validity, accuracy, reliability, and integrity. Also to assure 
                                    that the intended trials will have a desired power for correctly 
                                    detecting a clinically meaningful difference between studied groups.")),
                            
                            ##########################################
                            ############## PRESENTATION ##############
                            ##########################################
                            tabPanel("CALCULATOR", box(title = "blabla",
                                                       p("Define a power i.e. a percentage of times the null hypothesis will be correctly rejected :"),
                                                       numericInput(inputId = "puissance",
                                                                    label = "Power (%)",
                                                                    value = 90,
                                                                    max = 100,
                                                                    min = 0),
                                                       p("Define a level of significance :"),
                                                       numericInput(inputId = "alpha",
                                                                    label = "Alpha (%)",
                                                                    value = 5,
                                                                    max = 20,
                                                                    min = 0,
                                                                    step = 0.5),
                                                       p("Define the prevalence observed of the principal criterion :"),
                                                       numericInput(inputId = "obs",
                                                                    label = "Observed",
                                                                    value = 0.2,
                                                                    step = 0.005),
                                                       p("Define the prevalence expected of the principal criterion :"),
                                                       numericInput(inputId = "hyp",
                                                                    label = "Hypothesis",
                                                                    value = 0.05,
                                                                    step = 0.005),
                                                       p("Define the number of patient group :"),
                                                       numericInput(inputId = "grp",
                                                                    label = "Number of groups",
                                                                    value = 2,
                                                                    min = 2),
                                                       p("One-sided test or two sided-test ? :"),
                                                       selectInput(inputId = "test",
                                                                  label = "Test",
                                                                  choices = c("one-sided", "two-sided")),
                                                       width = 5),
                                     box(title = "Number of individuals required per group : ",
                                         actionButton("go", "Result"),
                                         verbatimTextOutput("text"), width = 5))
                            
                        )
                    )
            )
        )
    )
)






# Define server logic required to draw a histogram
server <- function(input, output) {
    
    t <- reactive( if (reactive(input$test)()=="one-sided") 1 else 2 )
    
    f <- eventReactive(input$go, {
        epi.sscohortc(N = NA, irexp1 = input$obs, irexp0 = input$hyp, pexp = NA, n = NA,
                      power = input$puissance/100, r = input$grp-1, design = 1, sided.test = t(), 
                      finite.correction = FALSE, nfractional = FALSE, conf.level = (1-(input$alpha/100)))$n.exp1
    })
    output$text <- renderText(f())
}

# Run the application 
shinyApp(ui = ui, server = server)
