library("plotly")
library("vistime")
library("sys")

#get OP Approach for display
get_OpApproach <- function(df1, df2) {
  
  #get two timeline sub_plots
  opApproach <- vistime(df1, linewidth = 20, 
                        col.tooltip= "IMO_Desciption", 
                        col.event = "IMO_Name", 
                        col.group = "IMO_LOE", 
                        col.start = "IMO_StartDate", 
                        col.end = "IMO_ProposedEndDate", 
                        col.color = "IMO_Color")
  
  higherCal <- vistime(df2,linewidth = 15, 
                       optimize_y = TRUE, 
                       show_labels = TRUE, 
                       col.event = "Event_Name", 
                       col.group = "Unit_Name", 
                       col.start = "Start_date", 
                       col.end = "End_date")

  fig <- subplot(opApproach, higherCal, margin = .001, heights = c(.6,.3), nrows = 2, 
                 shareX = TRUE)  %>%
    layout(dragmode = "pan",
           height = 750,  # look into minreducedheight
           xaxis=list(range = c(Sys.Date(), Sys.Date()+183),
                      tickfont=list(size=12, color="black"),
                      tickangle=-90, side="bottom",
                      tick0=Sys.Date(),
                      dtick = "M1",
                      rangeselector = list(
                        buttons = list(
                          list(count = 3,
                               label = "3 months",
                               step = "month",
                               stepmode = "backword"),
                          list(count = 6,
                               label = "6 months",
                               step = "month",
                               stepmode = "backword"),
                          list(count = 1,
                               label = "1 year",
                               step = "year",
                               stepmode = "backword")
                          ))
                      #rangeslider = list(type = "date", thickness = .08)
                      ),
                      #minor_dtick = 86400000.0,
                      #minor_griddash="dash"
           yaxis=list(tickangle=-90,
                      tickfont=list(size=14,
                                    family = "Arial Black",
                                    fixedrange=TRUE,
                                    color="black")),
           yaxis2=list(tickangle=-90,
                       tickfont=list(size=14,
                                    fixedrange=TRUE,
                                    color="black")),
           title = list(text = "Operational Approach",
                        y = .98,
                        font = list(family = "Arial Black", 
                                    size = 32, 
                                    color = "black"))
           )
    
    return(fig)
  }

get_LOE <- function(df, loe_label) {
  loe_DF <- TestCampdata[which(TestCampdata$IMO_LOE == loe_label),]
  plot <- vistime(loe_DF, linewidth = 20, col.event = "IMO_Name", col.group = "IMO_SubLOE", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
  return (plot %>% 
    layout(dragmode = "pan",
           height = 500,
           xaxis=list(range = c(Sys.Date(), Sys.Date()+183),
                      tickfont=list(size=12, color="black"),
                      tickangle=-90, side="bottom",
                      tick0=Sys.Date(),
                      dtick = "M1"),
           yaxis=list(tickfont=list(size=14,
                                    family = "Arial Black",
                                    fixedrange=TRUE,
                                    color="black")),
           title = list(text = paste(loe_label, "LOE Approach", sep=": "),
                        y = .98,
                        font = list(family = "Arial Black", 
                                    size = 32, 
                                    color = "black")),
           margin = list(t=100)
    ))
}
