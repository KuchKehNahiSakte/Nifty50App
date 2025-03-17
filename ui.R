# ui.R

library(shiny)

ui <- fluidPage(
  titlePanel("Nifty 50 Stock and Nifty Index Data"),

  sidebarLayout(
    sidebarPanel(
      selectInput("stock", "Select Stock:", choices = c(
        "RELIANCE.NS", "TCS.NS", "HDFCBANK.NS", "INFY.NS", "ICICIBANK.NS",
        "HINDUNILVR.NS", "SBIN.NS", "BAJFINANCE.NS", "KOTAKBANK.NS", "LT.NS",
        "ADANIPORTS.NS", "AXISBANK.NS", "M&M.NS", "ASIANPAINT.NS", "BHARTIARTL.NS",
        "TITAN.NS", "ULTRACEMCO.NS", "NTPC.NS", "HCLTECH.NS", "MARUTI.NS",
        "POWERGRID.NS", "NESTLEIND.NS", "BAJAJFINSV.NS", "SUNPHARMA.NS", "JSWSTEEL.NS",
        "GRASIM.NS", "WIPRO.NS", "ADANIENT.NS", "COALINDIA.NS", "ONGC.NS",
        "HDFC.NS", "DIVISLAB.NS", "CIPLA.NS", "TATACONSUM.NS", "TECHM.NS",
        "LTIM.NS", "APOLLOHOSP.NS", "HEROMOTOCO.NS", "EICHERMOT.NS", "BPCL.NS",
        "SHREECEM.NS", "TATAMOTORS.NS", "SBILIFE.NS", "UPL.NS", "DMART.NS",
        "INDUSINDBK.NS", "HINDALCO.NS", "BRITANNIA.NS", "LTI.NS", "ADANIPOWER.NS"
      )),
      dateRangeInput("dates", "Date Range:", start = Sys.Date() - 365, end = Sys.Date()),
      actionButton("fetch", "Fetch Data")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Nifty Time Series", plotlyOutput("nifty_plot")),
        tabPanel("Stock Time Series", plotlyOutput("stock_plot")),
        tabPanel("Comparison", plotlyOutput("comparison_plot"))
      )
    )
  )
)
