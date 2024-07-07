# Deploy and Scale Shiny Apps

## Ming Yang

There are several common approaches for deploying your Shiny applications and sharing them online with other users.

1. Shiny Server (Open Source) https://posit.co/products/open-source/shinyserver/

2. Posit Connect (Enterprise) https://posit.co/products/enterprise/connect/

3. shinyapps.io by Posit (Cloud) https://www.shinyapps.io/

In this tutorial, we will focus on Shiny deployment and scalability via the open source Shiny Server, which is free and available as a Docker image. https://rocker-project.org/images/versioned/shiny.html

By deploying your applications via Shiny Server and the Docker technology, you gain the flexibility to select your preferred cloud hosting platform, such as AWS, Azure, GCP, and automatically handle scaling to serve a high volume of simultaneous users.
