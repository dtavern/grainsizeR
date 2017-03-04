#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(videoplayR)
options(shiny.maxRequestSize=30*1024^2) 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("grainsizeR"),
  p("By: David Tavernini"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      h4("Step 1: Upload Image"),
      fileInput("input_img", "", multiple = FALSE, accept = NULL, width = NULL),
      h4("Step 2: Set Scale"),
      numericInput("vscale_val", "Scale Distance (cm)", value = 0, step = 0.1),
      actionButton("vscale", "Set Vertical Scaling"),
      br(),
      numericInput("hscale_val", "Scale Distance (cm)", value = 0, step = 0.1),
      actionButton("hscale", "Set Horizontal Scaling"),
      br(),
      h4("Step 3: Image Processing & Zoom"),
      p("Using the top plot as a reference, frame the measurement window using a brush stroke in the reference. Once object is well framed, use the thresholding tools to find the edge of stone."),
      checkboxInput("bwprompt", "Black and White", value = FALSE),
      checkboxInput("thresprompt", "Binary Thresholding", value = FALSE),
      sliderInput("thresvalue", "Thresholding value", min = 0, max = 255, value = 0),
      p("Zoom window coordinates:"),
      verbatimTextOutput("brush_coord"),
      br(),
      h4("Step 4: Measure stones"),
      p("A yellow dot will appear in the reference and measurement window. Make a single click on one end of the b-axis of the stone and a double-click on the opposite side. When coordinates are correct, click 'Record Measurement.' If point is outside plotting window or is not a stone, click 'Out of Interest' and if stone is too small to see edge, click 'Too Small'"),
      actionButton("record", "Record Measurement"),
      actionButton("not_interest", "Out of Interest"),
      actionButton("too_small", "Too Small"),
      verbatimTextOutput("click_coord"),
      verbatimTextOutput("dblclick_coord"),
      verbatimTextOutput("sizing"),
      br(),
      h4("Download Table"),
      downloadLink("downloadData", "Download Grain Size Table")
    ),
  
    # Show a plot of the generated distribution
    mainPanel(
      h4("Zoom and Navigation"),
      plotOutput("plot",  brush = "plot_brush"),
      h4("Measurements"),
      plotOutput("plotzoom", click = "plot_click", dblclick = "plot_dblclick"),
      verbatimTextOutput("testh"),
      verbatimTextOutput("testv"),
      tableOutput("measurements")

      #plotOutput("distPlot")
      
    )
  )
))

