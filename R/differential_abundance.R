###########################################
###########################################
###########################################
# DESeq2 analysis at multiple levels
###########################################
###########################################
###########################################

library(dplyr)
source("/gfs/devel/nilott/NGSKit/R/deseq2_helper.R")


#####################
#####################
#####################

multiDE <- function(counts.files, metadata, model.formula=~condition, reduced.model=~1){

    # metadata is a df
    # counts.files is a list of filenames
    # covariates must be present in metadata file

    # at the moment uses hard-coded parameters
    # so won't neccesarily work in all settings

    # NOTE: metadata should have sample names as rownames
    # NOTE: counts files should have samples as colnames
    # NOTE: colnames(counts) == rownames(metadata)

    # NOTE: the level must be specified in the counts file
    # as level_abundance.tsv

    # Returns a dataframe of results at each level

    result.set <- list()
    for (i in 1:length(infiles)){
        level <- unlist(strsplit(infiles[i], "_"))[1] 
        countData <- read.csv(infiles[i], header=T, stringsAsFactors=F, sep="\t", row.names=1)

        samples <- intersect(colnames(countData), rownames(metadata))

        # make sure order of counts and metadata are the same
        metadata <- metadata[samples,]
	countData <- countData[,samples]

        dds <- DESeqDataSetFromMatrix(countData = countData,
                                      colData = metadata,
			              design = model.formula)

        dds.lrt <- DESeq(dds, test="LRT", fitType="local", reduced=reduced.model) 
        res <- results(dds.lrt)
        res2 <- data.frame(res@listData)
	res2$level <- level
        res2$test_id <- rownames(res)
        result.set[[i]] <- res2
    }
    results <- bind_rows(result.set)
}