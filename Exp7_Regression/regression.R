data(mtcars)

linear_model <- lm(mpg ~ wt, data = mtcars)
print(summary(linear_model))

plot(mtcars$wt, mtcars$mpg,
     main = "Linear Regression: MPG vs Weight",
     xlab = "Weight (1000 lbs)", ylab = "MPG", pch = 19, col = "blue")
abline(linear_model, col = "red", lwd = 2)

new_car <- data.frame(wt = 3.0)
cat("Predicted MPG for weight 3.0:", predict(linear_model, new_car), "\n")


logistic_model <- glm(am ~ wt, data = mtcars, family = binomial)
print(summary(logistic_model))

plot(mtcars$wt, mtcars$am,
     main = "Logistic Regression: Transmission vs Weight",
     xlab = "Weight (1000 lbs)", ylab = "Probability of Manual (am = 1)",
     pch = 19, col = "darkgreen")
wt_range <- data.frame(wt = seq(min(mtcars$wt), max(mtcars$wt), length.out = 100))
lines(wt_range$wt, predict(logistic_model, wt_range, type = "response"), col = "red", lwd = 2)

prob <- predict(logistic_model, type = "response")
predicted_class <- ifelse(prob > 0.5, 1, 0)
print(table(Actual = mtcars$am, Predicted = predicted_class))
cat("Accuracy:", mean(predicted_class == mtcars$am), "\n")


multiple_model <- lm(mpg ~ wt + hp + disp, data = mtcars)
print(summary(multiple_model))

par(mfrow = c(2, 2))
plot(multiple_model)
par(mfrow = c(1, 1))

plot(mtcars$mpg, fitted(multiple_model),
     main = "Multiple Regression: Actual vs Predicted MPG",
     xlab = "Actual MPG", ylab = "Predicted MPG", pch = 19, col = "purple")
abline(0, 1, col = "red", lwd = 2)

cat("Predicted MPG:", predict(multiple_model, data.frame(wt = 3.0, hp = 120, disp = 200)), "\n")
