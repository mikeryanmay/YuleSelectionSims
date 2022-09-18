library(ape)
library(expm)

YuleLikelihoodBinary <- setRefClass(
  
  "YuleLikelihoodBinary",
  
  fields = c(
    
    "tree",
    "raw_seq",
    "sel_seq",
    "sel_states",
    
    "lambda0",
    "lambda1",
    "gamma01",
    "gamma10",
    "phi",
    "fitnesses",
    "fitness_function",
    
    "model",
    "S",
    "edge_matrix",
    "extant_tips",
    
    "selected_sites",
    "sel_lik_container",
    "sel_lik_dirty",
    "sel_lik_container_dirty",
    "sel_rescale_log",
    "selected_site_log_likelihood",
    
    "P_sel"
    
  ),
  
  methods = list(
    
    initialize = function(tree_,
                          data_,
                          model_,
                          lambda0_,
                          lambda1_,
                          gamma01_,
                          gamma10_,
                          phi_) {
      
      # store the data
      tree    <<- tree_
      raw_seq <<- toupper(data_)
      
      # find the extant tips
      extant_tips <<- tree$tip.label[tree$tip.label %in% is.extinct(tree) == FALSE]
      
      # store model and parameters
      model            <<- model_
      lambda0          <<- lambda0_
      lambda1          <<- lambda1_
      gamma01          <<- gamma01_
      gamma10          <<- gamma10_
      phi              <<- phi_
      
      # set everything as dirty
      sel_lik_dirty <<- TRUE
      sel_lik_container_dirty <<- TRUE
      
      # create the tree structure
      edge_matrix <<- data.frame(index = 1 + 1:nrow(tree$edge), anc = tree$edge[,1], desc = tree$edge[,2], bl = tree$edge.length)
      
      # append the root edge
      edge_matrix <<- rbind(data.frame(index = 1, anc = 0, desc = tree$Nnode + 2, bl = tree$root.edge), edge_matrix)
      
      # create the descendant indexes
      desc_list <- vector("list", nrow(edge_matrix))
      for(i in 1:nrow(edge_matrix)) {
        # get the descendant indexes
        desc_list[[i]] <- list(edge_matrix$index[edge_matrix$anc == edge_matrix$desc[i]])
      }
      edge_matrix <<- cbind(edge_matrix, data.frame(desc_index = I(desc_list)))
      
      # initialize the containers
      initSelectedSitesContainers()
      
      # DONE INITIALIZING
      
    },
    
    setTree = function(tree_) {
      
      # set the tree
      tree <<- tree_
      
      # update the edge matrix
      edge_matrix$bl <<- c(tree$root.edge, tree$edge.length)
      
      # set likelihood as dirty
      sel_lik_dirty <<- TRUE
      
    },
    
    initSelectedSitesContainers = function() {
      
      # make the matrix
      S <<- matrix(0, 3, 3, dimnames = list(c("0","1","A"), c("0","1","A")))
      S[1,2] <<- gamma01
      S[1,3] <<- lambda0 + phi
      S[2,1] <<- gamma10
      S[2,3] <<- lambda1 + phi
      diag(S) <<- -rowSums(S)
      
      # make fitnesses
      fitnesses <<- c(lambda0, lambda1, 0)
      
      if ( sel_lik_container_dirty ) {
        
        # update sel seq
        sel_seq <<- ifelse(raw_seq == model, "1", "0")
        
        # update the containers
        sel_lik_container <<- vector("list", nrow(edge_matrix))
        likelihood_container <- matrix(0, nrow = 3, ncol = 1)
        rownames(likelihood_container) <- c("0", "1", "A")
        
        # populate the containers
        tips <- tree$tip.label
        for (i in 1:length(tips)) {
          
          # get the tip
          this_tip <- tips[i]
          this_row <- edge_matrix$index[edge_matrix$desc == i]
          
          # initialize the container
          this_container <- likelihood_container
          
          # get the data for this tip
          this_sel_data <- sel_seq[this_tip,]
          if (this_tip %in% extant_tips) {
            this_container[this_sel_data,1] <- 1.0
          } else {
            this_container[this_sel_data,1] <- phi
          }
          
          # store the likelihood
          sel_lik_container[[this_row]] <<- this_container
          
        }
        
        # set clean
        sel_lik_container_dirty <<- FALSE
        
      }
      
    },
    
    computeSelectedTransitionProbabilities = function() {
      
      # eigen decomposition
      eigen <- eigen(S)
      vals  <- eigen$values
      vec   <- eigen$vectors
      vecI  <- solve(vec)
      tpFunc <- function(t) computeTransitionProbability(vec, vecI, exp(t * vals))
      
      # populate transition probabilities per branch
      P_sel <<- vector("list", nrow(edge_matrix))
      for(i in 1:nrow(edge_matrix)) {
        
        # get the branch length
        this_bl <- edge_matrix$bl[i]
        
        # store P
        P_sel[[i]] <<- tpFunc(this_bl)
        
      }
      
    },
    
    setModel = function(model_) {
      model <<- model_
      sel_lik_dirty <<- TRUE
      sel_lik_container_dirty <<- TRUE
    },
    
    setLambda0 = function(lambda0_) {
      lambda0 <<- lambda0_
      sel_lik_dirty <<- TRUE
    },

    setLambda1 = function(lambda1_) {
      lambda1 <<- lambda1_
      sel_lik_dirty <<- TRUE
    },
    
    setGamma01 = function(gamma01_) {
      gamma01 <<- gamma01_
      sel_lik_dirty <<- TRUE
    },

    setGamma10 = function(gamma10_) {
      gamma10 <<- gamma10_
      sel_lik_dirty <<- TRUE
    },
    
    setPhi = function(phi_) {
      phi <<- phi_
      sel_lik_dirty <<- TRUE
      sel_lik_container_dirty <<- TRUE
    },
    
    computeLikelihood = function() {
      
      # first, update the likelihoods
      computeSelectedLikelihood()
      
      # now, collect the appropriate values at the root
      ll <- getSelectedLikelihood()
      return(ll)
      
    },
    
    getSelectedLikelihood = function() {
      # only use the likelihoods for sites under selection
      return(selected_site_log_likelihood)
    },
    
    computeSelectedLikelihood = function() {
      
      if (sel_lik_dirty) {
        
        # update containers
        initSelectedSitesContainers()
        
        # update transition probabilities
        computeSelectedTransitionProbabilities()
        
        # compute the likelihood for the selected site
        sel_rescale_log <<- 0
        recursiveComputeConditionalLikelihoodSelected(edge_matrix$index[1])
        
        # get likelihoods at the root
        sel_lik_root <- sel_lik_container[[1]]
        
        # get the transition probability
        this_P <- P_sel[[1]]
        
        # get the conditional likelihoods
        desc_CL <- sel_lik_container[[1]]
        
        # compute the conditional likelihood
        this_CL <- this_P %*% desc_CL
        
        # accumulate probability at the origin
        selected_site_log_likelihood <<- log(this_CL[1]) + sel_rescale_log
        
        # update the dirty flag
        sel_lik_dirty <<- FALSE
        
      }
      
    },
    
    recursiveComputeConditionalLikelihoodSelected = function(index) {
      
      # get all the descendants
      descendants <- edge_matrix$desc_index[index][[1]][[1]]
      
      if ( length(descendants) == 0 ) {
        # this is a tip
      } else {
        
        # get the branch indices
        this_index <- index
        desc_index <- descendants
        
        # this is an internal node
        for(i in 1:length(descendants)) {
          recursiveComputeConditionalLikelihoodSelected(descendants[i])
        }
        
        # compute the likelihood for the left descendants
        left_P       <- P_sel[[desc_index[1]]]
        left_CL      <- sel_lik_container[[desc_index[1]]]
        left_partial <- left_P %*% left_CL
        
        # compute the likelihood for the right descendants
        right_P       <- P_sel[[desc_index[2]]]
        right_CL      <- sel_lik_container[[desc_index[2]]]
        right_partial <- right_P %*% right_CL
        
        # compute the likelihood at the focal node
        this_CL <- left_partial * right_partial
        
        # add the speciation rate
        this_CL <- 2 * fitnesses * this_CL
        
        # rescale the likelihood
        scalar <- max(this_CL)
        this_CL <- this_CL / scalar
        sel_rescale_log <<- sel_rescale_log + log(scalar)
        
        # store the conditional likelihood
        sel_lik_container[[this_index]] <<- this_CL
        
      }
      
    }
    
  )
  
)