# infra_wrangle_v2
library(tidyverse)

gop23_raw <- read_csv("data/gop23_05-12.csv") %>%
  # glimpse()
  select(n_proyecto, proy, direccion, cui, intervenciones,
         presupuesto_estimado = ppto_estimado, 
         estado, subestado, fuente,
         pase_dgar = contains("dgar"), inicio_obra, plazo_obra, ampliacion_plazo, 
         avance_de_obra = avance_de_obra_real, fin_obra, 
         # expediente, 
         eje = programa, ano_plan) %>% 
  drop_na(proy) %>% 
  glimpse()

gop24_raw <- read_csv("data/gop24_05-12.csv") %>% 
  select(n_proyecto, proy, direccion, cui, intervenciones,
         presupuesto_estimado = ppto_estimado, 
         estado, subestado, fuente,
         pase_dgar = contains("dgar"), inicio_obra, plazo_obra, ampliacion_plazo, 
         avance_de_obra = avance_de_obra_real, fin_obra, 
         # expediente, 
         eje = programa, ano_plan) %>% 
  mutate(across(everything(), ~as.character(.))) %>%
  glimpse()

gop23_left <- gop23_raw %>% 
  anti_join(gop24_raw, by = c("proy","direccion")) %>% 
  glimpse()

gop_raw <- bind_rows(gop24_raw,gop23_left) %>% 
  # mutate(ano_plan = parse_number(ano_plan)) %>% 
  # distinct(ano_plan) %>% 
  glimpse()

# gop_raw  %>% 
#   # select(-n_proyecto) %>% 
#   janitor::get_dupes(proy,cui) %>% 
#   # mutate(dup = duplicated()) %>% 
#   view()

plani_clean <- gop_raw %>% 
  filter(!is.na(proy)) %>%
  mutate(subestado = str_to_lower(subestado), 
         cui = str_squish(cui), 
         estado = str_to_title(estado), 
         intervenciones = str_to_sentence(intervenciones)) %>% 
  #saco obras con problemas en el cui
  drop_na(cui) %>%
  mutate(inicio_obra = case_when(is.na(inicio_obra) ~ "Sin fecha de inicio", 
                                 T ~ inicio_obra), 
         plazo_obra = case_when(is.na(plazo_obra) ~ "Sin plazo", 
                                T ~ plazo_obra)) %>% 
  mutate(intervenciones = case_when(is.na(intervenciones) ~ "Alcance a definir", 
                                    T ~ intervenciones)) %>% 
  
  mutate(cui = str_pad(cui, 7, "left", "0")) %>% 
  mutate(fin_obra = case_when(is.na(fin_obra) ~ " - ",
                              fin_obra == "-" ~ " - ",
                              T ~ fin_obra)
         # fin_obra = case_when(n_proyecto == "x043" ~ "PARA RESCINDIR",
         #                T ~ fin_obra)
  ) %>% 
  mutate(ano_plan = case_match(ano_plan, .default = ano_plan, 
                               c("2021","2022","2023") ~ "2021 - 2023", 
                               c("2024","2025","2026","2027","2027") ~ "2024 - 2027")) %>% 
  glimpse()

write_csv(plani_clean, "data/infra_gop_05-12.csv")



