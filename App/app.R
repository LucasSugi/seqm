# Imports
library(shinydashboard)
library(rhandsontable)
library(readxl)
library(dplyr)
library(stringr)
library(jsonlite)

# Read data
seqm = read_excel(paste(dirname(getwd()),'/seqm_user.xlsx',sep = ''))
seqm_detail = read_excel(paste(dirname(getwd()),'/seqm_user_detail.xlsx',sep = ''))

# Convert comma to dots
seqm$Pontos = sapply(seqm$Pontos, function(x) {return (str_replace(x,',','.'))})

# Convert to numeric
seqm$Pontos = as.numeric(seqm$Pontos)

# Sort data by "Pontos"
seqm = seqm %>% arrange(desc(Pontos))


filter_dataframe <- function(name_id) {
  
  # Get the user_id
  user_id = (seqm %>% filter(Proprietario == name_id))$Id
  
  
  # Get informations about user's animal
  animal_df = seqm_detail %>% filter(Id_User == user_id)
  animal_df = data.frame(animal_df)
  
  return (animal_df[c(1,2,3,5)])
}

# Dashboard header
header <- dashboardHeader(title='Company')

# Dashboard sidebar  
sidebar <- dashboardSidebar(
  selectizeInput(
    inputId = "search_id"
    , choices = sort(seqm$Proprietario)
    , label = "Search a person"
    , options = list(
      placeholder = "Search.."
      , onInitialize = I('function() { this.setValue(""); }')
    )
  )
)

seqm %>% arrange(desc(Pontos))

# Dashboard body
body <- dashboardBody(
  
  tags$head(tags$style(HTML('
    .content-wrapper, .right-side {
    background-color: #FFFFFF;
    }
  ')))
  
  , fluidRow(
    
    # Dinamyc ValueBox
    valueBoxOutput("score_box"),
    
    # Dinamyc ValueBox
    valueBoxOutput("city_box"),
    
    # Dinamyc ValueBox
    valueBoxOutput("state_box")
  )
  
  , fluidRow(
    
    # Dinamyc ValueBox
    valueBoxOutput("best_horse_box", width = 6),
    
    # Dinamyc ValueBox
    valueBoxOutput("count_horse_box", width = 6),
  )
  
  , fluidRow (
    # Dinamyc table
    rHandsontableOutput('table')
  )
)

# Creating ui
ui = dashboardPage(header, sidebar, body)

render_window <- function(output,score_box.title,city_box.title,state_box.title,best_horse_box.title,count_horse_box.title,table.df) {
  output$score_box <- renderValueBox({
    valueBox(
      score_box.title
      , "Pontos"
      , icon = icon("bullseye", lib = "font-awesome")
      , color = "yellow"
    )
  })
  
  
  output$city_box <- renderValueBox({
    valueBox(
      city_box.title
      , "Cidade"
      , icon = icon("city", lib = "font-awesome")
      , color = "yellow"
    )
  })
  
  
  output$state_box <- renderValueBox({
    valueBox(
      state_box.title
      , "UF"
      , icon = icon("city", lib = "font-awesome")
      , color = "yellow"
    )
  })
  
  
  output$best_horse_box <- renderValueBox({
    valueBox(
      best_horse_box.title
      , "Melhor Cavalo"
      , icon = icon("bullseye", lib = "font-awesome")
      , color = "navy"
    )
  })
  
  
  output$count_horse_box <- renderValueBox({
    valueBox(
      count_horse_box.title
      , "Quantidade de Cavalos"
      , icon = icon("bullseye", lib = "font-awesome")
      , color = "navy"
    )
  })
  
  # Criando tabela vazia
  output$table <- renderRHandsontable(
    rhandsontable(table.df)  
  )
}

# Creating server
server <- function(input, output) {
  
  # Renderiza a tela
  render_window(output,"Pontos","Cidade","UF","Melhor Cavalo","Quantidade de Cavalos",data.frame(Animal=character(),Sexo=character(),Nascimento=character(),Pontos=character()))
  
  observeEvent(input$search_id,{
    if(input$search_id != ""){

      # Renderiza a tela
      render_window(output,(seqm %>% filter(Proprietario == input$search_id))$Pontos,(seqm %>% filter(Proprietario == input$search_id))$Cidade,(seqm %>% filter(Proprietario == input$search_id))$UF,head(filter_dataframe(input$search_id),1)$Animal,nrow(filter_dataframe(input$search_id)),filter_dataframe(input$search_id))
    }
  })
}

# Run app
shinyApp(ui = ui, server = server)