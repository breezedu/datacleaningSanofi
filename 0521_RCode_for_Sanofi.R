

########################################
## 0521 R Code for Meaghan from Sanofi
## Jeff Du from Qiagen
## 


getwd()

## set work directory, where we could find all *.txt files
setwd("D:/WorkRecord/Companies/Sanofi/201905/M/0521/")

## Run below command to manually choose the input *.txt files
txt.files <- choose.files()


##########################################################
### use a for loop to readin all dataframes from txt files

data.df <- NULL

#
for(each in txt.files){
  
  ## print current file name
  print(each)
  
  ## the first line in each file contains linux command to run featureCounts, use skip=1 to ignore the first line;
  ## the second line contains all columns names, so we set header=T to keep those column names;
  data.df.current <- read.table(each, skip = 1, header = T, fill = TRUE)
  
  ## only keep the first and the last columns
  ## the first column contains gene ids; and the last columns contain count values
  data.df.current <- data.df.current[ , c( 1, 7)]
  
  if( is.null(data.df) ){
    
    data.df <- data.df.current
    
  } else {
    
    data.df <- cbind(data.df, data.df.current)
    
    ## get the num of total columns
    num.col <- dim(data.df)[2]
    
    ## remove the second last column, which is the duplicate of gene ids;
    data.df[, num.col-1] <- NULL
    
  }
  
  # check current dataframe dim
  print( paste( "dim: ", dim(data.df) ) )

} # end for loop 


dim(data.df)

head(data.df)

## since each column name contains :
##                                      bams.inQueue_PPMI.Phase1.IR1.1009.POOL.0003202425.5104.SL.0095.longRNA.NEBKAP.star.bam
## we can remove prefix and keep only:  Phase1.IR1.1009.POOL.0003202425.5104.SL.0095

data.df2 <- data.df
data.df <- data.df2

names(data.df) <- sub(".longRNA.NEBKAP.star.bam", "", names(data.df) )
names(data.df) <- sub("bams.inQueue_PPMI.", "", names(data.df) )
names(data.df) <- sub("bamsMissingGenecode.inQueue_PPMI", "", names(data.df))
head(data.df)


##################################
## save the dataframe as a txt file

write.table(data.df,"count_tables.txt",sep="\t",row.names=FALSE)
