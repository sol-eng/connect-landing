library(connectapi)
library(tidyverse)

# Connect to RSC
client <- connect()

# Get usage for shiny apps since beginning of 2020
usage_shiny <- get_usage_shiny(client, limit = Inf, from = as.Date("2020-01-01"))


# Find the apps with most usage time
# Usage time isn't the best measure
top_10_apps <- usage_shiny %>% 
  mutate(time_used = ended - started) %>% 
  group_by(content_guid) %>% 
  summarise(app_time = difftime(ended, started, units = "hours")) %>% 
  arrange(-app_time) %>% 
  ungroup() %>% 
  slice(1:10)


# Identify top 10 apps ----------------------------------------------------
top_10 <- count(usage_shiny,content_guid, sort = TRUE) %>% 
  slice(1:10) %>% 
  pull(content_guid) %>% 
  map(~content_item(client, .x))


# Take screenshots of each ------------------------------------------------

# define function for taking screencaps
# increase delay if you have slow to load apps
take_screenshot <- function(content_item, dir, delay = 5) {
  fname <- glue::glue("{dir}/{content_item$get_content()$title}.png")
  content_url <- content_item$get_content()$url
  
  if (!webshot::is_phantomjs_installed()) {
    stop("\n  phantom js is not installed.\n  Install with `webshot::install_phantomjs()`\n  Alternatively, set `screenshot = FALSE`")
  }
  webshot::webshot(content_url,
                   file = fname,
                   vwidth = 1280,
                   vheight = 720,
                   delay = delay,
                   cliprect = "viewport"
  )
  
}

# take the screenshot
# must go into `www` for shiny
map(top_10, take_screenshot, "www/screen-caps")

content_info <- list(title = map_chr(top_10, ~.x$get_content()$title),
     img =  map_chr(top_10, ~glue::glue("screen-caps/{.x$get_content()$title}.png")),
     url = map_chr(top_10, ~.x$get_content()$url)
     )

write_rds(content_info, "content_info.rds")
