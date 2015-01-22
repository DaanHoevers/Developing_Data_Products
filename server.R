library(shiny)
library(reshape)
library(googleVis)
library(doBy)

shinyServer(
        function(input, output){

        ## read raw data from World Bank, see data source
        dt.gini <- read.csv("si.pov.gini_Indicator.csv", header = TRUE)
        dt.gini <- dt.gini[-c(215:219),]
        
        ## rename column names
        i <- colnames(dt.gini)
        i[1] <- "Series.Name"
        i[5:14] <- c("2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014")
        colnames(dt.gini) <- i
        
        ## transform table from year columns into table having year rows
        gini <- melt(dt.gini)
        colnames(gini)[c(5:6)] <- c("Year", "Value")

        ## create column with respective period, add column to table
        yr <- as.numeric(levels(gini$Year)[gini$Year])
        indx <- findInterval(yr, seq(2005, 2014, by = 5))
        Period <- gsub("1\\b", "2005-2009", indx)
        Period <- gsub("2\\b", "2010-2014", Period)
        gini <- cbind(gini, Period)
        
        ## summarize Gini value by the period for each country 
        s_gini <- summaryBy(Value ~ Series.Code + Country.Name + Country.Code + Period
                            , data = gini, FUN = mean, na.rm = TRUE)
        s_gini <- s_gini[complete.cases(s_gini), ]
        colnames(s_gini)[5] <- "Period.mean"
        s_gini$Period.mean <- round(s_gini$Period.mean, 2)
        
        ## create function that handles period chosen and potentially the range
        dat <- function(){
                p_gini <- s_gini[s_gini$Period == input$period,]
                
                if(input$select == TRUE){
                        p_gini <- p_gini[(p_gini$Period.mean >= input$g_range[1] 
                                          & p_gini$Period.mean <= input$g_range[2]),]
                }
                return(p_gini)
        }
        
        ## plot result input on map
        output$map <- renderGvis({
                p_gini <- dat()
                
                G <- gvisGeoChart(p_gini, locationvar = "Country.Name"
                                  , colorvar = "Period.mean"
                                  , options = list(width = 600, height = 400))
                                
                return(G)
                })
        
        ## show result input in table
        output$table <- renderDataTable({
                p_gini <- dat()
                
                p_gini[,c(2,4,5)]
                })
        
        ## calculate mean
        output$text1 <- renderText({
                p_gini <- dat()
                paste("The mean Gini coefficient for the period chosen is"
                      , as.character(round(mean(p_gini$Period.mean),2)))
                
                })
        
        ## calculate range for input variable chosen
        output$text2 <- renderText({
                p_gini <- dat()
                paste("The range of the Gini coefficient values for the chosen period is"
                      , paste(as.character(range(p_gini$Period.mean)), collapse = " to "))
                })
        
        ## output object will not be suspended when hidden
        outputOptions(output, "map", suspendWhenHidden = FALSE)
        
})









