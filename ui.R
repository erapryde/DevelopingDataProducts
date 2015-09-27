########################################
# Project for Developing Data Products #
# File: ui.R                           #
########################################

library(rCharts)

# Overall UI definition 
shinyUI(
        # Fluid Bootstrap layout
        fluidPage(
                # Container layer with a light blue background style
                div(class = "alert alert-info",
                    
                    # Instructions about the application
                    h3(strong("Effect of diet on chicken fattening")),
                    p("This application enables the visual analysis of the evolution of weight gain", 
                      "on the effect of different diets on early growth of chickens.",
                      "The data comes from the", strong("ChickWeight"), "dataset available in the R", 
                      strong("datasets"), " package and the user inputs are:"),
                    tags$ol(
                            tags$li(strong("Time period after birth: "), "Range of living days to display."),
                            tags$li(strong("Random noise: "), "Level of random uniform noise added to the time ",
                                    "with the aim of preventing overplotting: None, Low, Medium or High."),
                            tags$li("Over the interactive chart, where each data point denotes one observation ", 
                                    "or chicken:",
                                    tags$ul(
                                            tags$li("By hovering the mouse over a data point, a popup label ", 
                                                    "will show the age and weight of the chicken."), 
                                            tags$li("By clicking on a diet type legend, chickens tested with ", 
                                                    "this type will be hidden when visible or shown when invisible.")
                                    ))
                    ),
                    
                    # Row with a sidebar
                    sidebarLayout(
                            
                            # Left panel for the inputs and the average best results
                            sidebarPanel(
                                    sliderInput("range",
                                                label = "Time period after birth:",
                                                min = 0,
                                                max = 21,
                                                value = c(0, 21)), 
                                    radioButtons("noise", "Random noise:",
                                                 c("None" = "0", 
                                                   "Low" = "0.5",
                                                   "Medium" = "1", 
                                                   "High" = "2"), 
                                                 selected = "1"),
                                    hr(),
                                    p(strong("Best results on average:")),
                                    helpText(textOutput("average"))
                            ),
                            
                            # Spot for the interactive chart
                            mainPanel(
                                    showOutput("chart", lib = "highcharts")
                            )
                    )
                )
        )
)
                

