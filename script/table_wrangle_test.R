#BASE EDIFICIOS CUI+NOMBRE en una sola línea.  V2
pacman::p_load(tidyverse,readxl)
options(scipen = 999)

#Limpieza del crudo de mantenimiento
#Raw data

raw_resumida <- read_xlsx("data/Base de Edificios_08_03.xlsx", 
                          sheet = "BASE_RESUMIDA") %>%
  glimpse()

raw_completa <- read_xlsx("../infra_reporte/data/Base de Edificios_08_03.xlsx", 
                          sheet = "BASE CON CUE_CUI COMPLETA") %>% 
  janitor::clean_names() %>% 
  glimpse()



## Primero agarro solo base resumida

clean_resumida <- raw_resumida %>% 
  janitor::clean_names() %>% 
  select(comuna,distrito,domicilio_edificio,cui) %>% c
# mutate(cui = str_pad(cui, width = 7, side = "left", pad = 0)) %>% 
glimpse()

write_csv(clean_resumida,"~/Documents/rst/megcba/sistemaBochi/data/base_resumida.csv")  

#Limpio base completa con nombres ####

clean_completa <- raw_completa %>% 
  select(cui, domicilio_edificio, nombre_establecimiento) %>%
  group_by(cui) %>% 
  summarise(nombre_establecimiento = paste(nombre_establecimiento, collapse = " - ")) %>% 
  ungroup() %>% 
  inner_join(raw_completa %>% 
               distinct(cui, .keep_all = TRUE) %>% 
               select(cui,domicilio_edificio), by = "cui") %>% 
  mutate(cui = str_pad(as.character(cui), pad = "0", side = "left",width = 7)) %>%
  glimpse()

write_csv(clean_completa,"~/Documents/rst/megcba/sistemaBochi/data/base_completa.csv")  

library(tidyverse)

raw <- read_csv("data/base_completa.csv") %>% 
  glimpse()

base_resumida_link <- raw %>% 
  drop_na(cui) %>% #Hay que agregarle un cui a los NA (planetario, etc.). Ver como lo armo nico.
  mutate(nombre_establecimiento = str_replace_all(nombre_establecimiento, "\\'",replacement = " ")) %>% 
  mutate(domicilio_edificio = str_replace_all(domicilio_edificio, "\\'",replacement = " ")) %>% 
  # mutate("Comuna-Distrito" = paste0("C ",comuna, "- D.E. ",distrito)) %>% 
  # rename(Domicilio = domicilio_edificio) %>% 
  mutate(Domicilio = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", domicilio_edificio,"</a>")) %>% 
  mutate(Establecimiento = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", nombre_establecimiento,"</a>")) %>%
  rename(establecimiento = nombre_establecimiento) %>% 
  rename(domicilio = domicilio_edificio) %>% 
  # select(-any_of(c("domicilio_edificio"))) %>%
  glimpse()


write_csv(base_resumida_link,"data/base_completa_link_v3.csv")

# mutate(fecha = as.Date(feed_pub_date),
#        medio2 = as.factor(str_extract(item_link, "\\w*(?=\\.com|.net|.org|.gov|.gob)")), 
#        titulo = paste0("<a href='",.$item_link,"'>",.$titulo,"</a>")) %>% 
#   mutate(feed_title = as.factor(feed_title)) %>% 

#Dummy data in qmd, tests para base completa en source_pages_v2.R
data <- read_csv("../data/base_completa_link_v3.csv") %>%
  # janitor::clean_names() %>%
  # rename(ID = cui,
  #        Adress = domicilio_edificio
  #        ) %>%
  # mutate(School = paste0(Adress," ",ID)) %>%
  # slice_sample(n = 10) %>%
  # # # group_by(ID) %>% 
  # # # mutate(n = n()) %>% 
  # # # filter(n >1) %>% 
  # distinct(ID, .keep_all = TRUE) %>%
  # drop_na(ID) %>% 
glimpse()
