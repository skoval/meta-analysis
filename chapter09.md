---
title       : Random Effects Model
description : Exercises to accompany Lecture 4.2 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Random Effects


Which statement about the random effects model for meta-analysis is correct?

*** =instructions
- It assumes that the true study effect size is not equal for all studies.
- It assumes that the population effect size is random.
- It assumes the variance of the study effects is random.

*** =hint
Recall that the random effects models allows variation in study effects.

*** =sct
```{r}
msg1 <- "That's right. The random effects model allows between-study variability."
msg2 <- "Try again. The population effect is treated as a constant, unknown parameter."
msg3 <- "No. Variance parameters are not treated as random."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Fixed Versus Random Effects Model

Which of the following is a true difference about the fixed and random effects models?

*** =instructions
- The fixed effects model has a parameter $\tau^2$.
- The models result in a different estimate for $\theta$.
- The random effects model has a wider confidence interval for $\hat{\theta}$.

*** =hint
The random effects model introduces additional variation for the overall effect size.

*** =sct
```{r}
msg1 <- "Try again. The FE model does not have between-study variance."
msg2 <- "No. Both models can have the same summary effect."
msg3 <- "That's right. The random effects model will generally have greater variance in its estimate because it assumes between-study variability."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Random Effects Model

Fit the random effects model for the log-odds ratio in the `catheter` dataset.


*** =instructions
- Assume `catheter` is already available.
- Use `escalc` from `metafor` to compute the log odds ratio and variance.
- Fit the DerSimonian-Laird random effects model using `rma`.
- Store your result as the object named  `fit`.

*** =hint
Use the method `DL`.

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
	data = catheter, measure = "OR"
)

fit <- rma(yi = obj$yi, vi = obj$vi, method = "DL")
```

*** =sct
```{r}
test_error()
test_object("fit")
success_msg("Great job! You are ready for the next exercise.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Compare the Fixed and Random Effects Models

Contrast the result from the random effects model with the fixed effects model.

*** =instructions
- Assume `fit` is available and has the `rma` result of the DL RE model.
- Compute the fixed effects model estimate.
- Assign your result to the object `fit.fixed`.
- Save the difference of the FE and RE summary effects as `model.diff`.

*** =hint
Use method `FE` for the fixed effect model.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(catheter)

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "OR"
)

fit <- rma(yi = obj$yi, vi = obj$vi, method = "DL")
```


*** =solution
```{r}
fit.fixed <- rma(yi = obj$yi, vi = obj$vi, method = "FE")

fit.fixed

model.diff <- fit$b - fit.fixed$b
model.diff
```

*** =sct
```{r}
test_error()
test_object("model.diff")
test_object("fit.fixed")
success_msg("Great job! You are mastering this.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Compare the CI for the FE and RE Models

Contrast the widths of the confidence intervals for the fixed and random effects models using the `catheter` meta-analysis. What do you observe?


*** =instructions
- Assume that the `fit.fixed` and `fit` models from the previous exercises are available.
- Obtain the 95% CI for each model's effect estimate.
- Compute the difference in the upper and lower CI and compare the RE and FE differences.
- Subtract the two and store your finding as the object `ci.diff`.

*** =hint
You can find the CI as `ci.lb` and `ci.ub`.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(catheter)

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "OR"
)

fit <- rma(yi = obj$yi, vi = obj$vi, method = "DL")

fit.fixed <- rma(yi = obj$yi, vi = obj$vi, method = "FE")
```


*** =solution
```{r}
fixed_ci <- fit.fixed$ci.ub - fit.fixed$ci.lb
re_ci <- fit$ci.ub - fit$ci.lb
c(re_ci, fixed_ci)
ci.diff <- re_ci - fixed_ci
ci.diff
```

*** =sct
```{r}
test_error()
test_object("ci.diff")
success_msg("Great! You are really doing well.")
```


--- type:NormalExercise lang:r  xp:300 skills:5
## Estimators of Between-Study Variance

Obtain the estimate of $\tau^2$ for the RE model of the `catheter` data using the log-risk ratio measure of effect and three different estimator types.


*** =instructions
- Fit three different models for the Sidik-Jonkman, REML, and maximum-likelihood approaches, respectively.
- Extract the estimate of $\tau^2$
- Store the three estimates as a vector named `tau2` in the same order as listed above.

*** =hint
The methods are `SJ`, `REML`, and `ML`.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(catheter)

obj <- escalc(ai = col.trt, bi = col.ctrl,
	ci = n.trt - col.trt, di = n.ctrl - col.ctrl,
	data = catheter, measure = "RR"
)
```


*** =solution
```{r}
fitSJ <- rma(yi = obj$yi, vi = obj$vi, method = "SJ")
fitREML <- rma(yi = obj$yi, vi = obj$vi, method = "REML")
fitML <- rma(yi = obj$yi, vi = obj$vi, method = "ML")

tau2 <- c(fitSJ$tau2, fitREML$tau2, fitML$tau2)
tau2
```


*** =sct
```{r}
test_error()
test_object("tau2")
success_msg("Fantastic job! You are all done!")
```

---
