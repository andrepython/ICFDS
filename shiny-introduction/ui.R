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
                                       menuItem("S&P500",
                                                icon    =  NULL,
                                                tabName = "sp500"),
                                       menuItem("Returns by Sector",
                                                icon    =  NULL,
                                                tabName = "sector"),
                                       menuItem("Microsoft",
                                                icon    =  NULL,
                                                tabName = "msft")
                                       # menuItem("Executive Metrics", 
                                       #          startExpanded = TRUE, 
                                       #          tabName       = "execMetrics",
                                       #          mapply(funcs$sidebarSubItemWrapper,
                                       #                 displayName = tabMapping()[subMenu == "exec"]$displayName,
                                       #                 id          = tabMapping()[subMenu == "exec"]$id,
                                       #                 SIMPLIFY    = FALSE))#,
                                       # menuItem("Working Metrics", 
                                       #          startExpanded = TRUE, 
                                       #          tabName       = "workingMetrics",
                                       #          mapply(funcs$sidebarSubItemWrapper,
                                       #                 displayName = tabMapping()[subMenu == "working"]$displayName,
                                       #                 id          = tabMapping()[subMenu == "working"]$id,
                                       #                 SIMPLIFY    = FALSE)
                                       # )
                           )
          ),
          dashboardBody(
            #                         tags$head(tags$style(HTML("* {
            #   font-family: Segoe UI !important;
            # }"))),
            #                                       
            #                                       tags$head(tags$style(HTML(".main-header .sidebar-toggle {
            #     font-family: fontAwesome, 'Font Awesome 5 Free' !important;
            # }"))),
            #                                       
            #                                       tags$head(tags$style(HTML(".glyphicon:before{
            #     font-family:'Glyphicons Halflings';
            # }"))),
            # 
            #                                       tags$head(tags$style(HTML(".small-box.bg-yellow { background-color: #FFB900 !important; color: #000000 !important; }"))),
            #                                       
            #                                       tags$head(tags$style(HTML(".small-box.bg-green { background-color: #107C10 !important; color: #ffffff !important; }"))),
            #                                       
            #                                       tags$head(tags$style(HTML(".small-box.bg-red { background-color: #D83B01 !important; color: #ffffff !important; }"))),
            #                                       
            #                                       tags$head(tags$style(HTML(".ReactTable .rt-tr:hover .rt-td {
            #     background: #f7f7f8}"))),
            #                                       
            #                                       tags$head(tags$style(HTML('.fa, .far, .fas {
            #     font-family: "Font Awesome 5 Free" !important;
            # }'))),
            #                                       
            #                                       tags$head(tags$style(HTML(".main-header .logo {
            #   font-family: Segoe UI Semibold !important;
            # }"))),
            #                                       tags$head(tags$style(HTML(".mbr_box_class .small-box {
            #       height: 140px;
            #       #width: 340px;
            #     }"))),
            #                                       tags$head(tags$style(HTML('.small-box .icon-large {right: 20px; bottom: 15px;}'))),
            #                                       
            #                                       tags$head(tags$style(HTML('
            #                       .input-group-sm>.form-control {font-size: 12px;}
            #                             '))),
            #                                       
            #                                       tags$style(HTML(".datepicker {z-index:99999 !important;}")),
            #                                       
            #                                       tags$head(tags$style(HTML('.box.box-solid.box-primary>.box-header {
            #     text-align-last: center;
            # }'))),
            tabItems(
              
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