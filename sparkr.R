##environment
##http://mkn939.blogspot.tw/2013/03/maven-step-by-step.html
##http://watermay.pixnet.net/blog/post/21334632-java%E7%92%B0%E5%A2%83%E8%AE%8A%E6%95%B8%E8%A8%AD%E5%AE%9A%E6%96%B9%E5%BC%8F
##https://groups.google.com/forum/#!topic/sparkr-dev/Yss1ViIfBYo

#spark
#http://www.cnblogs.com/hseagle/p/3998853.html
#http://www.iteblog.com/archives/1385
##http://rstudio-pubs-static.s3.amazonaws.com/133901_f42ea5e9eab74822a4985090748c232c.html


#library(devtools)
#install_github("amplab-extras/SparkR-pkg", subdir="pkg")
# Set the system environment variables

##直接call func有問題 need to add ":::"
if(FALSE){
  Sys.setenv(SPARK_HOME = "D:\\spark-1.6.1-bin-hadoop2.6")
  .libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths())) #為了使用Spark所提供的SparkR的package
  library(SparkR)
  library("rJava")
  sc <- sparkR.init(master="local", "RwordCount")
  #rdd <- SparkR:::textFile(sc, 'README.md')
  
  lines <- SparkR:::textFile(sc, "README.md")
  words <- SparkR:::flatMap(lines,
                            function(line) {
                              strsplit(line, " ")[[1]]
                            })
  wordCount <- lapply(words, function(word) { list(word, 1L) })
  
  counts <- reduceByKey(wordCount, "+", 2L)
  output <- collect(counts)
  for (wordcount in output) {
    cat(wordcount[[1]], ": ", wordcount[[2]], "\n")
  }
}



#### Create a sparkR DataFrame from a R DataFrame ####
Sys.setenv(SPARK_HOME = "D:\\spark-1.6.1-bin-hadoop2.6")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths())) #為了使用Spark所提供的SparkR的package
library(SparkR)
sc <- sparkR.init(master = "local")
sqlContext <- sparkRSQL.init(sc)
exercise.df <- data.frame(name=c("John", "Smith", "Sarah"), age=c(19, 23, 18)) # a R_dataFrame
exercise.df
spark.df <- createDataFrame(sqlContext, exercise.df) # convert R_dataFrame to spark_sql_dataFrame
head(spark.df)
printSchema(spark.df) # print out the spark_sql_dataFrame's schema
class(spark.df)
r.df <- collect(spark.df)
class(r.df)
# Running SQL Queries from SparkR
registerTempTable(spark.df, "test")
sql_result <- sql(sqlContext, "SELECT name FROM test WHERE age > 19 AND age < 24")
head(sql_result)
head(faithful)
spark.df <- createDataFrame(sqlContext, faithful)
# Select only the "eruptions" column
head(select(spark.df, "eruptions"))
# Filter the DataFrame to only retain rows with wait times shorter than 50 mins
head(filter(spark.df, spark.df$waiting < 50))
# Convert waiting time from hours to seconds.
spark.df$waiting_secs <- spark.df$waiting * 60
head(spark.df)
waiting_freq <- summarize(groupBy(spark.df, spark.df$waiting), count = n(spark.df$waiting))
head(waiting_freq) 
sort_waiting_freq <- arrange(waiting_freq, desc(waiting_freq$count))
head(sort_waiting_freq) 

# Create the DataFrame
df <- createDataFrame(sqlContext, iris)
# Fit a linear model over the dataset.
model <- glm(Sepal_Length ~ Sepal_Width + Species, data = df, family = "gaussian")
# Model coefficients are returned in a similar format to R's native glm().
summary(model)
# Make predictions based on the model.
predictions <- predict(model, newData = df)
head(select(predictions, "Sepal_Length", "prediction"))
#### Stop the SparkContext ####
sparkR.stop()
