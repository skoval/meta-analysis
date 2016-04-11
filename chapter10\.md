---
title       : Heterogeneity
description : Exercises to accompany Lecture 5.1 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Apples and Oranges

What is the `apples and oranges` problem in meta-analysis?

*** =instructions
- When the meta-analysis performs too many analyses.
- When the meta-analysis mixes studies from different years.
- When the studies in the meta-analysis are too different to yield a meaningful summary effect.

*** =hint
It has to do with the similarity of the included studies.

*** =sct
```{r}

msg1 <- "Try again. This problem doesn't have anything to do with the number of analyses."
msg2 <- "No. Studies from different time periods isn't necessarily an apples and oranges problem."
msg3 <- "You got it. Combining very different studies is like mixing apples and oranges."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Definition of Heterogeneity

Which is the best description of heterogeneity when applied to meta-analysis?


*** =instructions
- Differences in meta-analytic models
- Differences in types of effect sizes
- Differences in characteristics of the included studies

*** =hint
This is related to the apples and oranges problem.

*** =sct
```{r}
msg1 <- "Try again. Heterogeneity isn't concerned with types of meta-analytic methods."
msg2 <- "No. Effect sizes are a choice of the meta-analyst and not a description of the studies involved."
msg3 <- "That's right. Heterogeneity refers to differences in the attributes of the studies of the meta-analysis."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Q Statistic


Obtain the `Q` statistic using the `dat.bcg` study and log-odds ratio measure of effect.


*** =instructions
- Assume `dat.bcg` is already available.
- Use `escalc` from `metafor` to compute the log odds ratio and variance.
- Find `Q` under the FE model and save it as the object `Q`.

*** =hint
Remember that `Q` looks at deviations from the overall summary effect.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
obj <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

theta <- sum(obj$yi / obj$vi) / sum(1/obj$vi) # FE summary

Q <- sum(1/obj$vi * (obj$yi - theta)^2)
Q
```

*** =sct
```{r}
test_error()
test_object("Q")
success_msg("Great job! You mastered the Q statistic.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Q Test

Use the `Q` statistic for the `dat.bcg` trial to test for evidence of heterogeneity.



*** =instructions
- Assume `Q` is already available.
- Obtain the p-value for the Q-test.
- Store your result as the object `pval`.


*** =hint
Remember that the Q test is based on a chi-squared statistic.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
obj <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

theta <- sum(obj$yi / obj$vi) / sum(1/obj$vi) # FE summary

Q <- sum(1/obj$vi * (obj$yi - theta)^2)
Q
```


*** =solution
```{r}
K <- length(obj$yi) # Number of studies (obj is escalc result)
pval <- pchisq(Q, df = K - 1, lower = FALSE) # One-sided test
pval
```

*** =sct
```{r}
test_error()
test_object("pval")
success_msg("Excellent. You are an expert at the Q test!")
```



--- type:NormalExercise lang:r  xp:200 skills:1
## Evaluating Q with `metafor`

Perform the Q test for the `dat.bcg` trial using the `rma` function.

*** =instructions
- Use the log-odds ratio effect size and the FE model
- Store Q as `Q` and the pvalue of the test as `pval`

*** =hint
Use method `FE` for the fixed effect model.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg, method = "FE")

Q <- fit$QE
pval <- fit$QEp

c(Q, pval)
```


*** =sct
```{r}
test_error()
test_object("Q")
test_object("pval")
success_msg("Great job! You are really getting the hang of this.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Heterogeneity Indices

Calculate the $I^2$ for the `dat.bcg` trial.


*** =instructions
- Use the log odds ratio effect measure.
- Put $I^2$ on the percentage scale (0, 100).
- Save your result as the object `I2`.

*** =hint
Remember that $I^2$ is a function of `Q`.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg, method = "FE")
K <- fit$k
Q <- fit$QE
I2 <- (Q - (K-1)) / Q * 100
I2
```

*** =sct
```{r}
test_error()
test_object("I2")
success_msg("Wow! Great work.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Heterogeneity Indices with `rma`

Calculate the $I^2$ for the `dat.bcg` trial using the `rma` function.


*** =instructions
- Use the log odds ratio effect measure.
- Fit the `rma` model that will give the `I2` equal to what you computed in the previous problem.
- Save your result as the object `I2`.

*** =hint
Remember that you should use the `DL` method.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg, method = "DL")
I2 <- fit$I2
I2
```

*** =sct
```{r}
test_error()
test_object("I2")
success_msg("Great job. You are almost there.")
```

--- type:NormalExercise lang:r  xp:300 skills:5
## Confidence Intervals for $I^2$

Does the log-RR or log-OR measure have greater heterogeneity for the `dat.bcg` trial?


*** =instructions
- Fit the DL model for both effect sizes for the `dat.bcg` study.
- Obtain a 95% CI for $I^2$ for both effect sizes.
- Save your results as `ci.or` and `ci.rr`.


*** =hint
Use the `confint` method.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
fit.or <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg, method = "DL")
fit.rr <- rma(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg, method = "DL")	

I2.or <- confint(fit.or)$random[3,2:3]
I2.rr <- confint(fit.orr)$random[3,2:3]

I2.or
I2.rr
```


*** =sct
```{r}
test_error()
test_object("I2.or")
test_object("I2.rr")
success_msg("You should be so pleased! You are all done!")
```

---
