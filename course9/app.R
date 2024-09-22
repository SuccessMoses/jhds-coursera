library(shiny)
library(bslib)
library(caret)

library(randomForest)

ui <- page_sidebar(
  title = 'Species Predictor',
  sidebar = sidebar(
    numericInput('Sepal.Length', 'Input Sepal Length:', 2 ), 
    numericInput('Sepal.Width', 'Input Sepal Width:', 2 ),
    numericInput('Petal.Length', 'Input Petal Length:', 1),
    numericInput('Petal.Width', 'Input Petal Width:', 3)
  ),
  
  h2('Here is your Prediction for the flower species:'),
  verbatimTextOutput('prediction')
  
)

fit = train(Species~., data=iris, method='rf')

server <- function(input, output) {
  
  getPred <- reactive({
    newdata = data.frame(
      Sepal.Length = input$Sepal.Length,
      Sepal.Width = input$Sepal.Width,
      Petal.Length = input$Petal.Length,
      Petal.Width = input$Petal.Width
    )
    
    prediction = predict(fit, newdata = newdata)
    return(as.character(prediction))
    
  })
  
  output$prediction = renderText({
    getPred()
  })

}

shinyApp(ui = ui, server = server)