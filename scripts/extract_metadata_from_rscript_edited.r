library(stringr)


count_lines_function <- function(data_lines){
  
  function_lines = data_lines[substr(data_lines,1,1) != "#" & str_detect(data_lines,"function")]
  
  return(length(function_lines))
}


count_lines_non_significant <- function(data_lines){
  
  non_significant_lines = data_lines[substr(data_lines,1,1) == "#" | data_lines == ""]
  
  return(length(non_significant_lines))
}


extract_pkgs <- function(data_lines){

  pkgs_lines = data_lines[str_detect(data_lines,"^library\\(.*\\)")]
  len_pkgs_lines = length(pkgs_lines)
  idx_comma = str_locate(pkgs_lines,",")[,1]
  idx_parenthesis = str_locate(pkgs_lines,"\\)")[,1]
                
  pkgs_clean = ""
  if(len_pkgs_lines > 0){
    for(i in 1:length(pkgs_lines)){
      pkg_clean = str_sub(pkgs_lines[i], nchar("library(")+1, min(idx_comma[i], idx_parenthesis[i], na.rm = TRUE)-1)
      pkg_clean = trimws(str_replace_all(pkg_clean, '"', ''))
      pkgs_clean = c(pkgs_clean, pkg_clean)
      pkgs_clean = pkgs_clean[pkgs_clean != ""]
    }
  }  
  
  return(sort(pkgs_clean))
}

extract_perso_pkgs <- function(data_lines){
  
  perso_pkgs_lines = data_lines[str_detect(data_lines,"^source\\(.*\\)")]
  len_perso_lines = length(perso_pkgs_lines)
  idx_comma = str_locate(perso_pkgs_lines,",")[,1]
  idx_parenthesis = str_locate(perso_pkgs_lines,"\\)")[,1]
  
  perso_pkgs_clean = ""
  if(len_perso_lines > 0){
    for(i in 1:len_perso_lines){
      perso_pkg_clean = str_sub(perso_pkgs_lines[i], nchar("source(")+1, min(idx_comma[i], idx_parenthesis[i], na.rm = TRUE)-1)
      perso_pkg_clean = trimws(str_replace_all(perso_pkg_clean, '"', ''))
      perso_pkgs_clean = c(perso_pkgs_clean, perso_pkg_clean)
      perso_pkgs_clean = perso_pkgs_clean[perso_pkgs_clean != ""]
    }
  }  
  
  return(sort(perso_pkgs_clean))
}



extract_metadata_from_Rscript <- function(file, summary_file, write_arg = TRUE){
  
  con = file(file, "r", blocking = FALSE)
  data_lines = readLines(con)
  close(con)
  data_lines = trimws(data_lines)
                      
  nb_lines_non_significant = count_lines_non_significant(data_lines)
  nb_lines_function = count_lines_function(data_lines)
  pkgs_clean = extract_pkgs(data_lines)  
  perso_pkgs_clean = extract_perso_pkgs(data_lines)
 
  nb_lines = length(data_lines)
  nb_lines_significant = nb_lines - nb_lines_non_significant
  
  if (write_arg == TRUE){              
      cat(paste(  file
                , paste(pkgs_clean, collapse = "\n")
                , paste(perso_pkgs_clean, collapse = "\n")
                , nb_lines
                , nb_lines_significant
                , nb_lines_function
                , sep = "\n"
                )
          , file = summary_file
          , sep = "\n"
          , append = TRUE
        )
  }
}

run_single <- function(chemin){
  summary_file = paste(getwd(),"synthese.txt",sep = "/")
  print(summary_file)
  extract_metadata_from_Rscript(chemin,summary_file)
}

run_all <- function(dir){
  
  if(dir.exists(dir)){
    lst_files_R = list.files(path = dir, pattern = "*.R", full.names = TRUE)
    summary_file = paste(dir, "synthese.txt", sep = "/")
    if(length(lst_files_R) > 0){
      lapply(seq(1,length(lst_files_R)),FUN = function(idx) {extract_metadata_from_Rscript(lst_files_R[idx],summary_file)})
    }else{
      print("No such file in directory.")
    }
  }else{
    print(paste("Directory", dir,"does not exist."))
  }

}


#run_all("C:/Users/kamel.kemiha/Downloads/Scripts/PER/TYNDP/SCRIPTR/HYDROscript")
#run_all("D:/Users/mansouriass/Documents/Scripts Antares/PPSE/ANALYSE_BP - 2021-07-12/SCRIPTS")
#run_all("D:/Users/mansouriass/Downloads")

#run_single("D:/Users/mansouriass/Documents/Scripts Antares/PPSE/ANALYSE_BP - 2021-07-12/SCRIPTS/BP50_main.R")
run_single("C:/Users/AssilMansouri/Downloads/Antares_Scripts/PPSE/ANALYSE_BP - 2021-07-12/SCRIPTS/BP50_main.R")