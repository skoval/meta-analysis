---
title       : Advanced Topics
description : Exercises to accompany Part 7 of `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Defining Meta-Regression

What does it mean when a reseacher says they performed a meta-regression?

*** =instructions
- They summarized treatment effect across multiple studies.
- They adjusted for study covariates in the meta-analysis.
- They used a weighted analysis to summarize study effects.

*** =hint
Meta-regression can be used to summarize study effects for subgroups.


*** =sct
```{r}

msg1 <- "Try again. This is the description of a standard meta-analysis."
msg2 <- "Yes, The purpose of meta-regression is to incorporate study covariates into the analysis."
msg3 <- "No. Weighting is not unique to meta-regression."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Purpose of Meta-Analysis

Which of the following is not a reason to perfom meta-regression?


*** =instructions
- To see how patient characteristics influence treatment effect.
- To estimate study effects for different study designs.
- To reduce heterogeneity.

*** =hint
Remember that meta-regression is a study-level analysis.


*** =sct
```{r}

msg1 <- "Right! Individual-level factors are best examined with individual patient data analysis NOT meta-regression."
msg2 <- "Try again. This would be an example of study-level subgroup analysis, which is one function of meta-regression."
msg3 <- "Nope. Reducing between-study variance is a major goal of meta-regression."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```



--- type:NormalExercise lang:r  xp:150 skills:1
## Conducting a Meta-Regression

Fit a meta-regression model for the risk ratio outcome of the BCG vaccine trials.

*** =instructions
- Use the `rma` function to fit a meta-regression with the `DL` method.
- Use the `ablat` and `year` as moderators. Note that `ablat` is the absolute latitude of the region where the study was performed and the `year` is when the study was performed.
- Save the result as `mreg`.


*** =hint
Remember to add moderators as `mods`.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
mreg <- rma(measure = "RR", ai=tpos,bi=tneg,ci=cpos,
          di = cneg, data = dat.bcg, mods = ~ year + ablat,
          method = "DL")

summary(mreg)
```

*** =sct
```{r}
test_error()
test_object("mreg")
success_msg("Great job! You are really mastering this.")
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Interpreting the Meta-Regression

What is the value of the intercept on the RR scale and what does it represent? (`mreg` is available in the workspace)

*** =instructions
- -1.28; It is the risk ratio of the average study.
- 0.28; It is the risk ratio of the average study.
- 0.28; It is the risk ratio of a study with `ablat` = 0 and `year` = 0.

*** =hint
Remember to exponentiate the intercept. 

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
mreg <- rma(measure = "RR", ai=tpos,bi=tneg,ci=cpos,
          di = cneg, data = dat.bcg, mods = ~ year + ablat,
          method = "DL")

summary(mreg)
```

*** =sct
```{r}

msg1 <- "Try again. Neither the risk ratio or interpretation is correct."
msg2 <- "Nope. The risk ratio is correct but it does not represent the average study."
msg3 <- "Correct. This is the risk ratio on the right scale and reference group."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:NormalExercise lang:r  xp:200 skills:1
## Transforming Covariates in a Meta-Regression

The previous exercise showed that the interpretation of the intercept represents an impossible study. Fit a new version that makes a more meaningful intercept term.

*** =instructions
- Use the `rma` function to fit a meta-regression with the `DL` method.
- Use the `ablat` and `year` as moderators but center them on the value 30 and 2000, respectively. 
- Save the result as `mreg`.


*** =hint
You can add functions to the formula statement.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
mreg <- rma(measure = "RR", ai=tpos,bi=tneg,ci=cpos,
          di = cneg, data = dat.bcg, mods = ~ I(year - 2000) + I(ablat - 30),
          method = "DL")

summary(mreg)
```

*** =sct
```{r}
test_error()
test_object("mreg")
success_msg("That's fantastic! You are getting to expert level.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Evaluating Improvement in Heterogeneity

Look at the significance of the moderator effects and determine whether the inclusion of the effects has improved the heterogeneity level.

*** =instructions
- Assume `mreg` is available.
- Evaluate the results of the omnibus test.
- Fit a model without the moderators.
- Compare the difference in $I^2$ from the null to meta-regression model.
- Store this difference as `i2.diff`.


*** =hint
Check `QM` and `QMp`.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
mreg <- rma(measure = "RR", ai=tpos,bi=tneg,ci=cpos,
          di = cneg, data = dat.bcg, mods = ~ I(year - 2000) + I(ablat - 30),
          method = "DL")
```


*** =solution
```{r}
mreg$QM # Modertator test
mreg$QMp

mreg.null <- rma(measure = "RR", ai=tpos,bi=tneg,ci=cpos,
          di = cneg, data = dat.bcg,
          method = "DL")

i2.diff <- mreg.null$I2 - mreg$I2
i2.diff
```

*** =sct
```{r}
test_error()
test_object("i2.diff")
success_msg("Correct. You have mastered the review of meta-regression!")
```
