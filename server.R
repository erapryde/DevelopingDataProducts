########################################
# Project for Developing Data Products #
# File: server.R                       #
########################################

library(rCharts)
library(datasets)

shinyServer(function(input, output) {
        
        # Scatter chart with age versus weight of chickens 
        output$chart <- renderChart({
                # The data comes from the Chickweight dataset included in the R datasets package.
                data(ChickWeight)
                # The date range of living days is limited according to the user input for "range"
                ChickWeight <- subset(ChickWeight, Time %in% seq(input$range[1], input$range[2], 1))
                if (nrow(ChickWeight) > 0)
                # When there is data according to the user selection
                {
                        # DietType variable is added to define labels for each diet type
                        ChickWeight$DietType = paste('Diet type', as.character(ChickWeight$Diet)) 
                        
                        # A random uniform noise is added to scatter the points for a given age because  
                        # the measured ages are all discrete and mostly even (only the value 21 is odd).
                        # The level of aditional noise depends on the user input for "noise".
                        if (as.numeric(input$noise) < 2){
                                ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 
                                                                             as.numeric(input$noise))        
                        }
                        else {
                                # When the noise is high (2), 20 and 21 are limited to increase up to 1 in order  
                                # to avoid overlapping between their data points.
                                if (ChickWeight$Time < 20)
                                {
                                        ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 
                                                                                     as.numeric(input$noise))
                                }
                                else
                                {
                                        ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 
                                                                                     1)
                                }
   
                        }
                        
                        # A scatter plot is built drawing circles that discrimine diet types by color
                        chart <- hPlot(weight ~ Time, data = ChickWeight, group = "DietType", 
                                       type = "scatter", title = "Chicken fattening", 
                                       subtitle = "Comparative analysis on diet type")
                        chart$xAxis(title = list(text = "Age (days)"))
                        chart$yAxis(title = list(text = "Weight (gm)"))
                        chart$plotOptions(scatter = list(marker = list(symbol = 'circle')))
                        chart$colors('rgba(255, 127, 0, .5)', 'rgba(172, 148, 184, .5)', 
                                     'rgba(51, 187, 107, .5)', 'rgba(245, 245, 47, .5)')
                        # A popup message with the age and weight is defined in a JavaScript function and
                        # added as tooltip for the chart. The age is computed as the nearer even number
                        # before the time increased with the noise, except for weight over 21 that correspond
                        # to the odd number 21. 
                        popup <- paste("#! function() ",
                                       "{ return 'Age = ' + ((parseInt(this.x, 10) >= 21) ? 21 : ", 
                                       "  Math.floor(parseInt(this.x, 10) / 2) * 2) + ' days,", 
                                       "  Weight = ' + this.y + ' gm'; } !#")
                        chart$tooltip(formatter = popup)
                        chart$addParams(dom = "chart")
                        return(chart)    
                }
                else
                # When there is no data according to the user selection
                {
                        # An empty chart is assigned since there is no data to display
                        chart <- Rickshaw$new()
                }
                return(chart)   
        })
        
        # Text indicating the best results on average
        output$average <- renderText({
                data(ChickWeight)
                ChickWeight <- subset(ChickWeight, Time %in% seq(input$range[1], input$range[2], 1))
                if (nrow(ChickWeight) > 0)
                # When there is data according to the user selection
                {
                        # Message with the diet type with the highest average weight in the subset
                        ChickWeight$DietType = paste('Diet type', as.character(ChickWeight$Diet)) 
                        diets <- aggregate(weight ~ DietType, data = ChickWeight, FUN = "mean")
                        message <- paste("For the current selection frame, the highest weight on average is ", 
                                        round(diets[which.max(diets[,2]), ]$weight, digits = 2), 
                                        " gm, achieved by ", diets[which.max(diets[,2]), ]$DietType, 
                                        ".", sep = "")
                }
                else
                # When there is no data according to the user selection
                {
                        # Message when there is no data to display
                        message <- paste("There is no data for the current selection.", 
                                         "There are no records for this time period.")
                }
                return (message)
        })
        
})
