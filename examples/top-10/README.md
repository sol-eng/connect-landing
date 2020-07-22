README
================

## Connect Landing App

The RStudio Connect (RSC) content lsiting is still in its infancy. Some
common qualms with it are that there isn’t a fixed set of content that
is fixed to the top, it doesn’t maintain list or expanded view in new
browser sessions, among others.

One work around that has been explored and adapted is to create a shiny
or flex dashboard to act as a landing page for content. Cole Arendt has
built funcitonality into the experimental
[`connectapi`](https://github.com/rstudio/connectapi) package to create
a flexdashboard from a tag on RSC. Description below.

## Top applications landing page

Example landing page
[here](https://colorado.rstudio.com/rsc/top-10-shiny/)

This repository is an example of how to create a barebones shiny app
that acts as a landing page to RSC for the top 10 shiny apps on your
server. The repository contains two files of interest:

1.  `most-used-shiny.R`
2.  `app.R`

The first script uses the Connect API to fetch shiny usage logs from
since the beginning of 2020. Then it identifies the top 10 applications
based on its guid (unique identifier) by the number of visits. It then
fetches more information about the piece of content such as its title
and access url. Following, a screen cap is taken of each app to be used
as the landing page image (though I recommend you be a bit more didactic
than I for a better looking piece of content). A list object containing
the image path, content title, and content url is written to an RDS.

The application uses the resultant RDS object to create a vanilla slide
show which links to the application.

## Tag Approach

In the spirit of the tag approach, there are two demo examples: [Access
to
Care](https://colorado.rstudio.com/rsc/access-to-care/landing/Access%20to%20Care.html#access-to-care---dashboard)
and [Bitcoin](https://colorado.rstudio.com/rsc/bitcoin_tag/) dashboards.

The former allows is a landing page for the `Access to Care` tag on our
demo RSC server. From this landing page you can interact with content
via `iframe`. To recreate this you can use the internal function
`connectapi:::tag_page_iframe()`.

For example the below can be used to create the landing page.

``` r
library(connectapi)

# be sure to follow along the readme https://github.com/rstudio/connectapi for setting your environment variables 
client <- connect() 

# creates the html document
atc <- connectapi:::tag_page_iframe(client, "Access to Care")

# view the html doc in a browser. You can also deploy with rsconnect::deploySite()
utils::browseURL("Access to Care.html")
```

The latter does not allow you to interact with it. It follow the same
approach as the above but uses the function `connectapi::tag_page()`
instead.
