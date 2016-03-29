---
title       : Data Preparation
description : Exercises to accompany Lecture 2.2 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Identifying Dataset Format

Inspect that dataset `smoking`. Which format is this an example of?

*** =instructions
- Wide format
- Long format

*** =hint
Type `smoking` in the console.

*** =pre_exercise_code
```{r}
library(meta)
data(smoking)
```

*** =sct
```{r}
msg1 <- "Correct! Each row corresponds to one study and there are columns for separate treatment groups."
msg2 <- "Try again. Long format would not have separate variables for each treatment group."
test_mc(correct = 1, feedback_msgs = c(msg1, msg2)) 
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Creating Long Format

Use the `study`, `trt`, and `event` variables in the workshape and put them into a data.frame in long format.

*** =instructions
- Store your data.frame as the object `meta_data`

*** =hint 
Use the `data.frame` function.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
```


*** =solution
```{r}
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)


meta_data
```

*** =sct
```{r}
test_error()
test_object("meta_data")
success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Creating Wide Format

Convert the long data.frame created in the previous exercise into wide format using the `reshape` function.

*** =instructions
- Store your new data.frame as the object `wide_meta_data`

*** =hint 
Use the `reshape` function.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)
```


*** =solution
```{r}
wide_meta_data <- reshape(meta_data, idvar = "study", timevar = "trt", direction = "wide")
wide_meta_data
```

*** =sct
```{r}
test_error()
test_object("wide_meta_data")
success_msg("Good job! Head over to the next exercise")
```



--- type:NormalExercise lang:r  xp:100 skills:5
## Deriving Variables in Wide Format

Create a new variable for the `wide_meta_data` that is the difference in the events between treatment groups.

*** =instructions
- Take the difference from treatment group "a" and "b"
- Call this variable `diff`

*** =hint 
Use the `$` operator.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)
wide_meta_data <- reshape(meta_data, idvar = "study", timevar = "trt", direction = "wide")
```


*** =solution
```{r}
wide_meta_data$diff <- with(wide_meta_data, event.a - event.b)
wide_meta_data
```

*** =sct
```{r}
test_error()
test_object("wide_meta_data")
success_msg("Good job! Head over to the next exercise")
```


