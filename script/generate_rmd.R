# test

# create a vector of addresses
addresses <- c("123 Main St", "456 Oak Ave", "789 Elm St", "321 Maple Ave")

# create a vector of schools
schools <- c("ABC Elementary", "XYZ Middle School", "123 High School", "456 Academy")

# create a vector of ids
ids <- 1:4

# combine the vectors into a data frame
dummy_data <- data.frame(Address = addresses, School = schools, ID = ids)

# view the resulting data frame
dummy_data


# create a function to generate the .Rmd file for each school
generate_rmd <- function(school_id) {
  # get the school name and address from the data frame
  school_name <- dummy_data$School[dummy_data$ID == school_id]
  school_address <- dummy_data$Address[dummy_data$ID == school_id]
  
  # create the YAML header
  yaml_header <- paste0("---\n", 
                        "title: '", school_address, "'\n",
                        "subtitle: '", school_name, "'\n",
                        "---\n\n")
  
  # create the file name
  file_name <- paste0(school_id, ".Rmd")
  
  # write the YAML header and some example content to the .Rmd file
  writeLines(yaml_header, file_name)
  # writeLines("# Example content", file_name, append = TRUE)
  
}

# apply the function to each school in the data frame
for (school_id in dummy_data$ID) {
  generate_rmd(school_id)
}
