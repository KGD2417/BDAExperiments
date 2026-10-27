data(mtcars)
head(mtcars)

par(mfrow = c(2, 3))

barplot(table(mtcars$cyl),
        main = "1. Bar Chart: Cars by Cylinders",
        xlab = "Cylinders", ylab = "Count",
        col = c("skyblue", "orange", "lightgreen"))

hist(mtcars$mpg,
     main = "2. Histogram: Miles per Gallon",
     xlab = "MPG", col = "lightcoral", border = "black", breaks = 8)

boxplot(mpg ~ cyl, data = mtcars,
        main = "3. Box Plot: MPG by Cylinders",
        xlab = "Cylinders", ylab = "MPG",
        col = c("gold", "plum", "lightblue"))

plot(mtcars$wt, mtcars$mpg,
     main = "4. Scatter Plot: Weight vs MPG",
     xlab = "Weight (1000 lbs)", ylab = "MPG",
     pch = 19, col = "darkblue")

gear_counts <- table(mtcars$gear)
pie(gear_counts,
    labels = paste(names(gear_counts), "gears:", gear_counts),
    main = "5. Pie Chart: Cars by Gears",
    col = rainbow(length(gear_counts)))

sorted <- mtcars[order(mtcars$hp), ]
plot(sorted$hp, sorted$mpg, type = "o",
     main = "6. Line Chart: Horsepower vs MPG",
     xlab = "Horsepower", ylab = "MPG", col = "darkgreen", pch = 16)

par(mfrow = c(1, 1))
