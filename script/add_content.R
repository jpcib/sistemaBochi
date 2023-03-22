# Load the lubridate package for date manipulation
library(lubridate)

# Set the seed for reproducibility
set.seed(123)

# Create a vector of possible remodeling projects
projects <- c("Kitchen remodel", "Bathroom remodel", "Basement finishing", "Deck addition", "Attic conversion")

# Create the dummy dataset with 10 rows
test_data <- data.frame(
  id = 1:10,
  project = sample(projects, 10, replace = TRUE),
  date = sample(seq(as.Date('2022/01/01'), as.Date('2022/12/31'), by="day"), 10)
)

# View the resulting dataset
test_data

# Create a new data frame with the 3 additional projects
new_projects <- data.frame(
  id = c(2, 5, 8),
  project = c("Bathroom remodel", "Attic conversion", "Deck addition"),
  date = sample(seq(as.Date('2022/01/01'), as.Date('2022/12/31'), by="day"), 3)
)

# Append the new projects to the original dataset
test_data <- rbind(test_data, new_projects)

# Sort the dataset by id
test_data <- test_data[order(test_data$id), ]

# View the resulting dataset
test_data


# library(tidyverse)

add_project_section(data = test_data, dir = "pages")

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
      projects_list <- paste0("* ", id_data$project, " (", format(id_data$date, "%B %d, %Y"), ")")
      
      # Combine the title and bulleted list
      project_section <- paste0("## PROJECTS\n\n", paste(projects_list, collapse = "\n"), "\n\n")
      
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

# 
# #V3
# add_project_section <- function(data, dir) {
#   # Loop through each id in the dataset
#   for (i in data$id) {
#     
#     # Find the index of the current id value in the data$id vector
#     id_index <- match(i, data$id)
#     
#     # Generate the file name for the corresponding Quarto Markdown document
#     file_name <- paste0(data$id[id_index], ".qmd")
#     file_path <- file.path(dir, file_name)
#     
#     # Check if the file exists
#     if (file.exists(file_path)) {
#       
#       # Subset the dataset for the current id
#       id_data <- data[id_index, ]
#       
#       # Create a bulleted list of the projects and dates
#       projects_list <- paste0("* ", id_data$project, " (", format(id_data$date, "%B %d, %Y"), ")")
#       
#       # Combine the title and bulleted list
#       project_section <- paste0("## PROJECTS\n\n", paste(projects_list, collapse = "\n"), "\n\n")
#       
#       # Read the contents of the Quarto Markdown file
#       file_contents <- readLines(file_path)
#       
#       # Find the position of the first heading in the file
#       heading_pos <- grep("^#", file_contents)[1]
#       
#       # Insert the project section after the first heading
#       updated_contents <- append(file_contents, project_section, after = heading_pos)
#       
#       # Write the updated contents back to the file
#       writeLines(updated_contents, file_path)
#       
#       # Print a message indicating the file was updated
#       cat("Updated", file_name, "\n")
#       
#     } else {
#       
#       # Print a warning if the file doesn't exist
#       cat("Warning: File", file_name, "not found in directory\n")
#       
#     }
#     
#   }
# }
# 
# 
# 
# 
# 
# #v2
# add_project_section <- function(data, dir) {
#   # Loop through each id in the dataset
#   for (i in data$id) {
#     
#     # Generate the file name for the corresponding Quarto Markdown document
#     file_name <- paste0(i, ".qmd")
#     file_path <- file.path(dir, file_name)
#     
#     # Check if the file exists
#     if (file.exists(file_path)) {
#       
#       # Subset the dataset for the current id
#       id_data <- data[data$id == i, ]
#       
#       # Create a bulleted list of the projects and dates
#       projects_list <- paste0("* ", id_data$project, " (", format(id_data$date, "%B %d, %Y"), ")")
#       
#       # Combine the title and bulleted list
#       project_section <- paste0("## PROJECTS\n\n", paste(projects_list, collapse = "\n"), "\n\n")
#       
#       # Read the contents of the Quarto Markdown file
#       file_contents <- readLines(file_path)
#       
#       # Find the position of the first heading in the file
#       heading_pos <- grep("^#", file_contents)[1]
#       
#       # Insert the project section after the first heading
#       updated_contents <- append(file_contents, project_section, after = heading_pos)
#       
#       # Write the updated contents back to the file
#       writeLines(updated_contents, file_path)
#       
#       # Print a message indicating the file was updated
#       cat("Updated", file_name, "\n")
#       
#     } else {
#       
#       # Print a warning if the file doesn't exist
#       cat("Warning: File", file_name, "not found in directory\n")
#       
#     }
#     
#   }
# }
# 
# 
# # Loop through each id in the dataset V1
# for (i in test_data$id) {
#   
#   # Generate the file name for the corresponding Quarto Markdown document
#   file_name <- paste0(i, ".qmd")
#   path <- "pages/"
#   # Check if the file exists in the working directory
#   if (file.exists(paste0(path,file_name))) {
#     
#     # Subset the dataset for the current id
#     id_data <- test_data[test_data$id == i, ]
#     
#     # Create a bulleted list of the projects and dates
#     projects_list <- paste0("* ", id_data$project, " (", format(id_data$date, "%B %d, %Y"), ")")
#     
#     # Combine the title and bulleted list
#     project_section <- paste0("## PROJECTS\n\n", paste(projects_list, collapse = "\n"), "\n\n")
#     
#     # Read the contents of the Quarto Markdown file
#     file_contents <- readLines(file_name)
#     
#     # Find the position of the first heading in the file
#     heading_pos <- grep("^#", file_contents)[1]
#     
#     # Insert the project section after the first heading
#     updated_contents <- append(file_contents, project_section, after = heading_pos)
#     
#     # Write the updated contents back to the file
#     writeLines(updated_contents, file_name)
#     
#     # Print a message indicating the file was updated
#     cat("Updated", file_name, "\n")
#     
#   } else {
#     
#     # Print a warning if the file doesn't exist
#     cat("Warning: File", file_name, "not found in working directory\n")
#     
#   }
#   
# }
