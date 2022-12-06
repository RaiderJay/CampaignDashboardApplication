
library(jsonlite)
library(openxlsx)
library(tools)

# proper headers for Data Columns
dataHeaders <- c("IMO_ID","IMO_Name","IMO_Owner","IMO_LOE","IMO_SubLOE",
                 "IMO_Color","IMO_Dep","IMO_Desciption","IMO_Conditions", 
                 "IMO_ConStat", "IMO_Stat", "IMO_Stat", "IMO_OverallStat", 
                 "IMO_SupportedOBJ", "IMO_StartDate", "IMO_ProposedEndDate", 
                 "IMO_ActualEndDate")

# created dummy data frame for testing
TestCampdata <- data.frame(
  IMO_ID = c("1.a.1","1.a.2","1.b.1","1.c.1","2.a.1", "2.b.1", "2.c.1", "2.d.1","2.e.1","2.f.1","3.a.1","3.b.1","3.c.1","3.c.2","3.c.3","3.c.4"),
  IMO_Name = c("Get Robo Cop", "Develop Iron Man MOS", "Develop Thick Skin", "Be Awesome","Going Full Rambo", "Space Cyber Exercise", "HQ, HQ, HQ", "Ghost in the Machine", "Biggest Data", "Spy vs Spy", "That's a Good Cap", "Liquid Paper on a Bee","Optimus Prime at AOB","Issue Laser Guns","Plasma Armor","Mind Control"),
  IMO_Owner = c("G1","G1","HPW","Chaplain","G35","G37","G37","G35","G9","G2","G8","G8","G8","G8","G8","G8"),
  IMO_LOE = c("People","People","People","People","Win","Win","Win","Win","Win","Win","Innovate","Innovate","Innovate","Innovate","Innovate", "Innovate"),
  IMO_SubLOE =  c("manning","manning","resiliency","culture & community","Optimize for IW","Ops, Training, & Exp","C & C HQs","Value Messaging","Optimized for IA","Protection","Cap Analysis","Emerging Solutions","Transformation","Transformation","Transformation","Transformation"),
  IMO_Color = c( "#00EEEE", "#00EEEE", "#00CDCD", "#008B8B", "#556B2F", "#CAFF70", "#BCEE68", "#A2CD5A", "#6E8B3D", "#8B7355", "#EE7600", "#CD6600", "#8B4500", "#8B4500", "#8B4500", "#8B4500"),
  IMO_Dep = c("","","","1.b.1","","1.a.1","","","","","","","","","",""),
  IMO_Desciption = c("Recruiting Robo Cop to improve cross-functional teams.","Develop MOS to operated new iron man suits optimizing for IW.","Improve resiliency by developing thick skin and fostering critical feedback.","Just be awesome - enough said.","Be a good guerilla like Rambo in all 18 of the movies.","Triad exercise to test capability across the functional ASCCs.","More HQs, more Command and Control, more effects, more competition.","Make sick recruiting videos.","You have big data, we have the biggest data.","Recreated protection mechanisms as envisioned by SNL.","Analyzed capabilities if good label it as good cap, else label as bad cap.","Putting in the R&D man hours, we put liquid paper on a bee, it died.","Transform more than meets the eye, transform innovation in disguise.","Transform the formation from chemically propelled ballistics to energy weapons","Transform the formation from ballistic armor to force fields","Execute order sixty six"),
  IMO_Conditions = c("1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3","1,2,3"),
  IMO_ConStat = c("Complete,Incomplete,Incomplete", "Incomplete,Incomplete,Incomplete", "Incomplete,Incomplete,Incomplete", "Incomplete,Incomplete,Incomplete", "Incomplete,Incomplete,Incomplete", "Incomplete,Incomplete,Incomplete", "Complete,Incomplete,Incomplete", "Complete,Complete,Incomplete", "Incomplete,Incomplete,Incomplete","Complete,Complete,Incomplete","Complete,Complete,Incomplete", "Incomplete,Incomplete,Incomplete","Incomplete,Incomplete,Incomplete","Incomplete,Incomplete,Incomplete","Incomplete,Incomplete,Incomplete","Complete,Incomplete,Incomplete"),
  IMO_Stat = c(0,0,0,0,4,4,4,0,2,1,4,2,4,4,4,4),
  IMO_OverallStat = c("Incomplete","Incomplete","Complete","Complete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete","Incomplete"),
  IMO_SupportedOBJ = c("Optimize for IW","Optimize for IW","","","Optimize for IW","Adaptive and Defendable Capabilities and Assets","SOJTF-C","Optimize for IA","Optimize for IA","Adaptive and Defendable Capabilities and Assets","Develop and Deliver Relevant Capabilities to the Future Force","Develop and Deliver Relevant Capabilities to the Future Force","Develop and Deliver Relevant Capabilities to the Future Force","Develop and Deliver Relevant Capabilities to the Future Force","Develop and Deliver Relevant Capabilities to the Future Force", "Develop and Deliver Relevant Capabilities to the Future Force"),
  IMO_StartDate = c(Sys.Date() - 10, Sys.Date() + 30, Sys.Date() - 15, Sys.Date() + 120, Sys.Date() + 48, Sys.Date() + 120, Sys.Date() - 10, Sys.Date() - 10, Sys.Date() - 15, Sys.Date() - 10, Sys.Date() - 10, Sys.Date() - 15, Sys.Date() + 120, Sys.Date() + 182, Sys.Date() + 90, Sys.Date() + 200),
  IMO_ProposedEndDate = c(Sys.Date() -1, Sys.Date() + 210, Sys.Date() + 80, Sys.Date() + 182, Sys.Date() + 48,Sys.Date() + 190, Sys.Date() + 40,Sys.Date() + 36, Sys.Date() + 165,Sys.Date() + 45,Sys.Date() + 30,Sys.Date() + 49, Sys.Date() + 296,Sys.Date() + 252, Sys.Date() + 180, Sys.Date() + 365),
  IMO_ActualEndDate = c(Sys.Date() + 45, Sys.Date() + 210, Sys.Date() + 80, Sys.Date() + 182, Sys.Date() + 48,Sys.Date() + 190, Sys.Date() + 40,Sys.Date() + 36, Sys.Date() + 165,Sys.Date() + 45,Sys.Date() + 30,Sys.Date() + 49, Sys.Date() + 296,Sys.Date() + 252, Sys.Date() + 180, Sys.Date() + 365),
  stringsAsFactors = FALSE
)

TestHigherData <- data.frame(
  Unit_Name = c("Cats","Cats","Cats","A Unit","A Unit"),
  Event_Type = c("Training Event","Training Event","Key Event","PPBE","PPBE"),
  Event_Name = c("Space Attack", "Colonize Mars", "Pay the Bills", "Plan Money", "Program Money"),
  Start_date = c(Sys.Date() + 30, Sys.Date() + 60, Sys.Date() + 45,Sys.Date(),Sys.Date() + 100),
  End_date = c(Sys.Date() + 60, Sys.Date() + 100,Sys.Date() + 80, Sys.Date() + 100, Sys.Date() + 400),
  stringsAsFactors = FALSE
)

# convert data to the correct time format
#TestCampdata$IMO_StartDate <- as.Date(TestCampdata$IMO_StartDate, format = "%d-%b-%y" )
#TestCampdata$IMO_ProposedEndDate <- as.Date(TestCampdata$IMO_ProposedEndDate, format = "%d-%b-%y" )

#print(TestHigherData)
#TestHigherData$Start_date <- as.Date(TestHigherData$Start_date, format = "%d-%b-%y" )
#TestHigherData$End_date <- as.Date(TestHigherData$End_date, format = "%d-%b-%y" )


# data to file @Future need to add try catch in are for error handling 
save_data <- function(df, filename) {
  #need to check if df is dataframe
  #need to check if filename is string
 
  if (file.exists(filename) != TRUE) {
    file.create(filename)
    print("here")
  } 
  fileConn <- file(filename)
  writeLines(jsonlite::toJSON(df, pretty = TRUE), fileConn)
  close(fileConn)
}

# data from file @FUTURE need to add try and catch statements for reading
read_data <- function(filename) {
  #need to check if df is dataframe
  #need to check if filename is string
  df <- as.data.frame(jsonlite::fromJSON(filename)) 
  return(df)
}


# function for importing an excel spreadsheet into a dataframe
upload_excel <- function(filename) {
  out <- tryCatch(
    {
      # check if the file has excel extension
      print(filename)
      if(file_ext(filename) != "xlsx"){
        stop("File missing xlsx extension")
      }
      

      df <- read.xlsx( filename, 1, startRow = 1, 
                             colNames = TRUE, rowNames = FALSE, 
                             detectDates = TRUE, skipEmptyRows = TRUE, 
                             skipEmptyCols = TRUE, rows = NULL, cols = NULL, 
                             na.strings = "NA",)
      sapply(df, class)
      
      #check if column headers are correct
      for(column_header in dataHeaders){
        if(! any(grepl(column_header,colnames(df)))){
          stop(paste0("Missing column header:", column_header,"\n"))
        } 
      }
      
      if(typeof(df$IMO_StartDate) != "double"){
        #covert to date number
        df$IMO_StartDate <- convertToDate(df$IMO_StartDate)
      }
      
      if(typeof(df$IMO_ProposedEndDate) != "double"){
        #covert to date number
        df$IMO_ProposedEndDate <- convertToDate(df$IMO_ProposedEndDate)
      }
      
      if(typeof(df$IMO_ActualEndDate) != "double"){
        #covert to date number
        df$IMO_ActualEndDate <- convertToDate(df$IMO_ActualEndDate)
      }
      
      return(df)
      
    },
    error=function(cond) {
      message("Excel not imported due to the following Error:")
      message(cond)
      return(NA)
    }
  )
}

# function for exporting a dataframe as an excel spreadsheet
export_excel <- function(df, filename) {

  #
  out <- tryCatch(
    {
      # check if input is a dataframe
      if (typeof(df) != "list"){
        stop("Need to pass a vaild data frame to the function export_excel")
      }
      
      #check if column headers are correct
      for(column_header in dataHeaders){
        if(! any(grepl(column_header,colnames(df)))){
          stop(paste0("Missing column header:", column_header,"\n"))
        } 
      }
      
      #check if writing a file ending in xlsx
      if(file_ext(filename) != "xlsx"){
        filename <- paste0(filename,".xlsx")
      }
      
      # write dataframe to excel
      write.xlsx(df, filename, overwrite = TRUE)
      
    },
    error=function(cond) {
      message("Excel not exported due to the following Error:")
      message(cond)
    }
  )    
}
