add_project_section_v6 <- function(data, dir) {
  # Loop through each id in the dataset
  for (i in unique(data$cui)) {
    
    # Generate the file name for the corresponding Quarto Markdown document
    file_name <- paste0(i, ".qmd")
    file_path <- file.path(dir, file_name)
    
    # Check if the file exists
    if (file.exists(file_path)) {
      
      # Subset the dataset for the current id
      id_data <- data[data$cui == i, ]
      
      # Initialize an empty list to store the projects_list for each row
      projects_list <- list()
      
      # Loop through each row in id_data and generate the projects_list
      for (j in seq_len(nrow(id_data))) {
        if (id_data$estado[j] == "En Obra") {
          project <- paste0("* ", id_data$intervenciones[j], " \n", 
                            "    + ", id_data$eje[j], " - ", id_data$estado[j], " \n",
                            "    + ", "Inicio de obra: ", id_data$inicio_obra[j], " - ", "Avance: ", id_data$avance_de_obra[j], " - ", "Plazo: ", id_data$plazo_obra[j], " días", " \n\n")  
        } else if (id_data$estado[j] == "Finalizado") {
          project <- paste0("* ", id_data$intervenciones[j], " \n", 
                            "    + ", id_data$eje[j], " - ", id_data$estado[j], " \n",
                            "    + ", "Finalizada el ", id_data$fin_obra[j], " \n\n") 
        } else {
          project <- paste0("* ", id_data$intervenciones[j], " \n", 
                            "    + ", id_data$eje[j], " - ", id_data$estado[j], " \n",
                            "    + ", "Inicio de obra: ", id_data$inicio_obra[j], " \n\n") 
        }
        projects_list[[j]] <- project
      }
      
      # Combine the projects_list for all rows
      project_section <- paste0("## Infraestructura\n\n", paste(unlist(projects_list), collapse = "\n"), "\n\n")
      
      # Read the contents of the Quarto Markdown file
      file_contents <- readLines(file_path)
      
      # Find the position of the first heading in the file
      heading_pos <- grep("^#", file_contents)[1]
      
      # Check if heading_pos is NA
      if (is.na(heading_pos)) {
        cat("Warning: File", file_name, "does not contain any heading\n")
        next
      }
      
      # Insert the project section after the first heading
      updated_contents <- append(file_contents, project_section, after = heading_pos)
      
      # Write the updated contents
      writeLines(updated_contents, file_path)
      
      # Print a message indicating the file was updated
      cat("Updated", file_name, "\n")
      
    } else {
      
      # Print a warning if the file doesn't exist
      cat("Warning: File", file_name, "not found in directory\n")
      
    }
    
  }
}


add_project_section(data = data_infra, dir = ".")
