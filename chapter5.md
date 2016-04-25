---
title       : Heterogeneity and Bias
description : Exercises to accompany Part 5 of `Meta-Analysis with R'

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
I2.rr <- confint(fit.rr)$random[3,2:3]

I2.or
I2.rr
```


*** =sct
```{r}
test_error()
test_object("I2.or")
test_object("I2.rr")
success_msg("You should be so pleased! You are all done with exercises for Lecture 5.1!")
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Concern with Bias

Why is protecting against bias in a meta-analysis important?

*** =instructions
- Readers will not be interested in a biased study.
- A biased meta-analysis misrepresents the evidence for the scientific question being evaluated. 
- A biased meta-analysis won't get past peer-review.

*** =hint
Consider which response is the best definition of meta-analysis. 

*** =sct
```{r}

msg1 <- "Try again. The interest of readers isn't a main concern when it comes to avoiding bias."
msg2 <- "That's right. Bias, by definition, distorts the truth."
msg3 <- "No. The presence of bias might, if obvious to reviewers, raise red flags but this isn't the primary reason to make efforts to protect against bias."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Types of Bias

Consider each of the situations described below. Which raises the least concern about potential bias?


*** =instructions
- In a clinical trial, the sickest patients dropped out of the study before it was completed.
- The authors of the trial did not report any null findings. 
- The authors did not report baseline characteristics about the participants. 

*** =hint
Recall that bias is a systematic misrepresentation of the effect of interest.

*** =sct
```{r}

msg1 <- "Try again. This is an example of possible attrition bias."
msg2 <- "No. This is an example of possible reporting bias."
msg3 <- "You got it. The lack of reporting about the sample characteristics is poor writing but doesn't suggest any bias in the study findings."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:100 skills:5
## Making a Funnel Plot

Obtain a funnel plot for the log-OR effects of the `dat.bcg` trial.


*** =instructions
- Fit the `DL` model for the log-OR effects for the `dat.bcg` study.
- Use the `rma` plotting method to create a funnel plot.


*** =hint
Use the `funnel` method.

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


funnel(fit.or)
```


*** =sct
```{r}
test_error()

test_function("funnel", args = "x",
              not_called_msg = "You should use the funnel method.")

success_msg("You should be thrilled! You made a funnel plot.")
```


--- type:NormalExercise lang:r  xp:100 skills:5
## Trim-And-Fill

Use the trim-and-fill method to estimate the number of missing studies due to publication bias.


*** =instructions
- Fit the `DL` model for the log-OR effects for the `dat.bcg` study.
- Use the `trimfill` to find the estimated number of missing studies.
- Save your result as `bias`.


*** =hint
Use the `trimfill` method.

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

bias <- trimfill(fit.or)
bias
```


*** =sct
```{r}
test_error()
test_object("bias")
success_msg("Great job. You are mastering these topics.")
```


--- type:NormalExercise lang:r  xp:100 skills:5
## Rank Test

The `metafor` package includes a function `ranktest` that tests for asymmetry in the funnel plot. Determine the results of this test for the `dat.bcg` meta-analysis.


*** =instructions
- Fit the `DL` model for the log-OR effects for the `dat.bcg` study.
- Use the `ranktest` method and save your result as `result`.


*** =hint
The method is applied to an object of call `rma`.

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

result <- ranktest(fit.or)
result
```


*** =sct
```{r}
test_error()
test_object("result")
success_msg("Excellent. That's exactly right!")
```



--- type:NormalExercise lang:r  xp:100 skills:5
## Fail-Safe Number

What is the fail-safe number for the `dat.bcg` meta-analysis? Is your finding consistent with the funnel plot analysis?


*** =instructions
- Use the `escalc` method to obtain the log-OR estimates for the `dat.bcg` study.
- Find the fail-safe number using the appropriate method from the `rma` package.
- Save your result as the object `failsafe`.


*** =hint
Use the `fsn` method.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
obj <-  escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

failsafe <- fsn(obj$yi, obj$vi)
failsafe
```


*** =sct
```{r}
test_error()
test_object("failsafe")
success_msg("Excellent. You really have this down!")
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Interpreting Publication Bias Tools

What is a major caveat with tests for publication bias like the funnel plot that could make it difficult to reach a conclusion about bias with the `dat.bcg` meta-analysis?

*** =instructions
- The trials have different study designs.
- The results across trials are very heterogeneous.
- The authors didn't search for non peer-reviewed articles.


*** =hint
Look at the $I^2$ for this study.

*** =sct
```{r}

msg1 <- "Try again. The trials all had a similar design, and trial design isn't a central issue for the validity of publication bias evaluation."
msg2 <- "Correct. Heterogeneity can make it difficult to detect evidence of bias."
msg3 <- "No. We don't have enough information about the search strategy to know if this is the case."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```
