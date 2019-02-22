#######################################################
#######################################################
#######################################################
# A set of functions for using with diversity metrics
#######################################################
#######################################################
#######################################################


multiFactorKruskalTest <- function(data){

    #####################################################################
    # this function takes a data frame as the argument. The data frame
    # must have a column that is called "alpha.diversity". This is just so
    # that any of the diversity metrics can be used from phyloseq
    ######################################################################

    results <- matrix(nrow=ncol(data), ncol=3)
    colnames(results) <- c("~factor", "chi.squared", "p.value")
    for (i in 1:ncol(data)){
        if (colnames(data)[i] == "alpha.diversity"){next}
	res <- kruskal.test(alpha.diversity ~ as.factor(get(colnames(data)[i])), data=data)
	chi.squared <- res$statistic[[1]]
	pvalue <- res$p.value

        # add the values to the
	results[i,1] <- colnames(data)[i]
	results[i,2] <- chi.squared
	results[i,3] <- pvalue

    }
    return(na.omit(as.data.frame(results)))
}