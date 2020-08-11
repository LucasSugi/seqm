# Imports
library(shinydashboard)
library(readxl)
library(dplyr)
library(stringr)

# Read data
seqm = read_excel(paste(dirname(getwd()),'/seqm_user_updated.xlsx',sep = ''))
seqm_detail = read_excel(paste(dirname(getwd()),'/seqm_user_detail_updated.xlsx',sep = ''))

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
    tableOutput('table')
  )
)

# Creating ui
ui = dashboardPage(header, sidebar, body)

# Creating server
server <- function(input, output) {
  output$score_box <- renderValueBox({
    if(input$search_id == ""){
      valueBox(
        "Pontos"
        , "Pontos"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "yellow"
      )
    } else {
      valueBox(
        (seqm %>% filter(Proprietario == input$search_id))$Pontos
        , "Pontos"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "yellow"
      )
    }
  })
  
  output$city_box <- renderValueBox({
    if(input$search_id == ""){
      valueBox(
        "Cidade"
        , "Cidade"
        , icon = icon("city", lib = "font-awesome")
        , color = "yellow"
      )
    } else {
      valueBox(
        (seqm %>% filter(Proprietario == input$search_id))$Cidade
        , "Cidade"
        , icon = icon("city", lib = "font-awesome")
        , color = "yellow"
      )
    }
  })
  
  output$state_box <- renderValueBox({
    if(input$search_id == ""){
      valueBox(
        "UF"
        , "UF"
        , icon = icon("city", lib = "font-awesome")
        , color = "yellow"
      )
    } else {
      valueBox(
        (seqm %>% filter(Proprietario == input$search_id))$UF
        , "UF"
        , icon = icon("city", lib = "font-awesome")
        , color = "yellow"
      )
    }
  })
  
  output$best_horse_box <- renderValueBox({
    if(input$search_id == ""){
      valueBox(
        "Melhor Cavalo"
        , "Melhor Cavalo"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "navy"
      )
    } else {
      valueBox(
        head(filter_dataframe(input$search_id),1)$Animal
        , "Melhor Cavalo"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "navy"
      )
    }
  })
  
  output$count_horse_box <- renderValueBox({
    if(input$search_id == ""){
      valueBox(
        "Quantidade de Cavalos"
        , "Quantidade de Cavalos"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "navy"
      )
    } else {
      valueBox(
        nrow(filter_dataframe(input$search_id))
        , "Quantidade de Cavalos"
        , icon = icon("bullseye", lib = "font-awesome")
        , color = "navy"
      )
    }
  })
  
  output$table <- renderTable(
    if(input$search_id == ""){
      data.frame(Animal="",Sexo="",Nascimento="",Pontos="")
    } else {
      filter_dataframe(input$search_id)
    }
    , striped = TRUE
    , hover = TRUE
    , bordered = TRUE
    , align = 'c')
}

# Run app
shinyApp(ui = ui, server = server)