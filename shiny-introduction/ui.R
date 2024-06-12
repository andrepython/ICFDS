function(request){
  tagList(useShinyjs(),
          dashboardPage(dashboardHeader(
            # tags$li(class = "dropdown",
            #         tags$style(".main-header {max-height: 70px}"),
            #         tags$style(".main-header .logo {height: 70px}"),
            #         tags$style(".main-header .logo {line-height: 70px !important; padding: 0 0px; }"),
            #         tags$style(".main-header .navbar .sidebar-toggle { line-height: 40px !important; }")),
            title = "Shiny!"#,
            # tags$li(a(onclick = "openTab('trend')",
            #   href = NULL,
            #   img(src = "2021_CHIE_FullColor_OnLight.png",
            #       height = "40px"),
            #   title = "Homepage",
            #   style = "cursor: pointer;"),
            #   class = "dropdown",
            #    tags$script(HTML("
            #   var openTab = function(tabName){
            #   $('a', $('.sidebar')).each(function() {
            #   if(this.getAttribute('data-value') == tabName) {
            #   this.click()
            #   };
            #   });
            #   }"))
            # )
          ),
          dashboardSidebar(collapsed = FALSE,
                           # tags$style(".left-side, .main-sidebar {padding-top: 70px}"),
                           # sidebarMenuOutput("homeTabs")
                           sidebarMenu(id = "tabs",
                                       menuItem("Basic Plotly Example",
                                                icon    =  NULL,
                                                tabName = "plotlyExample"),
                                       menuItem("S&P500",
                                                icon    =  NULL,
                                                tabName = "sp500"),
                                       menuItem("Returns by Sector",
                                                icon    =  NULL,
                                                tabName = "sector"),
                                       menuItem("Microsoft",
                                                icon    =  NULL,
                                                tabName = "msft")
                           )
          ),
          dashboardBody(
            tabItems(
              
              tabItem(tabName = "plotlyExample",
                      fluidRow(column(width = 12,
                                      shinydashboard::box(width       = NULL,
                                                          status      = "primary",
                                                          solidHeader = TRUE,
                                                          plotlyOutput("regPlot",
                                                                       height = "750px"))))),
              
              tabItem(tabName = "sp500",
                      fluidRow(
                        column(width = 2,
                               uiOutput("security")),
                        column(width = 2,
                               uiOutput("dateRangeWidget"))),
                      fluidRow(column(width = 12,
                                      shinydashboard::box(width       = NULL,
                                                          status      = "primary",
                                                          solidHeader = TRUE,
                                                          plotlyOutput("pricePlot",
                                                                       height = "750px"))))),
              
              tabItem(tabName = "sector",
                      fluidRow(
                        column(width = 2,
                               uiOutput("sectorWidget")),
                        # column(width = 2,
                        #        uiOutput("industry")),
                        column(width = 2,
                               uiOutput("sectorDateRangeWidget"))),
                      fluidRow(column(width = 12,
                                      shinydashboard::box(width       = NULL,
                                                          status      = "primary",
                                                          solidHeader = TRUE,
                                                          plotlyOutput("sectorPlot",
                                                                       height = "750px"),
                                                          reactableOutput("sectorTable"))))),
              
              tabItem(tabName = "msft",
                      fluidRow(
                        column(width = 2,
                               uiOutput("msftDateRangeWidget"))),
                      fluidRow(column(width = 12,
                                      shinydashboard::box(width       = NULL,
                                                          status      = "primary",
                                                          solidHeader = TRUE,
                                                          plotlyOutput("msftPlot",
                                                                       height = "750px")))))
              
              
            )
            
            
          )))
}