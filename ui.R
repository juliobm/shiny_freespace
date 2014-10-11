library(shiny) 



shinyUI(pageWithSidebar(
  
  headerPanel("Free space on Server-Disk"),
  
  sidebarPanel(
    selectInput("servidores", label = h3("Servers"),
                 choices = "server", multiple=FALSE),
    radioButtons("discos", label = h3("Disk"),
                 choices = "c"),
    dateRangeInput("dates", label = h3("Date range"),  format="yyyy-mm-dd")
  ),
  
  mainPanel(
    textOutput("text1"),
    tabsetPanel(
      tabPanel("Plot", plotOutput("plot")), 
      tabPanel("Table", dataTableOutput("table")),
      tabPanel("About", verbatimTextOutput("summary"),
               HTML("<br>
                    <br>The only purpose of this shinyApp is to show the use of widgets and reactive plots and tables using shinyApps.
                    <br>It was a demand of MOOC of Coursera Developing Data Products.
                    <br>It shows graphically free space on disk of my servers along time.
                                          <br>
                    <br>Every time you change the server, only the disk that server owns are showed.
                    <br>Most of business servers, the free space on them is decresing by the only use of software updates |-(
                    ")) 
     
    )
  ) 
  
))