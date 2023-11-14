#BASE EDIFICIOS CUI+NOMBRE en una sola línea.  V2
pacman::p_load(tidyverse,readxl)
options(scipen = 999)

#Limpieza del crudo de mantenimiento
#Raw data

# raw_resumida <- read_xlsx("data/Base de Edificios_08_03.xlsx", 
#                           sheet = "BASE_RESUMIDA") %>%
#   glimpse()
## Primero agarro solo base resumida
# 
# clean_resumida <- raw_resumida %>% 
#   janitor::clean_names() %>% 
#   select(comuna,distrito,domicilio_edificio,cui) %>% c
# # mutate(cui = str_pad(cui, width = 7, side = "left", pad = 0)) %>% 
# glimpse()
# write_csv(clean_resumida,"~/Documents/rst/megcba/sistemaBochi/data/base_resumida.csv")  


raw_completa <- read_xlsx("data/Base de Edificios_18_10_23.xlsx", 
                          sheet = "BASE CON CUE_CUI COMPLETA") %>% 
  janitor::clean_names() %>% 
  drop_na(cui) %>%
  glimpse()


#Limpio base completa con nombres en una linea####

clean_cui <- raw_completa %>% 
  select(cui, domicilio_edificio, nombre_establecimiento) %>%
  #agregacion de escuelas por direccion + cui unico
  group_by(cui,domicilio_edificio) %>% 
  summarise(nombre_establecimiento = paste(nombre_establecimiento, collapse = " - ")) %>% 
  ungroup() %>% 
  #Agregacion de cui iguales con direccion diferente (entradas por calles o alturas distintas, mismo edificio)
  group_by(cui) %>%
  summarise(domicilio_edificio = paste(domicilio_edificio, collapse = " - "),
            nombre_establecimiento = paste0(nombre_establecimiento, collapse = " - ")
            ) %>%
  ungroup() %>%
  mutate(cui = str_pad(as.character(cui), pad = "0", side = "left",width = 7)) %>%
  mutate(n_establecimiento = str_remove_all(nombre_establecimiento, "[:alpha:]"),
         n_establecimiento = str_remove_all(n_establecimiento, "\\/\\d{2}")) %>% 
  glimpse()

#uno con distrito 
clean_completa <- raw_completa %>% 
  select(cui, distrito) %>%
  mutate(cui = str_pad(as.character(cui), pad = "0", side = "left",width = 7)) %>%
  distinct(cui, .keep_all = TRUE) %>%
  # glimpse()
  right_join(clean_cui) %>% 
  glimpse()

# write_csv(clean_completa,"~/Documentos/rst/megcba/sistemaBochi/data/base_completa_v6.csv")  


##Extraigo numero de escuela ####
# n_estab <- raw_completa %>% 
#   mutate(n_establecimiento = str_remove_all(nombre_establecimiento, "\\D")) %>% 
#   select(cui,n_establecimiento) %>% 
#   print()

#subset para limpiar numeros mas comodo
escuelas <- clean_completa %>% 
  select(cui,n_establecimiento) %>% 
  glimpse()


# Determine the maximum number of numbers in the "n_establecimiento" column
max_num <- max(sapply(strsplit(gsub("[^0-9]+", " ", escuelas$n_establecimiento), " "), length))

# Create an empty data frame with columns for each number
df <- data.frame(matrix(ncol = max_num+1, nrow = nrow(escuelas)))
colnames(df) <- c("cui", paste0("num", 1:max_num))
df$cui <- escuelas$cui

# Extract the numbers and place them into the appropriate columns
for (i in 1:nrow(escuelas)) {
  nums <- gsub("[^0-9]+", " ", escuelas$n_establecimiento[i]) # extract numbers from string
  nums <- strsplit(trimws(nums), " ")[[1]] # split into individual numbers
  if (length(nums) > 0) { # check if there are any numbers
    df[i, 2:(length(nums)+1)] <- nums # place numbers into appropriate columns
  }
}

# Replace NA values with empty strings
df[is.na(df)] <- ""

#Join columns into one
df$numero_escuela <- apply(df[, 2:(max_num+1)], 1, function(x) paste(x[x != ""], collapse = "-"))


# Print the final data frame
numeros_clean <- df %>% 
  select(cui,numero_escuela) %>% 
  print()

#uno clean_completa con numeros_clean

base_completa <- clean_completa %>% 
  left_join(numeros_clean) %>% 
  select(cui,distrito,nombre_establecimiento,domicilio_edificio,numero_escuela) %>% 
  glimpse()

write_csv(base_completa,"~/Documentos/rst/megcba/sistemaBochi/data/base_completa_v7.csv")  

#Check 
v7 <- read_csv("data/base_completa_v7.csv") %>% 
  glimpse()

v6 <- read_csv("data/base_completa_v6.csv") %>% 
  glimpse()

anti_join(v6,v7, by = "cui") %>% 
  view()

#Update tabla con links 
library(tidyverse)

raw <- read_csv("data/base_completa_v6.csv") %>% 
  glimpse()


base_resumida_link <- raw %>% 
  # drop_na(cui) %>% #Hay que agregarle un cui a los NA (planetario, etc.). Ver como lo armo nico.
  mutate(nombre_establecimiento = str_replace_all(nombre_establecimiento, "\\'",replacement = " ")) %>% 
  mutate(domicilio_edificio = str_replace_all(domicilio_edificio, "\\'",replacement = " ")) %>% 
  # mutate("Comuna-Distrito" = paste0("C ",comuna, "- D.E. ",distrito)) %>% 
  # rename(Domicilio = domicilio_edificio) %>% 
  mutate(Domicilio = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", domicilio_edificio,"</a>")) %>% 
  mutate(Establecimiento = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", nombre_establecimiento,"</a>")) %>%
  rename(establecimiento = nombre_establecimiento) %>% 
  rename(domicilio = domicilio_edificio) %>% 
  mutate(DE = str_pad(distrito, width = 2, side = "left", pad = "0"), 
         DE = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", DE,"</a>")) %>%
  mutate("Nº" = paste0("<a href='https://jpcib.github.io/sistemaBochi/pages/",cui,".html","'>", numero_escuela,"</a>")) %>% 
  # select(-any_of(c("domicilio_edificio"))) %>%
  glimpse()
unique(base_resumida_link$distrito)

write_csv(base_resumida_link,"data/base_completa_link_v6.csv")
###









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


write_csv(base_resumida_link,"data/base_completa_link_v6.csv")
