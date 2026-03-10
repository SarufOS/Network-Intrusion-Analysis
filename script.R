# ============================================
# DATA CLEANING AND PREPARATION
# ============================================

# ---- STEP 1: Importing dataset ----

# Download the dataset
# Copy as path and paste it next to the assignment operator below (fileUrl = ) inside quotation marks
# If using Windows: Add an additional backslash next to each backslash OR replace them with forward slashes

fileUrl = #"C:\\Users\\...\\UNSW-NB15_uncleaned.csv" (Example)

dataset = read.csv(fileUrl, stringsAsFactors = F)
View(dataset)

# ============================================
# CLEANING PROCESS FOR SELECTED VARIABLES
# ============================================

# ---- STEP 2: Inspecting structure and summary ----

str(dataset)
summary(dataset[c("dur", "sbytes", "proto", "state", "dbytes", "sttl", "dttl", "label")])

# ---- STEP 3: Removing question marks and underscores ----

dataset$dur <- trimws(gsub("[?_]", "", dataset$dur))  
dataset$sbytes <- trimws(gsub("[?_]", "", dataset$sbytes))
dataset$label <- trimws(gsub("[?_]", "", dataset$label))
dataset$proto  <- trimws(gsub("[?_]", "", dataset$proto))
dataset$state  <- trimws(gsub("[?_]", "", dataset$state))
dataset$dbytes <- trimws(gsub("[?_]", "", dataset$dbytes))
dataset$sttl   <- trimws(gsub("[?_]", "", dataset$sttl))
dataset$dttl   <- trimws(gsub("[?_]", "", dataset$dttl))

# ---- STEP 4: Converting data types ----

# Converting continuous variables to numeric
dataset$dur <- as.numeric(dataset$dur)
dataset$sbytes <- as.numeric(dataset$sbytes)
dataset$dbytes <- as.numeric(dataset$dbytes)
dataset$sttl   <- as.numeric(dataset$sttl)
dataset$dttl   <- as.numeric(dataset$dttl)

# Converting categorical variables to factor
dataset$label <- as.factor(dataset$label)
dataset$proto <- as.factor(dataset$proto)
dataset$state <- as.factor(dataset$state)

# ---- STEP 5: Handling missing (NA) values ----

# Set NA values properly
dataset$dur[dataset$dur %in% c("NA", "")] <- NA  
dataset$sbytes[dataset$sbytes %in% c("NA", "")] <- NA  
dataset$label[dataset$label %in% c("NA", "")] <- NA 
dataset$dbytes[dataset$dbytes %in% c("", "NA")] <- NA
dataset$sttl[dataset$sttl %in% c("", "NA")] <- NA
dataset$dttl[dataset$dttl %in% c("", "NA")] <- NA
dataset$proto[dataset$proto %in% c("", "NA")] <- NA
dataset$state[dataset$state %in% c("", "NA")] <- NA

# Displaying total NAs per column
colSums(is.na(dataset[c("dur", "sbytes", "proto", "state", "dbytes", "sttl", "dttl", "label")]))

# Using median imputations for numeric columns
dataset$dur[is.na(dataset$dur)] <- median(dataset$dur, na.rm = TRUE)
dataset$sbytes[is.na(dataset$sbytes)] <- median(dataset$sbytes, na.rm = TRUE)
dataset$dbytes[is.na(dataset$dbytes)] <- median(dataset$dbytes, na.rm = TRUE)
dataset$sttl[is.na(dataset$sttl)] <- median(dataset$sttl, na.rm = TRUE)
dataset$dttl[is.na(dataset$dttl)] <- median(dataset$dttl, na.rm = TRUE)

# Mode function
getMode <- function(v) { 
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Mode imputation for categorical
dataset$proto[is.na(dataset$proto)] <- getMode(dataset$proto)
dataset$state[is.na(dataset$state)] <- getMode(dataset$state)

# Removing rows with missing label
dataset <- dataset[!is.na(dataset$label) & dataset$label != "", ]

# ---- STEP 6: Collapsing infrequent categories ----

# Displaying all categories
table(dataset$proto)
table(dataset$state)

# Importing required library
library(forcats)

# Collapsing proto: treating levels with < 500 occurrences as "OTHER"
dataset$proto <- fct_lump_min(dataset$proto, min = 500)

# Collapsing state: treating levels with < 1000 occurrences as "OTHER"
dataset$state <- fct_lump_min(dataset$state, min = 1000)

# ---- STEP 7: Validating data integrity ----

# Checking for invalid or impossible values
summary(dataset[c("dur", "sbytes", "dbytes", "sttl", "dttl")])

# Numerical variables must be non-negative
any(dataset$dur < 0)
any(dataset$sbytes < 0)
any(dataset$dbytes < 0)
any(dataset$sttl < 0)
any(dataset$dttl < 0)

# proto and state must have "Other" category
table(dataset$proto)
table(dataset$state)

# label must contain only 0 and 1
table(dataset$label)

# ---- STEP 8: Final verification and summary ----
summary(dataset[c("dur", "sbytes", "proto", "state", "dbytes", "sttl", "dttl", "label")])

# Saving cleaned dataset
write.csv(dataset, "UNSW-NB15_cleaned_subset_final.csv", row.names = FALSE)

# ============================================
# END OF CLEANING PROCESS
# ============================================

# ============================================
# DATA ANALYSIS
# ============================================

# Importing required libraries
library(dplyr)         # for data manipulation
library(ggplot2)       # for visualization
library(reshape2)      # for data reshaping
library(caret)         # for evaluating model performance
library(caTools)       # for data splitting
library(randomForest)  # for building random forest models
library(VIM)           # for handling missing data

# ----------------------------------
# ANALYSIS 3-1: DESCRIPTIVE ANALYSIS
# ----------------------------------

# Summary Statistics
summary(dataset[, c("dur", "sbytes")])
dataset %>%
  group_by(label) %>%
  summarise(
    mean_dur = mean(dur, na.rm = TRUE),
    median_dur = median(dur, na.rm = TRUE),
    mean_sbytes = mean(sbytes, na.rm = TRUE),
    median_sbytes = median(sbytes, na.rm = TRUE),
    count = n()
  )

# Histogram dur
ggplot(dataset, aes(x = dur, fill = label)) +
  geom_histogram(bins = 60, alpha = 0.7, position = "identity") +
  labs(title = "Distribution of Connection Duration",
       x = "Duration (seconds)", y = "Count")

# Box Plot dur
ggplot(dataset, aes(x = label, y = dur, fill = label)) +
  geom_boxplot(outlier.alpha = 0.3) +
  labs(title = "Connection Duration by Attack Presence",
       x = "Label (0 = Normal, 1 = Attack)", y = "Duration (seconds)")

# Box Plot sbytes
ggplot(dataset, aes(x = label, y = sbytes, fill = label)) +
  geom_boxplot(outlier.alpha = 0.3) +
  labs(title = "Source Bytes by Attack Presence",
       x = "Label (0 = Normal, 1 = Attack)", y = "Source Bytes")

# Density Plot sbytes
ggplot(dataset, aes(x = sbytes, color = label, fill = label)) +
  geom_density(alpha = 0.3) +
  labs(title = "Density Distribution of Source Bytes by Attack Presence",
       x = "Source Bytes", y = "Density")

# ----------------------------------
# ANALYSIS 3-2: CORRELATION ANALYSIS
# ----------------------------------

# Scatter Plot
ggplot(dataset, aes(x = dur, y = sbytes, color = label)) +
  geom_point(alpha = 0.4, size = 1) +
  labs(title = "Relationship between Duration and Source Bytes",
       x = "Duration", y = "Source Bytes")

# Spearman's Correlation Coefficient
correlation <- cor(dataset$dur, dataset$sbytes, method = "spearman", use = "complete.obs")
correlation

# Correlation Heatmap
subset_data <- dataset[, c("dur", "sbytes")]
corr_matrix <- cor(subset_data, method = "spearman")
melted_corr <- melt(corr_matrix)

ggplot(melted_corr, aes(Var1, Var2, fill = value)) +
  geom_tile() +
  geom_text(aes(label = round(value, 2)), color = "white") +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limit = c(-1, 1)) +
  labs(title = "Correlation Heatmap of Duration and Source Bytes",
       x = "", y = "")

# ------------------------------------------------------------
# ANALYSIS 3-3: GROUP DIFFERENCE ANALYSIS (HYPOTHESIS TESTING)
# ------------------------------------------------------------

# T-tests
t.test(dur ~ label, data = dataset)
t.test(sbytes ~ label, data = dataset)

# Wilcoxon Rank-Sum Tests
wilcox.test(dur ~ label, data = dataset)
wilcox.test(sbytes ~ label, data = dataset)

# ------------------------------------------------------------
# ANALYSIS 3-4: PREDICTIVE ANALYSIS (CLASSIFICATION MODELLING)
# ------------------------------------------------------------

# ---- LOGISTIC REGRESSION ----

# Train-Test Split
set.seed(123)   
split <- sample.split(dataset$label, SplitRatio = 0.8)

training_set <- subset(dataset, split == TRUE)
test_set     <- subset(dataset, split == FALSE)

dim(training_set)
dim(test_set)

# Logistic Regression Model
classifier <- glm(label ~ dur + sbytes + dbytes + sttl + dttl + proto + state,
                  data = training_set, 
                  family = binomial)

summary(classifier)

# Prediction
pred_prob_test <- predict(classifier, type = "response",
                          newdata = test_set)

pred_class_test <- ifelse(pred_prob_test > 0.5, "1", "0")
pred_class_test <- factor(pred_class_test, levels = c("0", "1"))
test_set$label  <- factor(test_set$label, levels = c("0","1"))

# Confusion Matrix
cm <- confusionMatrix(pred_class_test, test_set$label)
cm

# ---- RANDOM FOREST ----

# Ensuring No NA Values
training_set <- hotdeck(training_set, domain_var = "label", imp_var = FALSE)
test_set     <- hotdeck(test_set, domain_var = "label", imp_var = FALSE)

training_set$label <- droplevels(training_set$label)
test_set$label <- droplevels(test_set$label)

levels(training_set$label)

# Random Forest Model
rf_model <- randomForest(
  label ~ dur + sbytes + dbytes + sttl + dttl + proto + state,
  data = training_set,
  ntree = 500
)

# Model Summary and Variable Importance Plot
rf_model
importance(rf_model)
varImpPlot(rf_model)

# Prediction
y_pred_rf <- predict(rf_model, newdata = test_set)

# Confusion Matrix
cm_rf <- confusionMatrix(table(y_pred_rf, test_set$label))
cm_rf

# ============================================
# END OF ANALYSIS
# ============================================