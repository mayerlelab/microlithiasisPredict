here::here()
requirePackages <- c("dplyr", "tidyr", "ggplot2", "ggbeeswarm", "h2o", "lime", "flexdashboard", "shiny")
loadPackages <- function(x) {
  for(i in 1:length(x)){
    if((x[i] %in% .packages(all.available=TRUE)) == TRUE) {
      eval(parse(text=paste("require(", x[i], ")", sep="")))
    } else {
      eval(parse(text=paste("install.packages('", x[i], "')", sep="")))
    }
  }
}
# load packages --------
loadPackages(requirePackages)
h2o.init()
h2o.no_progress()
h2o.removeAll()

model <-
  h2o.loadModel("../h2o_results/iteration/GBM_grid__1_AutoML_20220706_153327_model_2")
train.lime <- read.csv("../Data/splitData/train.csv",check.names = FALSE)

# Setup lime::model_type() -------------
model_type.H2OBinomialModel <- function(x, ...) {
  return("classification")
}

# model type --------------
model_type.H2OBinomialModel(model)

# lime explainer --------------
explainer <- lime(train.lime, model)
saveRDS(explainer, "explainer")

h2o.shutdown(prompt = FALSE)

