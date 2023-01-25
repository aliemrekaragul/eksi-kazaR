library("shiny")
library(rvest)
library(dplyr)
library(wordcloud)
library("stopwords")
library(wordcloud2)
library(stringr)  
library(tm)
library(bslib)
# UTILS########################################################################################################
###############################################################################################################
get_page_list <-function(url){
  html <- read_html(url)
  n_of_pages<- html %>% html_nodes(".pager")  %>%  html_attr("data-pagecount") %>% as.numeric()
  list_of_pages <- as.list(str_c(url, '?p=', 1:n_of_pages[1]))
  list_of_pages
  }
###############################################################################################################
get_entries <-function(url){
  html <- read_html(url)
  entries  <- html %>% html_nodes(".content") %>%html_text() 
  entries
}
######TEMA#####################################################################################################
tema <- bs_theme( bg= "white",fg = "navy", primary = "tomato",
                  base_font = font_google("Space Mono"),
                  code_font = font_google("Space Mono"),
                  heading_font =font_google("Roboto"),
)
###############################################################################################################




######UI#######################################################################################################

ui <- fluidPage(
  theme = tema,
  titlePanel("        Ekşi KazaR        "),
  sidebarLayout(
    sidebarPanel(width = 3,
                 tags$p(tags$b("Ekşi sözlükten özet gibi görseller")),
      textInput(inputId="url", 
                label="Ekşi sözlükteki herhangi bir başlığa ait URL'yi buraya kopyala:", 
                value = "https://eksisozluk.com/lord-of-the-rings--42275", 
                #width = NULL, 
                placeholder = "URL"),
      actionButton("goButton", "Başlığı Kaz!"),
      hr(),
      tags$p("*Doğrudan başlığa ait URL ile çalışır.  
        Bir hata görüyorsan Ekşi'de bir başlığa ait olmayan bir URL girmiş olabilirsin. ^^"
      ),
      hr(),
      sliderInput(inputId = "size",
                  label = "Zoom:",
                  min = 0.1,
                  max = 4,
                  value = 0.8,
                  step = 0.1),
      radioButtons(inputId = "shape",
                   label = "Şekil:",
                   choices = c('circle', 'diamond', 'triangle-forward', 'triangle', 'pentagon', 'star'),
                   selected = c('circle'),
                   ),
      radioButtons(inputId = "coloring", label = "Tema:",choices = c('dark', 'light'),selected = c('dark')),

    ),
    mainPanel(

      wordcloud2Output(outputId= "wordcloudOutput", width = "100%", height = "600px")
    )
  )
)

####server#####################################################################################################
options(shiny.sanitize.errors = TRUE)
server <- function(input, output ) {
  observeEvent( input$goButton, {
       isolate({
         if (input$url=='')   return(NULL)
         url<-input$url
         urls<-get_page_list(url)
         #####################################################progress bar#####################################
         compute_data <- function(updateProgress = NULL) {
           dat <- data.frame(x = numeric(0))
           
           for (i in 1:length(urls)) {
             Sys.sleep(1.3)
             new_row <- data.frame(x = rnorm(1), y = rnorm(1))
             if (is.function(updateProgress)) {
               text <- paste("Sayfa:", i,"/",length(urls) )
               updateProgress(detail = text)
             }
             dat <- rbind(dat, new_row)
           }
           
           dat
         }
         progress <- shiny::Progress$new()
         progress$set(message = "Başlık kazılıyor...", value = 0)
         on.exit(progress$close())
         updateProgress <- function(detail = NULL) {
           progress$inc(amount = 1/length(urls), detail = detail)
         }
         compute_data(updateProgress)
         ######################################################################################################
         entries<-lapply(urls, get_entries)
         entries<-gsub(" *\\b[[:alpha:]]{1}\\b *", " ", entries)
         entries<-Corpus(VectorSource(entries))
         entries <- entries %>% tm_map(removeNumbers)
         entries <- entries %>%
           tm_map(removePunctuation) %>%
           tm_map(stripWhitespace)
         entries <- tm_map(entries, content_transformer(tolower))
         tr_stopwords<-stopwords::stopwords("tr", source = "stopwords-iso")
         en_stopwords<-stopwords::stopwords("en", source = "snowball")
         tr_stopwords<-append(tr_stopwords, c("bkz", "rn","crn", "var", "vardir", "icin", "iste", "işte", "amk", "ameke"))
         entries<-unlist(entries)
         entries <- removeWords(entries, words=tr_stopwords)
         entries <- removeWords(entries, words=en_stopwords)
         term_matrix <- as.matrix(TermDocumentMatrix(entries) )
         word_freqs <- sort(rowSums(term_matrix),decreasing=TRUE) 
         word_freqs <- data.frame(word=names(word_freqs),freq=word_freqs )
         
output$wordcloudOutput<- renderWordcloud2({
    if (input$coloring=="light"){
      wordcloud2 (word_freqs, 
                  size = input$size, 
                  shape = input$shape, 
                  color='random-dark', 
                  backgroundColor="white" )
    }else{
      wordcloud2 (word_freqs, 
                  size = input$size, 
                  shape = input$shape, 
                  color='random-light', 
                  backgroundColor="black" )
    }

    })
    
  })
})
}
shinyApp(ui = ui, server = server)