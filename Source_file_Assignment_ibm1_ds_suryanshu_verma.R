# Load libraries
library(caret)
library(ggplot2)
# Creating the dataframe
data <- data.frame(
  id = c(1, 2, 3, 4, 5, 6, 7),
  weight = c(20, 27, 24, 22, 23, 25, 28),
  bp = c(140, 130, 120, 134, 100, 116, 143),
  locality = c("urban", "rural", "urban", "urban", "rural", "rural", "urban"),
  smoking = c("no", "yes", "no", "yes", "yes", "no", "yes"),
  tumour = c("small", "small", "large", "small", "large", "small", "large")
)

# Displaying the created dataframe
print(data)

### Analysis
# Plotting a graph between weight and blood pressure
plot(data$weight, data$bp, xlab = "Weight", ylab = "Blood Pressure", main = "Weight vs Blood Pressure")

# Creating a stacked chart between smoking and tumour
stacked_table <- table(data$smoking, data$tumour)
barplot(stacked_table, beside = TRUE, legend = TRUE, col = c("blue", "red"), 
        main = "Stacked Chart of Smoking and Tumour", xlab = "Smoking", ylab = "Frequency")

# Convert 'tumour' variable to factor with specified levels
data$tumour <- factor(data$tumour, levels = c("small", "large"))

# Splitting the data into training and testing sets
set.seed(123)
trainIndex <- createDataPartition(data$tumour, p = 0.7, list = FALSE)
train_data <- data[trainIndex, ]
test_data <- data[-trainIndex, ]

# Training a classification model (logistic regression)
model <- train(tumour ~ weight + bp + locality + smoking, 
               data = train_data, 
               method = "glm",
               family = "binomial")

# Making predictions on the test set
predictions <- predict(model, newdata = test_data)

# Evaluating the model
confusionMatrix(predictions, test_data$tumour)

# Extract confusion matrix data
cm_data <- as.data.frame(cm$table)

# Plot confusion matrix
ggplot(cm_data, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +
  labs(title = "Confusion Matrix",
       x = "Actual",
       y = "Predicted") +
  theme_minimal()


