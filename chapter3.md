---
title       : Types of Effect
description : Exercises to accompany Part 3 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:c47531922409bfde495988b8492caed5f83068cb

## Choosing an Effect Size (1)

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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:95b69f3ad6349dc5bd9a999812d11d8417ddb008

## Choosing an Effect Size (2)

Inspect that dataset `dat.normand1999`. Which of the following effect sizes would _not_ be appropriate?

*** =instructions
- Mean difference
- Mean
- Odds Ratio

*** =hint
Type `dat.normand1999` in the console.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.normand1999)
```

*** =sct
```{r}
msg1 <- "No. This would be an appropriate summary for the difference of the two groups."
msg2 <- "Try again. This would be an appropriate summary for one of the groups."
msg3 <- "Correct! Odds ratios are suitable effect measures for summaries of binary outcomes."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:200 skills:1 key:9be0c6b97b4ccc6da4cd0b6780da4b8279b74138
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


--- type:NormalExercise lang:r  xp:100 skills:1 key:c0efe88701ae6a7fdc7ee1c48970d1488acd7e89
## Using the `escalc` Function

Calculate the log odds ratio between the events of the `e` and `c` groups of the `Olkin95` dataset. Recall that in the 2x2 contingency table, position 'a' is used for the events in the treatment group and 'c' for the events in the control group.

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
result <- escalc(ai = event.e, bi = n.e - event.e,
	ci = event.c, di = n.c - event.c,
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


--- type:NormalExercise lang:r  xp:200 skills:1 key:3cce365610a0ab3b7d9ef53e838d6fc67108200f
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
result <- escalc(ai = event.e, bi = n.e - event.e,
	ci = event.c, di = n.c - event.c,
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


--- type:NormalExercise lang:r  xp:300 skills:5 key:4749c1badeec331a1079f1fc36cee32bf525ccad
## Working with Continuous Outcomes

Calculate the mean difference in length of stay using the dataset `dat.normand1999`. 

*** =instructions
- The outcome is the `m1i`  and `m2i` variables.
- Save your results in the object `result`.


*** =hint
Make sure to include the `sd` and `n` variables.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.normand1999)
```

*** =solution
```{r}
result <- escalc(m1i = m1i, m2i = m2i,
		sd1 = sd1i, sd2 = sd2i,
		n1 = n1i, n2 = n2i, 
		measure = "MD", data = dat.normand1999)
```

*** =sct
```{r}
test_error()
test_object("result")
success_msg("Excellent work! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:300 skills:5 key:5fecf88a095e785ec5f4170e6bca93ef6a6f628e
## Comparing Effects

Calculate the standardized mean difference for the previous problem and contrast it with the mean difference in a plot. Do both effect sizes appear to be highly correlated or not?


*** =instructions
- Use the measure `SMD`.
- Assume that `result` is already available.
- Create new data.frame with the `SMD` outcomes as `result2`.
- Add the `SMD` to the `result` data.frame and name it `SMD`.
- Use `ggplot` to contrast the two effects.

*** =hint
Make sure to create new names for each outcome type.

*** =pre_exercise_code
```{r}
library(metafor)
library(ggplot2)

data(dat.normand1999)


result <- escalc(m1i = m1i, m2i = m2i,
		sd1 = sd1i, sd2 = sd2i,
		n1 = n1i, n2 = n2i, 
		measure = "MD", data = dat.normand1999)

```

*** =solution
```{r}
result2 <- escalc(m1i = m1i, m2i = m2i,
		sd1 = sd1i, sd2 = sd2i,
		n1 = n1i, n2 = n2i, 
		measure = "SMD", data = dat.normand1999)

names(result)[names(result) == "yi"] <- "MD"
names(result2)[names(result2) == "yi"] <- "SMD"

result$SMD <- result2$SMD

ggplot(result, aes(y = MD, x = SMD)) +
	geom_point()
```

*** =sct
```{r}
test_error()
test_function("ggplot", args = "data",
              not_called_msg = "You didn't call ggplot to compare your effects.")
success_msg("Awesome! You are all done.")
```


