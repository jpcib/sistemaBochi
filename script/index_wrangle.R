#Wrangle Tabla index

library(tidyverse)


raw <- read_csv("data/base_resumida.csv") %>% 
  glimpse()

raw <- read_csv("data/base_completa_v4.csv") %>% 
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
  mutate(DE = str_pad(distrito, width = 2, side = "left", pad = "0")) %>%
  mutate("Nº" = numero_escuela) %>% 
  # select(-any_of(c("domicilio_edificio"))) %>%
  glimpse()
unique(base_resumida_link$distrito)

write_csv(base_resumida_link,"data/base_completa_link_v4.csv")
