#library('igraph')
library("plotly")
library("vistime")
library("sys")
library("lubridate")
library("dplyr") 
library(hash)

#get OP Approach for display
get_OpApproach <- function(df1, df2) {
  
  #get two timeline sub_plots
  opApproach <- vistime(df1, linewidth = 20, 
                        optimize_y = TRUE, 
                        show_labels = TRUE, 
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
                                    color = "black")),
           margin = list(t=50)
           )

    return(fig)
  }

get_LOE <- function(df, loe_label) {
  loe_DF <- df[which(df$IMO_LOE == loe_label),]
  plot <- vistime(loe_DF, linewidth = 20, col.event = "IMO_Name", col.group = "IMO_SubLOE", col.start = "IMO_StartDate", col.end = "IMO_ProposedEndDate", col.color = "IMO_Color")
  return (plot %>% 
    layout(dragmode = "pan",
           height = 500,
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
                      ),
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

get_completionRate <- function(df, s_date, e_date) {
  df <- df[df$IMO_ProposedEndDate >= s_date & df$IMO_ProposedEndDate <= e_date, ]
  p_comp = nrow(df)
  a_comp = nrow(df[which(df$IMO_OverallStat == "Complete"),]) #need to noramalize data

  TotalSpeed <- plot_ly(
    domain = list(x = c(0, 1), y = c(0, 1)),
    value = a_comp,
    title = list(text = "Campaign IMO Performance"),
    type = "indicator",
    mode = "gauge+number+delta",
    delta = list(reference = 0),
    gauge = list(
       axis =list(range = list(NULL, p_comp)),
       bar = list(color = "darkblue"),
       steps = list(
         list(range = c(0, ceiling(p_comp * .25)), color = "red"),
         list(range = c(ceiling(p_comp * .25), ceiling(p_comp * .75)), color = "orange"),
         list(range = c(ceiling(p_comp * .75), p_comp), color = "green")
       ),
       threshold = list(
         line = list(color = "red", width = 4),
         thickness = 0.75,
         value = a_comp))) 
  return(TotalSpeed)
}

get_camp_stats <- function(df) {
  stats <- hash() 
  
  stats[["total_imo"]] <- nrow(df)
  stats[["total_complete"]] <- nrow(df[which(df$IMO_OverallStat == "Complete"),])
  stats[["total_outstanding"]] <- stats[["total_imo"]] - stats[["total_complete"]]
  stats[["total_overdue"]] <-  nrow(df[which(df[which(
    df$IMO_OverallStat != "Complete"),]$IMO_ProposedEndDate < Sys.Date()),])
  stats[["Off_Higher"]] <- nrow(df[which(df$IMO_Stat == 1),])
  stats[["Off_Staff"]] <- nrow(df[which(df$IMO_Stat == 2),])
  stats[["Off_Sec"]] <- nrow(df[which(df$IMO_Stat == 3),])
  stats[["OT"]] <- nrow(df[which(df$IMO_Stat == 4),])
 

  #Sys.Date()
  
  return(stats)
}

get_total_stats_charts <- function(df) {
  
  c <- nrow(df[which(df$IMO_OverallStat == "Complete"),])
  o <- nrow(df[which(df$IMO_OverallStat == "Incomplete"),])
  
  labels = c('Total IMOs Completed','Total IMOs Outstanding')
  values = c(c, o)
  
  fig1 <- plot_ly(type='pie', labels=labels, values=values, 
                 textinfo='label+percent',
                 insidetextorientation='radial',
                 showlegend = FALSE,
                 textposition = 'inside',
                 domain = list(x = c(0.0, 0.25, .25), y = c(0, 1)),hole = 0)

  stat <- df
  stat$year_month <- floor_date(stat$IMO_ProposedEndDate, "month")
  stat['value'] <- 1
  
  stat_aggr <- stat %>%                         # Aggregate data
    group_by(year_month) %>% 
    dplyr::summarize(value  = sum(value )) %>% 
    as.data.frame()
  
  fig2 <- plot_ly(
    x = stat_aggr$year_month,
    y = stat_aggr$value,
    name = "Projected Completion By Month",
    type = "bar",
    showlegend = FALSE
  ) %>% layout(xaxis = list(dtick = "M1"))
  
  stat2 <- df
  stat2$year_month <- floor_date(stat2$IMO_ActualEndDate, "month")
  stat2['value'] <- 1
  
  stat_aggr2 <- stat2 %>%                         # Aggregate data
    group_by(year_month) %>% 
    dplyr::summarize(value  = sum(value )) %>% 
    as.data.frame()
  
  fig3 <- plot_ly(
    x = stat_aggr$year_month,
    y = stat_aggr$value,
    name = "Actual Completion By Month",
    type = "bar",
    showlegend = FALSE
  ) %>% layout(xaxis = list(dtick = "M1"))
  
  annotations = list( 
    list( 
      x = 0.1,  
      y = 1.0,  
      text = "Overall IMOs Achieved vs Outstanding",  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ),  
    list( 
      x = 0.5,  
      y = 1.0,  
      text = "Projected IMO Completion By Month",  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ), 
    list( 
      x = 0.9,  
      y = 1,  
      text = "Actual IMO Completion By Month",  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ))
  
  fig4 <- subplot(fig1, fig2, fig3) %>% layout(annotations = annotations) 
  
  return(fig4)
}

get_current_status <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- nrow(incomp[which(incomp$IMO_Stat == 1),])
  otStaff <- nrow(incomp[which(incomp$IMO_Stat == 2),])
  otSec <- nrow(incomp[which(incomp$IMO_Stat == 3),])
  onT <- nrow(incomp[which(incomp$IMO_Stat == 4),])
  ns <- nrow(incomp[which(incomp$IMO_Stat == 0),])
  
  labels = c('Off Track (higher Assistance)','Off Track (staff Assistance)', 'Off Track (internal)', 'On Track', 'Not Started/removed')
  values = c(otHigher, otStaff, otSec, onT, ns)
  
  fig <- plot_ly(type='pie', labels=labels, values=values, 
                  textinfo='label+percent',
                  insidetextorientation='radial',
                  showlegend = TRUE,
                  textposition = 'inside') %>% layout(title = "Status of Outstanding IMOs") 
  return(fig)
}

get_otHigher <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- incomp[which(incomp$IMO_Stat == 1),]
  retdf <- select(otHigher,c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE","IMO_ProposedEndDate"))
  retdf %>% arrange(retdf$IMO_ProposedEndDate)
  return(retdf)
}

get_otStaff <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- incomp[which(incomp$IMO_Stat == 2),]
  retdf <- select(otHigher,c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE","IMO_ProposedEndDate"))
  retdf %>% arrange(retdf$IMO_ProposedEndDate)
  return(retdf)
}

get_otSec <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- incomp[which(incomp$IMO_Stat == 3),]
  retdf <- select(otHigher,c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE","IMO_ProposedEndDate"))
  retdf %>% arrange(retdf$IMO_ProposedEndDate)
  return(retdf)
}

get_onT <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- incomp[which(incomp$IMO_Stat == 4),]
  retdf <- select(otHigher,c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE","IMO_ProposedEndDate"))
  retdf %>% arrange(retdf$IMO_ProposedEndDate)
  return(retdf)
}

get_NS <- function(df) {
  incomp <- df[which(df$IMO_OverallStat == "Incomplete"),]
  otHigher <- incomp[which(incomp$IMO_Stat == 0),]
  retdf <- select(otHigher,c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE","IMO_ProposedEndDate"))
  #retdf <- retdf[rev(order(as.Date(retdf$IMO_ProposedEndDate))),]
  retdf %>% arrange(retdf$IMO_ProposedEndDate)
  return(retdf)
}

get_dep <- function(df) {
  #net <- graph_from_data_frame(d=df, vertices=nodes, directed=T) 
  #p <-plot(net)
}


#TotalSpeed <- plot_ly(
#  domain = list(x = c(0, 1), y = c(0, 1)),
#  value = TotalComplete,
#  title = list(text = "Campaign IMO Performance"),
#  type = "indicator",
#  mode = "gauge+number+delta",
#  delta = list(reference = 0),
#  gauge = list(
#    axis =list(range = list(NULL, TotalIMOs)),
#    bar = list(color = "darkblue"),
#    steps = list(
#      list(range = c(0, ceiling(TotalIMOs * .25)), color = "red"),
#      list(range = c(ceiling(TotalIMOs * .25), ceiling(TotalIMOs * .75)), color = "orange"),
#      list(range = c(ceiling(TotalIMOs * .75), TotalIMOs), color = "green")
#    ),
#    threshold = list(
#      line = list(color = "red", width = 4),
#      thickness = 0.75,
#      value = TotalComplete))) 
