#tengo que agregar el estilo de hipervinculo a la columna cui de la tabla

library(tidyverse)

raw <- read_csv("data/base_resumida.csv") %>% 
  glimpse()

base_resumida_link <- raw %>% 
  mutate("Comuna-Distrito" = paste0("C ",comuna, "- D.E. ",distrito)) %>% 
  # rename(Domicilio = domicilio_edificio) %>% 
  mutate(Domicilio = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", domicilio_edificio,"</a>")) %>% 
  mutate(CUI = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", cui,"</a>")) %>% 
  select(-c(comuna,distrito,cui,domicilio_edificio)) %>% 
  relocate(Domicilio,CUI,"Comuna-Distrito") %>% 
  glimpse()


write_csv(base_resumida_link,"data/base_resumida_link.csv")

# mutate(fecha = as.Date(feed_pub_date),
#        medio2 = as.factor(str_extract(item_link, "\\w*(?=\\.com|.net|.org|.gov|.gob)")), 
#        titulo = paste0("<a href='",.$item_link,"'>",.$titulo,"</a>")) %>% 
#   mutate(feed_title = as.factor(feed_title)) %>% 
