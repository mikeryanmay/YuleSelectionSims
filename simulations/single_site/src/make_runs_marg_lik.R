# RUN FROM simulations/single_site
# setwd("simulations/single_site/")

library(gtools)

# clear the _run directory
old_runs <- list.files("_run_marg_lik", full.names = TRUE)
file.remove(old_runs)
dir.create("_run_marg_lik", showWarnings = FALSE)

# find all the analyses to do
all_tree_files <- list.files(pattern = "tree.nex", recursive = TRUE, full.names = TRUE)

# ignore the "original data" directories
all_tree_files <- all_tree_files[grepl("original", all_tree_files) == FALSE]

# ignore the scenario simulations
all_tree_files <- all_tree_files[grepl("scenario", all_tree_files) == FALSE]

# get all unique directories
all_dirs <- unique(gsub("/tree.nex", "", all_tree_files))

# check if the runs already have posterior.log
all_dirs <- all_dirs[sapply(all_dirs, function(x) any(grepl("marg_lik.tsv", list.files(x)))) == FALSE]

# sort the jobs naturally
all_dirs <- mixedsort(all_dirs)

# read template
template <- readLines("src/run_template_marg_lik.sh")

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
  these_tasks <- these_tasks[is.na(these_tasks) == FALSE]

  # replace the tasks
  for(j in seq_along(these_tasks)) {
    this_slurm <- gsub(paste0("RUN", j, " "), paste0(these_tasks[j], " "), this_slurm)
  }

  # drop non-tasks
  this_slurm <- this_slurm[grepl("RUN", this_slurm) == FALSE]

  # make sure the last job has a ; instead of a &
  last_job <- max(grep("Rscript", this_slurm))
  this_slurm[last_job] <- gsub("&", ";", this_slurm[last_job])

  # write the slurm script
  writeLines(this_slurm, paste0("_run_marg_lik/", paste0("chunk_", i), ".sh" ))

}
