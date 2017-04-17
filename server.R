#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(reshape2)
library(plotly)

# Initial data
alternative.data <- data.frame(
  id = 1:7,
  description = c("A good alternative for all but one",
                  "A bad alternative for all but one",
                  "A bareley aceptable alternative",
                  "An alternative good enough",
                  "An alternative width to polarized opinions",
                  "An alternative without consensus",
                  "An indiferent alternative"),
  expert.1 = c(0.7, 0.2, 0.4, 0.6, 0.9, 0.2, 0.5),
  expert.2 = c(0.8, 0.3, 0.3, 0.5, 0.8, 0.4, 0.5),
  expert.3 = c(0.9, 0.3, 0.6, 0.7, 0.2, 0.6, 0.5),
  expert.4 = c(0.1, 0.9, 0.4, 0.6, 0.1, 0.8, 0.5)
)
alternative.data$description <- as.character(alternative.data$description)

# Aggregation operators calculus
calcula.agregaciones <- function(datos){
  salida <- datos[,1:2]
  salida$triple.pi <- apply(datos[,3:6], 1, function (x) prod(x)/(prod(x) + prod(1 - x)))
  salida$average <- apply(datos[,3:6], 1, mean)
  salida$product <- apply(datos[,3:6], 1, prod)
  salida$ord.sum <- apply(datos[,3:6], 1, function (x) 1 - prod(1 - x))
  salida
}

# Reactive data used in the server
values <- reactiveValues(df_data = alternative.data,
                         df_agg = calcula.agregaciones(alternative.data))

function(input, output, session) {
  updateSelectizeInput(session, 'deleteList', choices = alternative.data$description, selected = NA)
  
  # Add item in the data frame, stored in values$df_data in reactive way
  observeEvent(input$addAlternative, {
    temp <- values$df_data
    ind <- length(temp$id) + 1
    temp[ind,] <- list(ind, input$newDescription, 
                       input$expert1, input$expert2, input$expert3, input$expert4)
    updateSelectizeInput(session, 'deleteList', choices = temp$description, selected = NA)
    values$df_data <- temp
    values$df_agg = calcula.agregaciones(temp)
  })
  
  # Delete item in the data frame, stored in values$df_data in reactive way
  observeEvent(input$delAlternative, {
    temp <- values$df_data
    temp <- temp[temp$description != input$deleteList,]
    temp$id <- 1:length(temp$id)
    updateSelectizeInput(session, 'deleteList', choices = temp$description, selected = NA)
    values$df_data <- temp
    values$df_agg = calcula.agregaciones(temp)
  }) 
  
  # The data shown in table form
  output$tablaDatos <- renderTable({
    datos <- values$df_data
    if (input$checkbox){
      datos
    }else{
      datos[,-2]
    }
  })
  
  # The output table
  output$table <- renderTable({
    values$df_agg
  })
  
  # The description of the aggregation operators
  output$description <- renderUI({
    if (input$aggList == "Mutually reinforced"){
      withMathJax(includeMarkdown("triplepi.md"))
    }else if (input$aggList == "Averaging (consensus)"){
      withMathJax(includeMarkdown("mean.md"))
    }else if (input$aggList == "Disjunctive"){
      withMathJax(includeMarkdown("product.md"))
    }else if (input$aggList == "Conjunctive"){
      withMathJax(includeMarkdown("ord-sum.md"))
    }
  })
  
  # The plot for comparaison of aggragation operators
  output$plot <- renderPlotly({
    datos <- melt(values$df_agg, id.vars = 1:2)
    plot_ly(data=datos, type="bar", x=~variable, y=~value, color=~description)
  })
}