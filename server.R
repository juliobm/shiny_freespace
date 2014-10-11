library(shiny)
library(ggplot2)
library(scales)

shinyServer(function(input, output, session) {
 

    datalog <- read.csv("libre_en_disco_log.csv", dec=",",head=TRUE,sep="\t")
    datalog$FECHA <- as.Date(datalog$FECHA)
    datalog$num <- as.numeric(datalog$FECHA)
    bin <- 60
    servidores <- unique(datalog$SERVIDOR)
    names(servidores) <- servidores
    updateSelectInput(session,"servidores", choices = c(names(servidores)))
    
    fechas <- datalog$FECHA
    datemin = min(fechas)
    datemax = max(fechas)
    updateDateRangeInput(session, "dates", start=datemin, end=datemax)
    
  observe({  
    
    solo_server<- datalog[datalog$SERVIDOR==input$servidores,]
    from <- input$dates[1]
    til <- input$dates[2]
    solo_dates <- solo_server[solo_server$FECHA>=from & solo_server$FECHA<=til,]
    discos <- unique(solo_dates$DISCO)
    names(discos) <- discos
    updateRadioButtons(session, "discos", choices= c(names(discos)), selected=discos[1])
    
  })
#   output$text1 <- renderText(function() {
#     a <- input$dates[1]
#     b <- as.character(a, format("%Y-%m-%d"))
#   })

  output$table <- renderDataTable(options=list(pageLength=5),function() { 
   
    solo_disco <- datalog[datalog$DISCO==input$discos,]
    solo_server<- solo_disco[solo_disco$SERVIDOR==input$servidores,]
    from <- input$dates[1]
    til <- input$dates[2]
    solo_dates <- solo_server[solo_server$FECHA>=from & solo_server$FECHA<=til,]
    midata <- subset(solo_dates, select=c(1,3,5))
   
  })

  
  
  output$plot <- reactivePlot(function() {
    
    solo_disco <- datalog[datalog$DISCO==input$discos,]
    solo_server<- solo_disco[solo_disco$SERVIDOR==input$servidores,]
    from <- input$dates[1]
    til <- input$dates[2]
    solo_dates <- solo_server[solo_server$FECHA>=from & solo_server$FECHA<=til,]
    midata <- subset(solo_dates, select=c(1,3,5))
     
    p <- ggplot(midata, aes(x=FECHA, y=GB)) +
      theme_bw() +
      #geom_histogram(binwidth = bin, colour="white") +
      geom_line(colour="black", stat="identity") +
      geom_smooth( aes(group=1),method="gam") +
      labs(y ="GB") +
      labs(x ="Date") +
      labs(title = paste("Free Space on ", input$servidores, " on disk " , input$discos) ) +
      scale_fill_brewer() +
      scale_x_date()

    print(p)
   
  })
  
})