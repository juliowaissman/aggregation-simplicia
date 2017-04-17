#
# This is the user-interface definition of a Shiny web application. 
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(markdown)
library(plotly)

navbarPage(
  windowTitle = "Aggregation example",
  title = p(strong("Aggregation operators"), br(), em("simple examples for comparison")), 
  tabPanel("What is this?",
           column(8,
                  includeMarkdown( "./about.md"))
  ),
  tabPanel("Alternatives/Experts",
           sidebarLayout(
             sidebarPanel(
               p(h3("Add a new alternative")),
               textInput("newDescription", label = "Alternative description", value = "Enter text..."),
               numericInput("expert1", label = "Expert 1 evaluation", value = 0.5, min = 0, max = 1, step = 0.02),
               numericInput("expert2", label = "Expert 2 evaluation", value = 0.5, min = 0, max = 1, step = 0.02),
               numericInput("expert3", label = "Expert 3 evaluation", value = 0.5, min = 0, max = 1, step = 0.02),
               numericInput("expert4", label = "Expert 4 evaluation", value = 0.5, min = 0, max = 1, step = 0.02),
               actionButton("addAlternative", "Add alternative"),
               p(h3("Delete an alternative")),
               selectizeInput('deleteList', 'Choice an alternative to delete', choices = NULL),
               actionButton("delAlternative", "Delete alternative")
             ),
             mainPanel(
               checkboxInput("checkbox", label = "Show alternatives description", value = TRUE),
               tableOutput("tablaDatos"))
           )),
  tabPanel("Aggregation",
           tableOutput("table"),
           selectizeInput('aggList', 'Aggregation operator quick review', 
                          choices = list("Mutually reinforced",
                                         "Averaging (consensus)",
                                         "Disjunctive",
                                         "Conjunctive"),
                          selected = "Mutually reinforced"),
           uiOutput("description")),
  tabPanel("Comparison",
           plotlyOutput("plot"))
)
