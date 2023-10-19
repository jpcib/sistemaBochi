#Infraestructura wrangle
pacman::p_load(googlesheets4,tidyverse)
googlesheets4::gs4_auth()
options(scipen = 999)
"%ni%" <- Negate("%in%")


#PLANIFICACIÓN - Selección de columnas
# gop_raw <- 
#   googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/1Q1p_3pHECh8xOPOUeZj1bQV8dW7Ch1uJhk7-HFm3fRE/edit?usp=sharing",
#                             sheet = "Planificación 2022-23", col_types = "c") %>% 
#   janitor::clean_names() %>%
#   # glimpse()
#   #selecciono columnas para ME
#   select(n_proyecto, direccion = nivel_7, cui, estado_actual, estado_a_fin_de_obra, intervenciones,
#          presupuesto_estimado = ppto_estimado_plani, presupuesto_final = ppto_oficial, 
#          estado, subestado, fuente, 
#          pase_dgar = contains("dgar"), inicio_obra = contains("inicio_obra"), plazo_obra, ampliacion_de_plazo, 
#          avance_de_obra = avance_de_obra_real, fin_obra = contains("fin_obra"), 
#          expediente, 
#          eje) %>%
#   glimpse()

gop_raw <- read_csv("../infra_reporte/data/clean/plani_clean_17-10-23.csv") %>%
  # glimpse()
  select(n_proyecto, direccion, cui, intervenciones,
         presupuesto_estimado = ppto_estimado_plani, presupuesto_final = presupuesto, 
         estado, subestado, fuente,
         pase_dgar = contains("dgar"), inicio_obra = contains("inicio_obra"), plazo_obra, ampliacion_de_plazo, 
         avance_de_obra = avance_de_obra_real, fin_obra = contains("fin_obra"), 
         expediente, 
         eje) %>% 
  glimpse()

plani_clean <- gop_raw %>% 
  filter(!is.na(n_proyecto)) %>% 
  mutate(subestado = str_to_lower(subestado), 
         cui = str_squish(cui), 
         estado = str_to_title(estado), 
         intervenciones = str_to_sentence(intervenciones)) %>% 
  #saco obras relicitadas para quedarnos con el ultimo estado. 
  #Podemos ver de dejarlo como una anotacion luego. 
  filter(subestado %ni% c("fracaso / pase f11", "fracaso r", "f14 - fracaso - r", "f14 - caf - fracaso - r")) %>% #filtro (descarto) los fracasos que ya se relanzaron
  #saco obras con problemas en el cui
  drop_na(cui) %>%
  # filter(cui %ni% c("-","0000000","00000GG")) %>%  
  mutate(inicio_obra = case_when(is.na(inicio_obra) ~ "Sin fecha de inicio", 
                                 T ~ inicio_obra), 
         plazo_obra = case_when(is.na(plazo_obra) ~ "Sin plazo", 
                                T ~ plazo_obra)) %>% 
  
  mutate(cui = str_pad(cui, 7, "left", "0")) %>% 
  filter(estado != "Baja") %>% 
  mutate(fin_obra = case_when(is.na(fin_obra) ~ " - ",
                              fin_obra == "-" ~ " - ",
                              T ~ fin_obra)
         # fin_obra = case_when(n_proyecto == "x043" ~ "PARA RESCINDIR",
         #                T ~ fin_obra)
         ) %>% 
  glimpse()

DataExplorer::profile_missing(plani_clean)
# 
# plani_clean %>%
#   filter(is.na(inicio_obra)) %>%
#   view()

# writexl::write_xlsx(plani_clean %>% filter(is.na(inicio_obra)), "data/sin_fecha_inicio_gop.xlsx")

#OJO
#
write_csv(plani_clean, "data/infra_gop_18-10.csv")
