#' find_nhance
#' @author fanchenzashi
#' @param year_begin the year begin
#' @param year_end the year end
#' @name find_nhance
#' @description find nhance data and download it.
#' @return title
#' @export nhance

find_nhance <- function(year_begin,year_end){

#查看网页基本信息
url <- c("https://wwwn.cdc.gov/nchs/nhanes/search/datapage.aspx?Component=Questionnaire&CycleBeginYear=1999")

title_all <- xml2::read_html(url,encoding = 'utf-8') %>%
  rvest::html_nodes("#GridView1 > tbody") %>%
  rvest::html_text()
number <- str_split(title_all,'Data')
a <- summary(number)
b <- as.numeric(a[1])-1
#GridView1 > tbody > tr:nth-child(1) > td:nth-child(3) > a
#GridView1 > tbody > tr:nth-child(44) > td:nth-child(3) > a

#设置节点，并找到网页中的文件
node <- data.frame()
for(n in 1:b){
node <-rbind(node,paste0('#GridView1 > tbody > tr:nth-child(',n,') > td:nth-child(3) > a'))
}
colnames(node) <- 'nodes'

title <- data.frame()
for (i in 1:nrow(node)) {
  title <-  rbind(title,read_html(url,encoding = 'utf-8') %>%
             rvest::html_nodes(node[i,]) %>%
               rvest::html_text())
}
colnames(title) <- 'files'
title_s <- tidyr::separate(title,files,'filename',' ')
#下载数据

web <- data.frame()
for (i in 1:nrow(title_s)) {
  web <- rbind(web,web=paste0("/Nchs/Nhanes/",year_begin,'-',year_end,"/",title_s[i,],".XPT"))
  }

colnames(web) <- 'web'

# 连接成网址
web_link <- data.frame()
for (i in 1:nrow(web)) {
 web_link <- rbind(web_link,paste0('https://wwwn.cdc.gov',web[i,],sep = ''))
}
dir.create('./download_file')
setwd('./download_file')
for (i in 1:nrow(web_link)) {
  utils::download.file(web_link[i,],destfile = paste0(title_s[i,],'.XPT'))
}
return(title)
}
