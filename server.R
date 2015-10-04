library(shiny)
library(ggplot2)

data(cars)

speedModel <- lm(dist ~ speed, cars)
distModel <- lm(speed ~ dist, cars)

# bp <- plot(speed ~ dist, cars)

getOptionText <- function(option) {
    t <- 'Based on input speed, the stopping distance (ft) it needs is'
    if (option == 'distance') {
        t <- 'Based on input stopping distance, the estimated speed (mph) is'
    }
    t
}

getPredictionValue <- function(option, value) {
    new <- NULL
    md <- NULL

    if (option == 'distance') {
        new <- data.frame(dist = value)
        md <- distModel
    } else {
        new <- data.frame(speed = value)
        md <- speedModel
    }
    predict(md, new)
}

getPoint <- function(option, value, predicted) {
    p <- NULL
    
    if (option == 'distance') {
        p = data.frame(speed = predicted, dist = value)
    } else {
        p = data.frame(speed = value, dist = predicted)
    }
    
    p
}

shinyServer(
  function(input, output) {
      output$predictionOption <- renderText({getOptionText(input$option)})

      predicted <- reactive({getPredictionValue(input$option, input$predictor)})

      output$predictionValue <- renderText({predicted()})
      
      p <- reactive({getPoint(input$option, input$predictor, predicted())})
      newdata <- reactive({rbind(cars, p())})

      bp <- reactive({qplot(speed, dist, data = newdata(), geom = c('point', 'smooth'), method = 'lm')})

      output$trend <- renderPlot({bp() + geom_point(colour = 'red', data = p())})
  }
)
