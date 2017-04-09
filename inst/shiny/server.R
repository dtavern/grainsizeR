######################################################
###########    LOAD PACKAGES       ###################
######################################################

library(shiny)
library(videoplayR)
options(shiny.maxRequestSize=30*1024^2)
######################################################
###########    DEFINE SERVER LOGIC ###################
######################################################
shinyServer(function(input, output) {

######################################################
###########    SET DEFAULT VALUES ###################
######################################################


measurement_count <- reactiveValues(counter = as.integer(0))
size_table <- reactiveValues(df = data.frame("measurement_no" = integer(0),
                        "gsize_cm" = numeric(0),
                        "phi" = numeric(0),
                        "too_small" = numeric(0)))

point_table <- reactiveValues(df = data.frame("measurement_no" = integer(0),
                                             "x" = numeric(0),
                                             "y" = numeric(0)))


######################################################
###########    FILE UPLOAD ###################
######################################################
  files <- reactive({
    files <- input$input_img
    files$datapath <- gsub("\\\\", "/", files$datapath)
    files
  })

######################################################
###########    READ FILE AS PLOT OBJECT  #############
######################################################
  img_filename <- reactive({files()[1,4]})
  img_load <- reactive({readImg(img_filename())})


######################################################
#######    GENERATE RANDOM POINT TRIGGERS ############
######################################################
random_select <- reactiveValues(x = 0,
                                y = 0)

observeEvent(input$input_img, {
  random_select$x <- isolate(runif(n = 1, min = 0, max = img_load()$dim[2]))
  random_select$y <- isolate(runif(n = 1, min = 0, max = img_load()$dim[1]))
})

observeEvent(input$not_interest, {
  random_select$x <- isolate(runif(n = 1, min = 0, max = img_load()$dim[2]))
  random_select$y <- isolate(runif(n = 1, min = 0, max = img_load()$dim[1]))
})


######################################################
###########    VERTICAL SCALING ###################
######################################################
vscale_loc <- reactive({
  if (input$vscale == 0){
    return(1)
  }
  isolate({quartz("Set Vertical Scale Distance", width = 12, height = 12, pointsize = 12)
    imshow(img_load())
    clickvec <- locator(2, type = "o")
    xdist <- max(clickvec$x) - min(clickvec$x)
    ydist <- max(clickvec$y) - min(clickvec$y)
    dist <- sqrt(xdist^2 + ydist^2)
    return(dist)
    })
})
vscale_val <- reactive({input$vscale_val / vscale_loc() })

######################################################
###########    HORIZONTAL SCALING ###################
######################################################
hscale_loc <- reactive({
  if (input$hscale == 0){
    return(1)
  }
  isolate({quartz("Set Horizontal Scale Distance", width = 12, height = 12, pointsize = 12)
    imshow(img_load())
    clickvec <- locator(2, type = "o")
    xdist <- max(clickvec$x) - min(clickvec$x)
    ydist <- max(clickvec$y) - min(clickvec$y)
    dist <- sqrt(xdist^2 + ydist^2)
    return(dist)
  })
})
hscale_val <- reactive({input$hscale_val / hscale_loc() })

######################################################
###########    IMAGE CROPPING      ###################
######################################################


  img_crop <- reactive({
   # if (is.null(output$brush_coord)){
   #   return(img_load())
   # } else {
    return(r2img(
      img2r(img_load())[(img_load()$dim[1] - as.integer(input$plot_brush$ymax)):(img_load()$dim[1] - as.integer(input$plot_brush$ymin)),
                        (as.integer(input$plot_brush$xmin)):as.integer((input$plot_brush$xmax)),]
      )
    )
    #}
  })


######################################################
###########    IMAGE PROCESSING    ###################
######################################################
  # Black and White
  img_bw <- reactive({
    if (isTRUE(input$bwprompt)){
      return(ddd2d(img_crop()))
    } else {
        return(img_crop())
      }
    })
  # Thresholding

  img_thres <- reactive({
    if(isTRUE(input$thresprompt)){
      return(thresholding(img_bw(), input$thresvalue, type = "binary"))
    } else {return(img_bw())}

  })


######################################################
###########    RECORD STONE SIZE   ###################
######################################################

  click_coordinates <- reactive({
    validate(need(!is.null(input$plot_click),"No click recorded"))
    validate(need(!is.null(input$plot_click),"No double-click recorded"))
    data.frame("x" = c(input$plot_click$x + input$plot_brush$xmin,
                       input$plot_dblclick$x + input$plot_brush$xmin),
               "y" = c(input$plot_click$y + input$plot_brush$ymin,
                       input$plot_dblclick$y + input$plot_brush$ymin)
               )
  })


# Extract grain size length
  # Calculate length
  xsize <- reactive({(max(click_coordinates()$x) - min(click_coordinates()$x)) * hscale_val()})
  ysize <- reactive({(max(click_coordinates()$y) - min(click_coordinates()$y)) * vscale_val()})
  gsize <- reactive({sqrt(xsize()^2 + ysize()^2)})
  phi <- reactive({(-log2((gsize()*10)/ 1))})


  # Save into dataframe

  newEntry <-
    observeEvent(input$record, {
      measurement_count$counter <- isolate(measurement_count$counter + 1)
      ## Log previous points
      point_hist <- isolate(c(
        "point_no" = measurement_count$counter,
        "x" = random_select$x,
        "y" = random_select$y

      ))
      ## Record measurement
      measurement_observation <- isolate(c(
        "measurement_no" = measurement_count$counter,
        "gsize_cm" = gsize(),
        "phi" = phi(),
        "too_small" = 0))



      ## Save into df
      isolate(size_table$df[nrow(size_table$df) + 1,] <- measurement_observation)
      isolate(point_table$df[nrow(point_table$df) + 1,] <- point_hist)

      ## Generate new random point
        random_select$x <- isolate(runif(n = 1, min = 0, max = img_load()$dim[2]))
        random_select$y <- isolate(runif(n = 1, min = 0, max = img_load()$dim[1]))

    })


  hscale_val <- reactive({input$hscale_val / hscale_loc() })

# Too small record

  newEntry <-
    observeEvent(input$too_small, {
      measurement_count$counter <- isolate(measurement_count$counter + 1)
      point_hist <- isolate(c(
              "point_no" = measurement_count$counter,
              "x" = random_select$x,
              "y" = random_select$y
            ))
      measurement_observation <- isolate(c(
        "measurement_no" = measurement_count$counter,
        "gsize_cm" = gsize(),
        "phi" = phi(),
        "too_small" = 1))
      isolate(size_table$df[nrow(size_table$df) + 1,] <- measurement_observation)
      isolate(point_table$df[nrow(point_table$df) + 1,] <- point_hist)

      ## Generate new random point
        random_select$x <- isolate(runif(n = 1, min = 0, max = img_load()$dim[2]))
        random_select$y <- isolate(runif(n = 1, min = 0, max = img_load()$dim[1]))

    })
######################################################
###########    OUTPUT VARIABLES   ###################
######################################################
  output$click_coord <- renderText({paste0("x=", click_coordinates()$x[1], "\ny=", click_coordinates()$y[1])})
  output$brush_coord <- renderText({paste0("xmin=", input$plot_brush$xmin, "\nxmax=", input$plot_brush$xmax,
                                           "\nymin=", input$plot_brush$ymin, "\nymax=", input$plot_brush$ymax)})
  output$dblclick_coord <- renderText({paste0("x=", click_coordinates()$x[2], "\ny=", click_coordinates()$y[2])})
  output$sizing <- renderText({paste0("xlength=", xsize(),
                                      "\nylength", ysize(),
                                      "\nb-axis", gsize(),
                                      "\nphi", phi())})
  output$testv <- renderText({paste("Vertical Scaling: ", vscale_val(), " cm / map unit")})
  output$testh <- renderText({paste("Horizontal Scaling: ", hscale_val(), " cm / map unit")})
  output$measurements <- renderTable(size_table$df)
  output$plot <-renderPlot({
    validate(need(!is.null(input$input_img), "Upload Image"))
    imshow(img_load())
    points(x = random_select$x,
          y = random_select$y,
           pch = 18, col = "yellow")

    points(x = point_table$df$x,
           y = point_table$df$y,
           pch = 21, col = "red", bg = "blue")

    })

  output$plotzoom <- renderPlot({
    validate(need(!is.null(input$input_img), "Upload Image"))
    validate(need(!is.null(input$plot_brush), "Select area of interest by swiping mouse on above photo"))
    imshow(img_thres())
    points(x = random_select$x - input$plot_brush$xmin,
           y = random_select$y - input$plot_brush$ymin,
           pch = 18, col = "yellow")
    points(x = point_table$df$x - input$plot_brush$xmin,
         y = point_table$df$y - input$plot_brush$ymin,
         pch = 21, col = "red", bg = "blue")})

  output$downloadData <- downloadHandler(filename = "grainsizeR_output.csv", content = function(file){write.csv(size_table$df, file)})
})


