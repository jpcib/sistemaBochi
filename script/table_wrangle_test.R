#tengo que agregar el estilo de hipervinculo a la columna cui de la tabla

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

#Dummy data in qmd
dummy_data <- read_csv("../data/base_resumida.csv") %>%
  janitor::clean_names() %>%
  rename(ID = cui,
         Adress = domicilio_edificio
  ) %>%
  mutate(School = paste0(Adress," ",ID)) %>%
  # slice_sample(n = 50) %>% 
  # # group_by(ID) %>% 
  # # mutate(n = n()) %>% 
  # # filter(n >1) %>% 
  distinct(ID, .keep_all = TRUE) %>%
  drop_na(ID) %>% 
  glimpse()
