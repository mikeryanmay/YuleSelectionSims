# RUN FROM simulations/single_site

# find all the analyses to do
all_tree_files <- list.files(pattern = "tree.nex", recursive = TRUE, full.names = TRUE)

# ignore the "original data" directories
all_tree_files <- all_tree_files[grepl("original", all_tree_files) == FALSE]

# get all unique directories
all_dirs <- unique(gsub("/tree.nex", "", all_tree_files))

# check if the runs already have fits.tsv
all_dirs <- all_dirs[sapply(all_dirs, function(x) any(grepl("fits.tsv", list.files(x)))) == FALSE]

# read template
template <- readLines("src/run_template.sh")

# chunk the runs
chunk_size <- 20
num_chunks <- ceiling(length(all_dirs) / chunk_size)

# loop over chunks
for(i in 1:num_chunks) {
  
  # get the runs for this chunk
  jobs <- 1:chunk_size + (i - 1) * chunk_size 
  
  # copy the template
  this_slurm <- template
  
  # get the name
  this_slurm <- gsub("NAME_PLACEHOLDER", paste0("chunk_", i), this_slurm)
 
  # get the tasks for this chunk
  these_tasks <- all_dirs[jobs]
  
  # replace the tasks
  for(j in 1:20) {
    this_slurm <- gsub(paste0("RUN", j), these_tasks[j], this_slurm)
  }
  
  # write the slurm script
  writeLines(this_slurm, paste0("_run/", paste0("chunk_", i), ".sh" ))

}

# # enumerate the analyses
# sims <- c("factor_1", "factor_2", "factor_3", "factor_4", "scenario_1", "scenario_2", "scenario_3")
# size <- c(10, 100, 1000)
# sets <- 1:5 # do 5 sets of 20
# 
# # make all combinations
# grid <- expand.grid(sims, size, sets, stringsAsFactors = FALSE)
# 
# # read template
# template <- readLines("src/run_template.sh")
# 
# # loop over combos
# for(i in 1:nrow(grid)) {
#   
#   # get the variables
#   this_sim  <- grid[i,1]
#   this_size <- grid[i,2]
#   this_set  <- grid[i,3]
#  
#   # copy the template
#   this_slurm <- template
#   
#   # get the dir
#   this_dir <- paste0(this_sim, "_size_", this_size)
#   this_slurm <- gsub("DIR_PLACEHOLDER", this_dir, this_slurm)
#   
#   # get the name
#   this_name <- paste0(this_dir, "_set_", this_set)
#   this_slurm <- gsub("NAME_PLACEHOLDER", this_name, this_slurm)
#    
#   # replace the tasks
#   for(j in 1:20) {
#     this_slurm <- gsub(paste0("RUN", j, " "), paste0((this_set - 1) * 20 + j, " "), this_slurm)
#   }
#   
#   # write the slurm script
#   writeLines(this_slurm, paste0("_run/", this_name, ".sh" ))
#   
# }