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


extract_metadata_from_Rscript <- function(file, summary_file){
  
  con = file(file, "r", blocking = FALSE)
  data_lines = readLines(con)
  close(con)
  data_lines = trimws(data_lines)
                      
  nb_lines_non_significant = count_lines_non_significant(data_lines)
  nb_lines_function = count_lines_function(data_lines)
  pkgs_clean = extract_pkgs(data_lines)                    
 
  nb_lines = length(data_lines)
  nb_lines_significant = nb_lines - nb_lines_non_significant
                  
  cat(paste(  file
            , paste(pkgs_clean, collapse = ",")
            , nb_lines
            , nb_lines_significant
            , nb_lines_function
            , sep = ";"
            )
      , file = summary_file
      , sep = "\n"
      , append = TRUE
    )
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


run_all("C:/Users/kamel.kemiha/Downloads/Scripts/PER/TYNDP/SCRIPTR/HYDROscript")
