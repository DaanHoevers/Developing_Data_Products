library(shiny)

shinyUI(fluidPage(
        headerPanel("Gini Coefficient"),
        
        sidebarPanel(
                helpText("This app shows the Gini Coefficient on a world map for a selected",
                         "period. The user can also decide to modify the range of Gini coefficients",
                         "to view only a certain part of the range within that period."),
                
                h5("Input:"),
                                
                radioButtons(inputId = "period",
                            label = "Select a period to display:",
                            choices = c("2005-2009" = "2005-2009",
                                        "2010-2014" = "2010-2014"),
                            selected = "2005-2009"),
                
                br(),
                checkboxInput(inputId = "select",
                              label = "Modify the Gini Range to be displayed for the selected period",
                              value = FALSE),

                br(),
                conditionalPanel(condition = "input.select == true",
                        sliderInput("g_range",
                                    "Gini Range:",
                                    min = 24,
                                    max = 66,
                                    value = c(24, 66)
                                    )
                        ),
                
                br(),
                helpText("Push the Ready button to see the results:"),
                submitButton(text = "Ready"),

                br(),
                h5("Output:"),
                
                textOutput("text1"),
                
                br(),
                textOutput("text2"),
                                
                br(),
                h6("Gini Coefficient explained:"),
                helpText("Gini index measures the extent to which the distribution of income or consumption", 
                         "expenditure among individuals or households within an economy deviates from a",
                         "perfectly equal distribution. A Lorenz curve plots the cumulative percentages",
                         "of total income received against the cumulative number of recipients, starting",
                         "with the poorest individual or household. The Gini index measures the area",
                         "between the Lorenz curve and a hypothetical line of absolute equality, ",
                         "expressed as a percentage of the maximum area under the line. Thus a Gini", 
                         "index of 0 represents perfect equality, while an index of 100 implies perfect inequality",
                         "For more information on the Gini coefficient please review ", 
                         tags$a(href="http://en.wikipedia.org/wiki/Gini_coefficient",
                                                  "the Wiki page on the Gini Coefficient")
                        ),
                
                br(),
                h6("Data Source:"),
                helpText("The Gini coefficients data is obtained from the World Bank and downloaded",
                         "from ", tags$a(href="http://data.worldbank.org/indicator/SI.POV.GINI",
                                                    "the World Bank website"), "on 12 January 2015"),
                h6(tags$a(href="https://github.com/DaanHoevers/Developing_Data_Products",
                          "Get Code"))
                
        ),
                
        mainPanel(
                tabsetPanel(
                        tabPanel("Gini Map", h4("Gini Coefficients for selected period"), htmlOutput("map")),
                        tabPanel("Gini Table", h4("Gini Coefficients"), dataTableOutput("table"))
                )
        )
))