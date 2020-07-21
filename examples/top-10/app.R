library(shinymaterial)
library(shinyglide)
library(tidyverse)


content_info <- readr::read_rds("content_info.rds")

ui <- fixedPage(style = "max-width: 1000px;",
                titlePanel("Most Visited Shiny Apps"),
                
                glide(height = "500px",
                      map(
                        1:length(content_info[[1]]),
                        ~ screen(
                          tags$h3(content_info[["title"]][.x]),
                          tags$a(href = content_info[["url"]][.x],
                                 tags$img(src = content_info[["img"]][.x]))
                        )
                      )),
                fillRow(height = "25px"),
                fluidRow(
                  
                  p("Click on the imgage to be redirected to the respective shiny app."),
                  p("The code used to create this can be found at https://github.com/sol-eng/connect-landing")
                )
                
                )



server <- function(input, output) {
  
}
shinyApp(ui = ui, server = server)
