---
title       : Fixed Effects Model
description : Exercises to accompany Lecture 4.1 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Precision 

What is the definition of precision?

*** =instructions
- The study sample size.
- The study variance.
- The inverse of the study variance.

*** =hint
Precision is strongly related to a study sample size.

*** =sct
```{r}
msg1 <- "Nope. Sample size and precision are related but not equal."
msg2 <- "Try again. Precision is the opposite of variance."
msg3 <- "You got it! Precision is the reciprocal of the study variance."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Fixed Effects Model

What is not an assumption of the fixed effects model?

*** =instructions
- The summary effect is normally distributed.
- The summary effect is the average of the study effects.
- The summary effect's variance is known.

*** =hint
The summary effect is a weighted average of the study effects.


*** =sct
```{r}
msg1 <- "Try again. The FE model does assume a normal distribution."
msg2 <- "Correct! The summary effect is not a simple average, it is a weighted average."
msg3 <- "Nope. The FE model does assume a known variance."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Precision Weights

Obtain the precision weights for the log-risk ratio in the `catheter` dataset.


*** =instructions
- Inspect the `catheter` dataset.
- Use `escalc` from `metafor` to compute the log risk ratio variance.
- Obtain the precision and name it `precision`.


*** =hint
Recall precision is the inverse variance.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(catheter)
```


*** =solution
```{r}
catheter

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "RR"
)

precision <- 1 / obj$vi
```

*** =sct
```{r}
test_error()
test_object("precision")
success_msg("Great job! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Weight Contribution

Determine which study will contribute the most to the summary effect estimate?

*** =instructions
- Assume you have the `precision` from the previous exercise.
- Record the name of the study in `influential_study`.

*** =hint
Look for the study with the greatest precision.

*** =pre_exercise_code
```{r}
library(metafor)
library(rmeta)
data(catheter)

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "RR"
)

precision <- 1 / obj$vi
```


*** =solution
```{r}
max_precision <- max(precision, na.rm = TRUE)
max_precision

influential_study <- catheter$Name[which(precision == max_precision)]
influential_study
```

*** =sct
```{r}
test_error()
test_object("influential_study")
success_msg("That's right! You are ready to continue.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Fitting the Fixed Effect Model

Obtain the fixed effects summary for the `catheter` meta-analysis using the log risk ratio measure of effect.


*** =instructions
- Use the `rma` function.
- Use the `FE` method.
- Save the summary effect as `theta`.
- Assume that you already have the `catheter` dataset in the working environment.

*** =hint
The summary effect is stored as `b`.

*** =pre_exercise_code
```{r}
library(metafor)
library(rmeta)
data(catheter)
```


*** =solution
```{r}
obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "RR"
)

fit <- rma(yi = obj$yi, vi = obj$vi, method = "FE")
theta <- fit$b
```

*** =sct
```{r}
test_error()
test_object("theta")
success_msg("Great! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:300 skills:5
## Confidence Interval

Obtain the 95% CI for the risk ratio effect in the `catheter` data. 


*** =instructions
- Assume the `rma` FE model for the `catheter` data is named `fit`.
- Save the lower and upper CI in the object `ci`.

*** =hint
Remember to exponentiate!

*** =pre_exercise_code
```{r}
library(metafor)
library(rmeta)
data(catheter)

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "RR"
)


fit <- rma(yi = obj$yi, vi = obj$vi, method = "FE")
```

*** =solution
```{r}
ci <- exp(c(fit$ci.lb, fit$ci.ub))
ci
```

*** =sct
```{r}
test_error()
test_object("ci")
success_msg("Great work! You are all done!")
```

---
