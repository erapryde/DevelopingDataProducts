---
title       : Effect of diet on chicken fattening
subtitle    : Visual data analysis through a Shiny application
author      : Jose Luis Dengra Barroso.
job         : Project for the course Developing Data Products.
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : bootstrap     # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
--- 

   

## Introduction

This application enables the visual analysis of the evolution of weight gain on the effect of different diets on early growth of chickens. The data come from the **ChickWeight** dataset available in the R **datasets** package. 

The outcomes are: 
* A scatter chart with age versus weight of chickens that changes dynamically depending on the user inputs and actions over the plot, making possible to explore and compare the effectiveness of the distinct diets. 
* A text indicating the best result, on average, according to the user inputs.


## Shiny Application

The application is availabe on RStudio's Shiny server at:
### [https://jldengra.shinyapps.io/DevelopingDataProducts](https://jldengra.shinyapps.io/DevelopingDataProducts)

---

## User inputs

### **Time period after birth.**

![](snapshot4.jpg)

Range of living days to display. It determines the interval of days for which **the data are reduced for the plot and results**.
The values in the X axis are delimited by this range.

For example, selecting an interval from 7 to 18 days reduces the available data to chickens aged between 7 and 18 days. The X axis is shortened and the best result on average is computed only for this time period. 

![](snapshot5.jpg)

---

## User inputs

### **Random noise**. 

![](snapshot6.jpg)

Level of random uniform noise added to the time with the aim of preventing overplotting: None, Low, Medium or High.

When the level of noise is "None", the data points fall together overplotted in the same vertical where X equals to the observed day, since there are data collected only for the even days and the day 21. All the other levels add a progressive quantity of noise to the time in order to scatter the points and be more distant to avoid overlapping. 

This input concerns only to the data point distances in the plot.  



---

## Interactive chart

The chart was created with the rCharts package. It is a scatter plot where each data point is an observation, and it is interactive in two ways: 
* **Showing popup labels** by hovering the mouse over the data points. 
* **Showing or hiding a given diet type** by clicking on its corresponding legend.

![](snapshot8.jpg)

