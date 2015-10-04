library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("Speed and Stopping Distance of Cars"),
  sidebarPanel(
    p('Based on the historical data recorded in 1920s, you can input value for either:'),
    p('1. Speed (mph) of the car to predict the stopping distance (ft) it needs'),
    p('2. Stopping distance (ft) to estimate the speed (mph) of the car.'),
    radioButtons('option', '', c('speed', 'distance'), selected = 'speed', inline = TRUE),
    sliderInput('predictor', '', value = 50, min = 4, max = 150, step = 1)
  ),
  mainPanel(
    verbatimTextOutput('predictionOption'),
    verbatimTextOutput('predictionValue'),
    plotOutput('trend')
  )
))
