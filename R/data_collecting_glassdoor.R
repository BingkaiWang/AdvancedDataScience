# Web scraping data from glassdoor.com with job title 'data scientist'
# Using package 'rvest' for scparing and collecting raw data for
# company name, location (city, state) and job description
# Output a csv file containing above information.
# The following code can be easily generalized into thousands of jobs.

require(rvest)
library(dplyr)
library(stringr)

#Initializing
webpages <- 5 # 30 jobs per page
company <- rep(NA, webpages * 30)
location <- rep(NA, webpages * 30)
description <- rep(NA, webpages * 30)
companysize <- rep(NA, webpages * 30)
industry <- rep(NA, webpages * 30)
rating <- rep(NA, webpages * 30)
salary <- rep(NA, webpages * 30)
currentpage <- html_session("https://www.glassdoor.com/Job/jobs.htm?suggestCount=0&suggestChosen=true&clickSource=searchBtn&typedKeyword=data+sc&sc.keyword=data+scientist&locT=&locId=&jobType=")
ptm <- proc.time()

# scaping
for(i in 1:webpages){
  info <- currentpage %>% html_nodes(".jl") %>% html_text
  rating[(i-1) * 30 + (1:30)] <- str_extract(info, pattern = "^ [:digit:].[:digit:]") %>% trimws
  salary[(i-1) * 30 + (1:30)] <- str_extract(info, pattern = "\\$.*\\(Glassdoor") %>% str_sub(1, -11)
  link <- currentpage %>% html_nodes("#MainCol .flexbox .jobLink") %>% html_attr("href")
  if(length(link) != 30) stop("wrong length of link")
  link <- paste('https://www.glassdoor.com', link, sep = '')
  for(j in 1:30){
    currentlink <- link[j]
    subpage <- html_session(currentlink) # jump to the second level webpage
    if(grepl("glassdoor", subpage$url)){
      company[(i-1) * 30 + j] <- subpage %>% html_node(".padRtSm") %>% html_text()
      location[(i-1) * 30 + j] <- subpage %>% html_node(".subtle") %>% html_text()
      description[(i-1) * 30 + j] <- subpage %>% html_node(".desc") %>% html_text()
      sourcefile <- suppressWarnings(readLines(currentlink))
      pinpoint <- grep("employer", sourcefile)
      sourcefile <- sourcefile[pinpoint[1]+ 0:20]
      current_industry <- sourcefile[str_detect(sourcefile, "\'industry\'")] %>%
        str_extract("\"(.*)\"") %>% 
        str_sub(2, -2)
      industry[(i-1) * 30 + j] <- if(length(current_industry)>0){current_industry}else{NA}
      current_size <- sourcefile[str_detect(sourcefile, "\'size\'")] %>%
        str_extract("\"(.*)\"") %>% 
        str_sub(2, -2)
      companysize[(i-1) * 30 + j] <- if(length(current_size)>0){current_size}else{NA}
    }
    Sys.sleep(1)
  }
  # navigate to next page
  nextpage <- paste0('www.glassdoor.com/Job/data-scientist-jobs-SRCH_KO0,14_IP', 
                     as.character(i+1), '.htm')
  # nextpage <- currentpage %>% html_nodes("#FooterPageNav a") %>% html_attr("href")
  # nextpage <- paste('www.glassdoor.com', nextpage, sep = '')
  currentpage <- html_session(nextpage)
  
  Sys.sleep(5)
}
proc.time() - ptm

# preprocessing location data for output
location <- trimws(location)
type1_indi <- grepl("[[:alpha:]]", str_sub(location, 1, 1))
location[!type1_indi] <- sapply(location[!type1_indi], 
                                function(s) substr(s, 4, nchar(s)))
location <- location %>% str_split(", ") 
for(i in 1: (webpages*30)){
  n <- length(location[[i]])
  if(n == 1){
    location[[i]] <- c(NA, NA)
  }else if(n > 2){
    location[[i]] <- location[[i]][-(1:(n-2))]
  }
}
location <- t(as.data.frame(location))

#output data frame
demo_raw_data <- data.frame(company = trimws(company), 
                            rating = as.numeric(rating),
                            salary = salary,
                            city = location[,1], 
                            state = location[,2], 
                            description = description,
                            companysize = companysize,
                            industy = str_replace_all(industry, "&amp;", "&"))
rownames(demo_raw_data) <- NULL

write.csv(demo_raw_data, "demo_raw_data.csv")
