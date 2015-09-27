########################################
# Project for Developing Data Products #
# File: server.R                       #
########################################

library(rCharts)
library(datasets)

shinyServer(function(input, output) {
        
        # Weight vs age scatter chart of chickens 
        output$chart <- renderChart({
                data(ChickWeight)
                ChickWeight <- subset(ChickWeight, Time %in% seq(input$range[1], input$range[2], 1))
                if (nrow(ChickWeight) > 0)
                {
                        ChickWeight$DietType = paste('Diet type', as.character(ChickWeight$Diet)) 
                        # A random uniform noise depending on user input is added to scatter the points for a 
                        # given age because the measured ages are all discrete and mostly even (only 21 is odd).
                        if (as.numeric(input$noise) < 2){
                                ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 
                                                                             as.numeric(input$noise))        
                        }
                        else {
                                # A unit is subtracted when Time is 21 (%% 2 = 1) to avoid exceeding 22.
                                ChickWeight$Time <- ChickWeight$Time + runif(length(ChickWeight$Time), 0, 
                                                                             as.numeric(input$noise) - ChickWeight$Time %% 2)        
                        }
                        
                        chart <- hPlot(weight ~ Time, data = ChickWeight, group = "DietType", 
                                       type = "scatter", title = "Chicken fattening", 
                                       subtitle = "Comparative analysis on diet type")
                        chart$xAxis(title = list(text = "Age (days)"))
                        chart$yAxis(title = list(text = "Weight (gm)"))
                        chart$plotOptions(scatter = list(marker = list(symbol = 'circle')))
                        chart$colors('rgba(255, 127, 0, .5)', 'rgba(172, 148, 184, .5)', 
                                     'rgba(51, 187, 107, .5)', 'rgba(245, 245, 47, .5)')
                        chart$tooltip(formatter = "#! function() 
                                      {return 'Age = ' + Math.floor(parseInt(this.x, 10) / 2) * 2 + ' days, Weight = ' + this.y + ' gm'; } !#")
                        chart$addParams(dom = "chart")
                        return(chart)    
                }
                else
                {
                        # Empty chart when there is no data to display
                        return(Rickshaw$new()) 
                }
        })
        
        # Text indicating the best results on average
        output$average <- renderText({
                data(ChickWeight)
                ChickWeight <- subset(ChickWeight, Time %in% seq(input$range[1], input$range[2], 1))
                if (nrow(ChickWeight) > 0)
                {
                        # Message with the diet type with the highest average weight in the subset
                        ChickWeight$DietType = paste('Diet type', as.character(ChickWeight$Diet)) 
                        diets <- aggregate(weight ~ DietType, data = ChickWeight, FUN = "mean")
                        message <- paste("For the current selection frame, the higher weight on average is ", 
                                        round(diets[which.max(diets[,2]), ]$weight, digits = 2), 
                                        " gm, achieved by ", diets[which.max(diets[,2]), ]$DietType, 
                                        ".", sep = "")
                }
                else
                {
                        # Message when there is no data to display
                        message <- "There is no data for the current selection. There are no records for this time period."
                }
                return (message)
        })
        
})
