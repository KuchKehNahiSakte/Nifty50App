# server.R

library(shiny)
library(quantmod)
library(DT)
library(lubridate)
library(dplyr)
library(plotly)
library(ggplot2)

server <- function(input, output, session) {

  # Fetch stock data when the "Fetch Data" button is clicked
  stock_data <- eventReactive(input$fetch, {
    req(input$stock, input$dates)
    tryCatch({
      getSymbols(input$stock, from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
    }, error = function(e) {
      showNotification(paste("Error fetching data:", e$message), type = "error")
      NULL
    })
  })

  # Fetch Nifty 50 index data when the "Fetch Data" button is clicked
  nifty_data <- eventReactive(input$fetch, {
    req(input$dates)
    tryCatch({
      getSymbols("^NSEI", from = input$dates[1], to = input$dates[2], auto.assign = FALSE)
    }, error = function(e) {
      showNotification(paste("Error fetching Nifty data:", e$message), type = "error")
      NULL
    })
  })

  output$nifty_plot <- renderPlotly({
    req(nifty_data())
    data <- nifty_data()
    if (nrow(data) > 0) {
      nifty_df <- data.frame(Date = index(data), Price = as.numeric(Cl(data)))
      p <- ggplot(nifty_df, aes(x = Date, y = Price)) +
        geom_line(color = "red") +
        labs(title = "Nifty 50 Index Time Series", x = "Date", y = "Price") +
        theme_minimal()
      ggplotly(p)
    }
  })

  output$stock_plot <- renderPlotly({
    req(stock_data())
    data <- stock_data()
    if (nrow(data) > 0) {
      stock_df <- data.frame(Date = index(data), Price = as.numeric(Cl(data)))
      p <- ggplot(stock_df, aes(x = Date, y = Price)) +
        geom_line(color = "blue") +
        labs(title = paste(gsub(".NS", "", input$stock), "Time Series"), x = "Date", y = "Price") +
        theme_minimal()
      ggplotly(p)
    }
  })

  output$comparison_plot <- renderPlotly({
    req(stock_data(), nifty_data())
    stock <- stock_data()
    nifty <- nifty_data()

    if (nrow(stock) > 0 && nrow(nifty) > 0) {
      stock_df <- data.frame(Date = index(stock), StockPrice = as.numeric(Cl(stock)))
      nifty_df <- data.frame(Date = index(nifty), NiftyPrice = as.numeric(Cl(nifty)))
      merged_df <- merge(stock_df, nifty_df, by = "Date")

      p <- plot_ly(merged_df, x = ~Date) %>%
        add_trace(y = ~StockPrice, type = 'scatter', mode = 'lines', name = gsub(".NS", "", input$stock), yaxis = "y1") %>%
        add_trace(y = ~NiftyPrice, type = 'scatter', mode = 'lines', name = "Nifty 50", yaxis = "y2") %>%
        layout(
          title = paste(gsub(".NS", "", input$stock), "vs. Nifty 50"),
          yaxis = list(title = "Stock Price"),
          yaxis2 = list(title = "Nifty 50 Index", overlaying = "y", side = "right")
        )
      p
    }
  })
}
