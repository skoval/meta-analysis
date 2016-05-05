---
title       : Fixed Effects Model
description : Exercises to accompany Part 4 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:a76756041c2b84f6baf9db8434f6f42f7748123d

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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:71660230b2c94797b8304bd081c1aa31c8db3c01

## Fixed Effects Model

What is _not_ an assumption of the fixed effects model?

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


--- type:NormalExercise lang:r  xp:200 skills:1 key:7c9df71fdb875764f2536abe89f6b7f4ad25b07a
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


--- type:NormalExercise lang:r  xp:100 skills:1 key:541329a148136e730811da58fdc1118d88dfb141
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


<<<<<<< HEAD
--- type:NormalExercise lang:r  xp:200 skills:1
## Fitting the Fixed Effects Model
=======
--- type:NormalExercise lang:r  xp:200 skills:1 key:db3185167238bb00fd8411f6070d7e0faf151fec
## Fitting the Fixed Effect Model
>>>>>>> 3a508c5957c099f03ce1ab459dea5a78f67b3fd4

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


--- type:NormalExercise lang:r  xp:300 skills:5 key:23dc621c35b87203b571c95c74a4ecab59b0e252
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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:26d3ad9b8748c3eb84ebdb57a4a935c75093541c

## Random Effects


Which statement about the random effects model for meta-analysis is correct?

*** =instructions
- It assumes that the true study effect size is not equal for all studies.
- It assumes that the population effect size is random.
- It assumes the variance of the study effects is random.

*** =hint
Recall that the random effects model allows variation in study effects.

*** =sct
```{r}
msg1 <- "That's right. The random effects model allows between-study variability."
msg2 <- "Try again. The population effect is treated as a constant, unknown parameter."
msg3 <- "No. Variance parameters are not treated as random."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:984ea53935a231ec024ef32fafa62df2d3f91d27

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


--- type:NormalExercise lang:r  xp:100 skills:1 key:9acc7bf25f28498fed58fe335ce0378c9f19ae29
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


--- type:NormalExercise lang:r  xp:200 skills:1 key:40009ab474483e80554d002d18bd13d9bef544f8
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


--- type:NormalExercise lang:r  xp:200 skills:1 key:db2adf0d3145919eaab9f2612be241fb0126f878
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


--- type:NormalExercise lang:r  xp:300 skills:5 key:671990bb1696ded711b95f58e495cd077d4b03e2
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