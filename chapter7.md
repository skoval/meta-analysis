---
title       : Types of Effect
description : Exercises to accompany Lecture 3 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Choosing an Effect Size

Inspect that dataset `Olkin95`. Which of the following effect sizes would _not_ be appropriate?

*** =instructions
- Mean difference
- Proportion
- Odds Ratio
- Risk Ratio

*** =hint
Type `Olkin95` in the console.

*** =pre_exercise_code
```{r}
library(meta)
data(Olkin95)
```

*** =sct
```{r}
msg1 <- "Correct! Mean differences are intended for underlying continuous data not binary data."
msg2 <- "Try again. This would be an appropriate summary for one of the groups."
msg3 <- "Nope. This would be an appropriate summary for comparing the outcomes of the two groups."
msg4 <- "Try again. This would be an appropriate summary for comparing the outcomes of the two groups."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3, msg4)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Choosing an Effect Size

Inspect that dataset `dat.senn2013`. Which of the following effect sizes would _not_ be appropriate?

*** =instructions
- Mean difference
- Mean
- Odds Ratio

*** =hint
Type `dat.senn2013` in the console.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.senn2013)
```

*** =sct
```{r}
msg1 <- "No. This would be an appropriate summary for the difference of the two groups."
msg2 <- "Try again. This would be an appropriate summary for one of the groups."
msg3 <- "Correct! Odds ratios are suitable effect measures for summaries of binary outcomes."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Calculating an Effect Size

Calculate the difference in proportions for the `e` and `c` groups of the `Olkin95` dataset. 

*** =instructions
- Calculate the difference in the event proportion of `e` and `c` manually.
- Store this in an object called `theta`

*** =hint
Type `Olkin95` in the console.

*** =pre_exercise_code
```{r}
library(meta)
data(Olkin95)
```


*** =solution
```{r}
theta <- with(Olkin95, event.e / n.e - event.c / n.c)
```

*** =sct
```{r}
test_error()
test_object("theta")
success_msg("Excellent work! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Using the `escalc` Function

Calculate the log odds ratio between the events of the `e` and `c` groups of the `Olkin95` dataset. 

*** =instructions
- Use the `escalc` function.
- Store the results in the object `result`.

*** =hint
Use the `measure` "OR"

*** =pre_exercise_code
```{r}
library(metafor)
library(meta)
data(Olkin95)
```


*** =solution
```{r}
result <- escalc(ai = event.e, bi = event.c,
	ci = n.e - event.e, di = n.c - event.c,
	n1 = n.e, n2 = n.c, 
	measure = "OR", data = Olkin95
)
```

*** =sct
```{r}
test_error()
test_object("result")
success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Inspecting the Effects

Create a plot of the odds ratios between the events of the `e` and `c` groups of the `Olkin95` dataset and determine the study with the largest odds ratio.

*** =instructions
- Assume `result` is already available.
- Use the `plot` function.
- Store the name of the author in `largest`.

*** =hint
Remember to transform the `OR` result from the log scale.

*** =pre_exercise_code
```{r}
library(metafor)
library(meta)
data(Olkin95)
result <- escalc(ai = event.e, bi = event.c,
	ci = n.e - event.e, di = n.c - event.c,
	n1 = n.e, n2 = n.c, 
	measure = "OR", data = Olkin95
)
```


*** =solution
```{r}
plot(exp(yi) ~ 1, data = result)

max(exp(result$yi))

largest <- result$author[exp(result$yi) == 3.2]
```

*** =sct
```{r}
test_error()
test_object("largest")
success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:300 skills:5
## Working with Continuous Outcomes

Use the `formula` argument to calculate the mean difference of lowered glucose for `rosiglitazone` versus `placebo` in the  dataset `dat.senn2013`. 

*** =instructions
- The outcome is the `mi` variable.
- Only 2 of the treatment groups are of interest.
- The dataset is in long format so use the `formula` argument.
- Save your results in the object `result`
- Limit the analysis to the following studies: Davidson (2007), Wolffenbuttel (1999), Kerenyi (2004), and Baksi (2004).

*** =hint
Make sure to subset the data to the correct treatment groups.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.senn2013)
```

*** =solution
```{r}
studies <- c("Davidson (2007)", "Wolffenbuttel (1999)", "Kerenyi (2004)", "Baksi (2004)")

data <- subset(dat.senn2013, treatment %in% c("rosiglitazone", "placebo") & study %in% studies)

data$treatment <- factor(data$treatment )
data$study <- factor(data$study)

result <- escalc(measure = "MD", formula = mi/sdi ~ treatment | study, 
		weights = ni, data = data)
```

*** =sct
```{r}
test_error()
test_object("result")
success_msg("Excellent work! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:300 skills:5
## Comparing Effects

Calculate the standardized mean difference for the previous problem and contrast it with the mean difference in a plot.


*** =instructions
- Use the measure `SMD`.
- Assume that the `result` and `data` objects are already available.
- Create new data.frame with the `SMD` outcomes as `result2` and combine the two datasets for plotting. 
- Use `ggplot` to contrast the two effects.

*** =hint
Make sure to use the formula argument of `escalc`.

*** =pre_exercise_code
```{r}
library(metafor)
library(ggplot2)

data(dat.senn2013)

studies <- c("Davidson (2007)", "Wolffenbuttel (1999)", "Kerenyi (2004)", "Baksi (2004)")

data <- subset(dat.senn2013, treatment %in% c("rosiglitazone", "placebo") & study %in% studies)

data$treatment <- factor(data$treatment )
data$study <- factor(data$study)

result <- escalc(measure = "MD", formula = mi/sdi ~ treatment | study, 
		weights = ni, data = data)
```

*** =solution
```{r}
result2 <- escalc(measure = "SMD", formula = mi/sdi ~ treatment | study, 
		weights = ni, data = data)

names(result)[1] <- "MD"
names(result2)[1] <- "SMD"


combine <- cbind(result, result2)

ggplot(combine, aes(y = MD, x = SMD)) +
	geom_point()
```

*** =sct
```{r}
test_error()
test_function("ggplot", args = "data",
              not_called_msg = "You didn't call ggplot to compare your effects.")
test_object("result2")
success_msg("Awesome! You are all done.")
```


