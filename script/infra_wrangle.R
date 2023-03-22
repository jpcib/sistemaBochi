#Infraestructura wrangle
pacman::p_load(googlesheets4,tidyverse)
googlesheets4::gs4_auth()
options(scipen = 999)
"%ni%" <- Negate("%in%")



#PLANIFICACIÓN - Selección de columnas
plani_raw <- 
  googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1Q1p_3pHECh8xOPOUeZj1bQV8dW7Ch1uJhk7-HFm3fRE/edit?usp=sharing",
                            sheet = "Planificación 2022-23", col_types = "c") %>% 
  janitor::clean_names() %>%
  select(n_proyecto,
         cui,
         direccion = proyecto,
         intervenciones, 
         estado,
         subestado,
         eje,
         nota_de_inicio,
         pase_dgar = contains("dgar"),
         inicio_obra = contains("inicio_obra"),
         fin_obra,
         avance_de_obra_real
         ) %>% 
  glimpse()

plani_clean <- plani_raw %>% 
  filter(!is.na(n_proyecto)) %>% 
  mutate(subestado = str_to_lower(subestado), 
         cui = str_squish(cui), 
         estado = str_to_title(estado), 
         intervenciones = str_to_sentence(intervenciones)) %>% 
  #saco obras relicitadas para quedarnos con el ultimo estado. 
  #Podemos ver de dejarlo como una anotacion luego. 
  filter(subestado %ni% c("fracaso / pase f11", "fracaso r", "f14 - fracaso - r")) %>% #filtro (descarto) los fracasos que ya se relanzaron
  #saco obras con problemas en el cui
  drop_na(cui) %>% 
  filter(cui %ni% c("-","0000000","00000GG")) %>%  
  # mutate(fecha = case_when(estado == "Planificado" ~ nota_de_inicio, 
  #                          estado == "En Proyecto" ~ nota_de_inicio,
  #                          estado == "Licitación" ~ pase_dgar,
  #                          estado == "En Obra" ~ inicio_obra,
  #                          estado == "Finalizado" ~ fin_obra, 
  #                          # is.na(estado) ~ "s/f",
  #                          T ~ "s/f")) %>% 
  # group_by(cui) %>%
  # mutate(n = n()) %>%
  # filter(n > 1) %>%
  # distinct(estado) %>% 
  glimpse()

write_csv(plani_clean, "data/infra_gop_v2.csv")
