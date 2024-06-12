function(request){
  tagList(useShinyjs(),
          dashboardPage(dashboardHeader(title = "Shiny!"),
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
                                                              tabName = "msft"))),
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
                          ))))
}