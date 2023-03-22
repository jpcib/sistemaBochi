#add_project_section function

#V4
add_project_section <- function(data, dir) {
  # Loop through each id in the dataset
  for (i in unique(data$id)) {
    
    # Generate the file name for the corresponding Quarto Markdown document
    file_name <- paste0(i, ".qmd")
    file_path <- file.path(dir, file_name)
    
    # Check if the file exists
    if (file.exists(file_path)) {
      
      # Subset the dataset for the current id
      id_data <- data[data$id == i, ]
      
      # Create a bulleted list of the projects and dates
      projects_list <- paste0("* ", id_data$intervenciones, " \n", 
                              "    + ", id_data$estado, " - ", id_data$eje,  " \n")  
      
      # Combine the title and bulleted list
      project_section <- paste0("## Infraestructura\n\n", paste(projects_list, collapse = "\n"), "\n\n")
      
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
      
      # Write the updated contents back to the file
      writeLines(updated_contents, file_path)
      
      # Print a message indicating the file was updated
      cat("Updated", file_name, "\n")
      
    } else {
      
      # Print a warning if the file doesn't exist
      cat("Warning: File", file_name, "not found in directory\n")
      
    }
    
  }
}


add_project_section(data = data_infra, dir = "pages")

