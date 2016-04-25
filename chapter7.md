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



--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Types of Missing Data

What is the difference between partial and completely missing data in a meta-analysis?

*** =instructions
- Partially missing data is data reported for some subjects; completely missing is reported for none.
- Partially missing data is data reported for some studies and completely missing is reported for none.
- Partially missing data is when different variables are reproted for some studies and completely missing is when no studies have the same outcome measure.


*** =hint
Partially missing is participant-level missingness.

*** =sct
```{r}

msg1 <- "Correct. Parital missingness is incomplete across some subjects in a study and completely missing is when no subjects in a study have data or it is not reported."
msg2 <- "Try again. This is study-level missingness only."
msg3 <- "No. These definitions don't involve concern a single variable and not the combination of variables."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```



--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Sensitivity for Missing Data

What is the purpose of a sensitivity analysis for missing data?

*** =instructions
- To see if missing data is present.
- To see if bias due to missing data is present.
- To see if studies with missing data differ from those with complete data.

*** =hint
Sensitivity analyses are intended to assess potential biases.

*** =sct
```{r}

msg1 <- "Try again. This should be known and not something that needs analysis."
msg2 <- "Right! The purpose of the sensitivity analysis is to assess the presence of potential missing-data bias."
msg3 <- "No. This is a specific type of missing data comparison but not the general purpose of a sensitivity analysis."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:NormalExercise lang:r  xp:200 skills:1
## Conducting a Sensitivity Analysis

Conduct an assessment of the possible bias due to missing data. This exercise will make use of the Ishak 2007 study which includes 24 studies of deep brain stimulation and its effectiveness on the motor skills of Parkinson's patients.

*** =instructions
- Assume `dat.ishak2007` is available.
- The proportion of missing in each study is given in the variable `missing`.
- Test the effect of `missing` on the `DL` estimator of the treatment effect using reported mean difference scores `y1i` with variance `v1i`.
- Save the p-value of the test as `pval`.


*** =hint
Use meta-regression.

*** =pre_exercise_code
```{r}
set.seed(11988)
library(metafor)

dat.ishak2007 <- structure(list(study = c("Alegret (2001)", "Barichella (2003)", 
"Berney (2002)", "Burchiel (1999)", "Chen (2003)", "DBS for PD Study Grp. (2001)", 
"Dujardin (2001)", "Esselink (2004)", "Funkiewiez (2003)", "Herzog (2003)", 
"Iansek (2002)", "Just (2002)", "Kleiner-Fisman (1999)", "Krack (2003)", 
"Krause (2001)", "Krause (2004)", "Kumar (1998)", "Lagrange (2002)", 
"Limousin (1998)", "Linazasoro (2003)", "Lopiano (2001)", "Macia (2004)", 
"Martinez-Martin (2002)", "Molinuevo (2000)", "Moro (1999)", 
"Ostergaard (2002)", "Pahwa (2003)", "Patel (2003)", "Perozzo (2001)", 
"Pinter (1999) - Long FU", "Pinter (1999) - Short FU", "Rodriguez-Oroz (2000)", 
"Romito (2003)", "Rousseaux (2004)", "Russman (2004) (21m)", 
"Schneider (2003)", "Seif (2004) (17.5m)", "Simuni (2002)", "Straits-Troster (2000)", 
"Thobois (2002)", "Troster (2003)", "Valldeoriola (2002)", "Vesper (2002)", 
"Vingerhoets (2002)", "Volkman (2001)", "Weselburger (2002)"), 
    y1i = c(-33.4, -20, -21.1, -20, NA, -25.6, -30.3, NA, NA, 
    NA, NA, -26, NA, NA, -27.5, NA, NA, NA, -31, NA, -33.9, NA, 
    NA, NA, -23, -31.2, -16.2, NA, NA, -32.2, -31.7, -29.3, -30.1, 
    -17.6, NA, NA, NA, -19.4, -9.3, NA, -16.7, NA, -27, -19.7, 
    NA, -22.1), v1i = c(14.3, 7.3, 7.3, 8, NA, 4.2, 88.2, NA, 
    NA, NA, NA, 22.4, NA, NA, 3.8, NA, NA, NA, 2.6, NA, 20.1, 
    NA, NA, NA, 38.1, 12.7, 5.9, NA, NA, 26.5, 19.1, 22.9, 9.4, 
    28.4, NA, NA, NA, 1.6, 85.2, NA, 9.8, NA, 5.5, 18.5, NA, 
    40.8), y2i = c(NA, NA, NA, -20, -32.9, -28.3, NA, -25, NA, 
    -22.5, -8.6, -30, NA, NA, -23.5, NA, -36.3, NA, -34, NA, 
    NA, NA, -34.9, -32.7, -24.1, NA, NA, NA, -31.7, NA, NA, -32, 
    -30.5, NA, NA, NA, NA, -18, NA, -24.7, NA, -31.2, -30, -22.1, 
    -37.8, NA), v2i = c(NA, NA, NA, 8, 125, 4.6, NA, 17, NA, 
    6.8, 41, 20.6, NA, NA, 3.8, NA, 27.3, NA, 2, NA, NA, NA, 
    18, 16.3, 32.9, NA, NA, NA, 12.4, NA, NA, 20, 8.7, NA, NA, 
    NA, NA, 1.7, NA, 15.5, NA, 196, 3.5, 18.1, 20.9, NA), y3i = c(NA, 
    -30, NA, -18, NA, NA, -24.5, NA, -36, -25.2, NA, NA, -25.5, 
    -36.7, -29, -25, NA, -29.4, -32.5, -20.6, NA, -35.4, NA, 
    NA, -27.8, -33, -16.3, -29.2, NA, -32.9, NA, -36.7, -29.7, 
    NA, NA, -36, NA, -20.5, NA, -27.9, NA, NA, NA, -24.3, -34, 
    NA), v3i = c(NA, 5.7, NA, 5, NA, NA, 170.7, NA, 5, 11, NA, 
    NA, 8.2, 5.8, 3.8, 13, NA, 10.7, 2, 25.3, NA, 21.2, NA, NA, 
    31, 9.5, 7, 5.8, NA, 29, NA, 17.8, 10.4, NA, NA, 27.7, NA, 
    1.5, NA, 17.1, NA, NA, NA, 18.2, 26.4, NA), y4i = c(NA, NA, 
    NA, NA, NA, NA, NA, NA, NA, -25.7, NA, NA, -19.5, -32.9, 
    NA, -23, NA, NA, NA, NA, NA, NA, NA, NA, -28.3, NA, -11.5, 
    NA, NA, NA, NA, NA, -31.9, NA, -22.9, NA, -22.5, NA, NA, 
    NA, NA, -27.4, NA, -21.9, NA, NA), v4i = c(NA, NA, NA, NA, 
    NA, NA, NA, NA, NA, 15.4, NA, NA, 13, 6.1, NA, 15.4, NA, 
    NA, NA, NA, NA, NA, NA, NA, 34.6, NA, 12.7, NA, NA, NA, NA, 
    NA, 13.3, NA, 20, NA, 20.3, NA, NA, NA, NA, 201.6, NA, 16.7, 
    NA, NA), mdur = c(16.1, 13.5, 13.6, 13.6, 12.1, 14.4, 13.1, 
    12, 14, 15, 13, 14, 13.4, 14.6, 13.7, 14.4, 14.3, 14, 14, 
    13.7, 15.4, 15, 16.4, 15.8, 15.4, 15, 12.1, 10, 15.4, 11.3, 
    11.5, 16.5, 13.8, 12, 15.9, 17, 15, 16.7, 8, 13.5, 9.5, 15.6, 
    14, 16, 13.1, 14), mbase = c(53.6, 45.3, 45.6, 48, 65.7, 
    54, 65, 51.5, 56, 44.9, 27.6, 44, 50.1, 55.7, 59, 60, 55.7, 
    53.7, 57, 47.7, 59.8, 55.2, 55.7, 49.6, 67.6, 51.3, 41.3, 
    47.8, 59.7, 60, 59.7, 51.5, 63.9, 52.3, 47.1, 51.3, 44.2, 
    43.5, 47.4, 44.9, 41.6, 49, 53, 48.8, 56.4, 50.3)), .Names = c("study", 
"y1i", "v1i", "y2i", "v2i", "y3i", "v3i", "y4i", "v4i", "mdur", 
"mbase"), class = "data.frame", row.names = c(NA, -46L))
dat.ishak2007 <- dat.ishak2007[!is.na(dat.ishak2007$y1i),]
dat.ishak2007 <- dat.ishak2007[,c("study","y1i","v1i")]
dat.ishak2007$n <- ceiling(dat.ishak2007$v1i * 10)
dat.ishak2007$missing <- runif(nrow(dat.ishak2007), 0, 0.3)
```


*** =solution
```{r}
mreg <- rma(yi = y1i, vi = v1i, method = "DL",
	data = dat.ishak2007, mods = ~ missing)

pval <- mreg$pval[2] # Missing covariate
summary(mreg)
```

*** =sct
```{r}
test_error()
test_object("pval")
success_msg("Fantastic. You just performed a sensitivity test for partially missing data!")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Imputing Missing Variance

In the following, some studies of the `data.ishak2007` control group are missing. Given the variance of the control groups `s2` and the control group sample size `n` perform a single imputation for each missing variance.

*** =instructions
- Assume `dat.ishak2007` is available in the workspace.
- Assume that the sum of the numerators of the observed variances have a chi-squared distribution.
- Use `rchisq` with the appropriate degrees of freedom. 


*** =hint
The degrees of freedom are the sum of each control group sample size with a known variance minus the studies with a known variance.

*** =pre_exercise_code
```{r}
library(metafor)
dat.ishak2007 <- structure(list(study = c("Alegret (2001)", "Barichella (2003)", 
"Berney (2002)", "Burchiel (1999)", "Chen (2003)", "DBS for PD Study Grp. (2001)", 
"Dujardin (2001)", "Esselink (2004)", "Funkiewiez (2003)", "Herzog (2003)", 
"Iansek (2002)", "Just (2002)", "Kleiner-Fisman (1999)", "Krack (2003)", 
"Krause (2001)", "Krause (2004)", "Kumar (1998)", "Lagrange (2002)", 
"Limousin (1998)", "Linazasoro (2003)", "Lopiano (2001)", "Macia (2004)", 
"Martinez-Martin (2002)", "Molinuevo (2000)", "Moro (1999)", 
"Ostergaard (2002)", "Pahwa (2003)", "Patel (2003)", "Perozzo (2001)", 
"Pinter (1999) - Long FU", "Pinter (1999) - Short FU", "Rodriguez-Oroz (2000)", 
"Romito (2003)", "Rousseaux (2004)", "Russman (2004) (21m)", 
"Schneider (2003)", "Seif (2004) (17.5m)", "Simuni (2002)", "Straits-Troster (2000)", 
"Thobois (2002)", "Troster (2003)", "Valldeoriola (2002)", "Vesper (2002)", 
"Vingerhoets (2002)", "Volkman (2001)", "Weselburger (2002)"), 
    y1i = c(-33.4, -20, -21.1, -20, NA, -25.6, -30.3, NA, NA, 
    NA, NA, -26, NA, NA, -27.5, NA, NA, NA, -31, NA, -33.9, NA, 
    NA, NA, -23, -31.2, -16.2, NA, NA, -32.2, -31.7, -29.3, -30.1, 
    -17.6, NA, NA, NA, -19.4, -9.3, NA, -16.7, NA, -27, -19.7, 
    NA, -22.1), v1i = c(14.3, 7.3, 7.3, 8, NA, 4.2, 88.2, NA, 
    NA, NA, NA, 22.4, NA, NA, 3.8, NA, NA, NA, 2.6, NA, 20.1, 
    NA, NA, NA, 38.1, 12.7, 5.9, NA, NA, 26.5, 19.1, 22.9, 9.4, 
    28.4, NA, NA, NA, 1.6, 85.2, NA, 9.8, NA, 5.5, 18.5, NA, 
    40.8), y2i = c(NA, NA, NA, -20, -32.9, -28.3, NA, -25, NA, 
    -22.5, -8.6, -30, NA, NA, -23.5, NA, -36.3, NA, -34, NA, 
    NA, NA, -34.9, -32.7, -24.1, NA, NA, NA, -31.7, NA, NA, -32, 
    -30.5, NA, NA, NA, NA, -18, NA, -24.7, NA, -31.2, -30, -22.1, 
    -37.8, NA), v2i = c(NA, NA, NA, 8, 125, 4.6, NA, 17, NA, 
    6.8, 41, 20.6, NA, NA, 3.8, NA, 27.3, NA, 2, NA, NA, NA, 
    18, 16.3, 32.9, NA, NA, NA, 12.4, NA, NA, 20, 8.7, NA, NA, 
    NA, NA, 1.7, NA, 15.5, NA, 196, 3.5, 18.1, 20.9, NA), y3i = c(NA, 
    -30, NA, -18, NA, NA, -24.5, NA, -36, -25.2, NA, NA, -25.5, 
    -36.7, -29, -25, NA, -29.4, -32.5, -20.6, NA, -35.4, NA, 
    NA, -27.8, -33, -16.3, -29.2, NA, -32.9, NA, -36.7, -29.7, 
    NA, NA, -36, NA, -20.5, NA, -27.9, NA, NA, NA, -24.3, -34, 
    NA), v3i = c(NA, 5.7, NA, 5, NA, NA, 170.7, NA, 5, 11, NA, 
    NA, 8.2, 5.8, 3.8, 13, NA, 10.7, 2, 25.3, NA, 21.2, NA, NA, 
    31, 9.5, 7, 5.8, NA, 29, NA, 17.8, 10.4, NA, NA, 27.7, NA, 
    1.5, NA, 17.1, NA, NA, NA, 18.2, 26.4, NA), y4i = c(NA, NA, 
    NA, NA, NA, NA, NA, NA, NA, -25.7, NA, NA, -19.5, -32.9, 
    NA, -23, NA, NA, NA, NA, NA, NA, NA, NA, -28.3, NA, -11.5, 
    NA, NA, NA, NA, NA, -31.9, NA, -22.9, NA, -22.5, NA, NA, 
    NA, NA, -27.4, NA, -21.9, NA, NA), v4i = c(NA, NA, NA, NA, 
    NA, NA, NA, NA, NA, 15.4, NA, NA, 13, 6.1, NA, 15.4, NA, 
    NA, NA, NA, NA, NA, NA, NA, 34.6, NA, 12.7, NA, NA, NA, NA, 
    NA, 13.3, NA, 20, NA, 20.3, NA, NA, NA, NA, 201.6, NA, 16.7, 
    NA, NA), mdur = c(16.1, 13.5, 13.6, 13.6, 12.1, 14.4, 13.1, 
    12, 14, 15, 13, 14, 13.4, 14.6, 13.7, 14.4, 14.3, 14, 14, 
    13.7, 15.4, 15, 16.4, 15.8, 15.4, 15, 12.1, 10, 15.4, 11.3, 
    11.5, 16.5, 13.8, 12, 15.9, 17, 15, 16.7, 8, 13.5, 9.5, 15.6, 
    14, 16, 13.1, 14), mbase = c(53.6, 45.3, 45.6, 48, 65.7, 
    54, 65, 51.5, 56, 44.9, 27.6, 44, 50.1, 55.7, 59, 60, 55.7, 
    53.7, 57, 47.7, 59.8, 55.2, 55.7, 49.6, 67.6, 51.3, 41.3, 
    47.8, 59.7, 60, 59.7, 51.5, 63.9, 52.3, 47.1, 51.3, 44.2, 
    43.5, 47.4, 44.9, 41.6, 49, 53, 48.8, 56.4, 50.3)), .Names = c("study", 
"y1i", "v1i", "y2i", "v2i", "y3i", "v3i", "y4i", "v4i", "mdur", 
"mbase"), class = "data.frame", row.names = c(NA, -46L))
dat.ishak2007 <- dat.ishak2007[!is.na(dat.ishak2007$y1i),]
dat.ishak2007 <- dat.ishak2007[,c("study","v1i")]
dat.ishak2007$n <- ceiling(dat.ishak2007$v1i * 10)
names(dat.ishak2007)[2] <- "s2"
dat.ishak2007$s2[c(5,9,12)] <- NA
```


*** =solution
```{r}
df <- with(dat.ishak2007, sum((n - 1)[!is.na(s2)]))
s2_obs <- with(dat.ishak2007, sum((n - 1) * s2, na.rm  = TRUE))
X2 <- rchisq(3, df = df)
s2_imp <- (s2_obs / X2) / with(dat.ishak2007, (n-1)[is.na(s2)])
s2_imp
```

*** =sct
```{r}
test_error()
test_function("rchisq", args = "df", not_called_msg = "You should sample from the rchisq function.")
success_msg("Great job. You mastered the missing data exercises!")
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Individual Patient Data Meta-Analysis

What is an IPD meta-analysis?

*** =instructions
- This is a meta-analysis where all enrolled patients are included.
- This is a pooled analysis with all the raw study data.
- A meta-analysis of one patient per study.


*** =hint
The unit of analysis is different from a standard meta-analysis.

*** =sct
```{r}

msg1 <- "Try again. When only aggregate information is available, it is a standard meta-analysis."
msg2 <- "Exactly. This is a pooled study with data from all the study participants."
msg3 <- "No. This is not a description of a meta-analysis."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Benefits of IPD Meta-Analysis

Which is _not_ a potential benefit of IPD meta-analysis?

*** =instructions
- Investigating patient-treatment interactions.
- Harmonizing variable definitions.
- Preventing missing data.


*** =hint
Harmonizing variable definitions is an advantage.

*** =sct
```{r}

msg1 <- "Try again. With patient data, we can investigate how patient factors influence treatment effects."
msg2 <- "No. This is a major advantage of an IPD meta-analysis."
msg3 <- "Correct. An IPD analysis cannot eliminate missing data."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:150 skills:1
## Performing One-Step Meta-Analysis

In this exercise, you will perform a pooled meta-analysis and examine between-study meta-regression.

*** =instructions
- The dataset `normand1999` contained pooled data for 9 studies.
- The outcome is the length of stay among hospital patients.
- The purpose of the meta-analysis is to obtain an overall summary of the typical length of stay.
- Use a Poisson regression and determine the significance of between-study effects.
- Save the model as `fit`.


*** =hint
Use `glm` for the model.

*** =pre_exercise_code
```{r}
set.seed(11115)
library(metafor)
data(dat.normand1999)

los <- unlist(mapply(function(n, m, s){
	rnorm(n, m, s)
}, n = dat.normand1999$n1i, m = dat.normand1999$m1i, s = dat.normand1999$sd1i))

normand1999 <- data.frame(
	study = rep(1:9, dat.normand1999$n1i),
	los = ifelse(los < 0, 1, los)
)
```


*** =solution
```{r}
fit <- glm(los ~ factor(study), data = normand1999,
	family = "poisson")

summary(fit)
anova(fit, test = "Chisq") # Test for between-study differences
```

*** =sct
```{r}
test_error()
test_function("glm", args = "family", not_called_msg = "You should use the family argument of the glm function.")
success_msg("Great job. You have a good understanding of patient-data meta-analysis.")
```




--- type:NormalExercise lang:r  xp:200 skills:1
## Performing Two-Step Meta-Analysis

Using the `normand1999` dataset, obtain the log-rate for each study and fit the DerSimonian-Laird meta-analysis.


*** =instructions
- Use `glm` and the Poisson regression for each log-rate.
- Store the result in `data` and call the outcome `yi` and variance `vi`.
- Fit a DL meta-analysis with the `rma` function.


*** =hint
Use `rma` with `DL` method for the meta-analysis.

*** =pre_exercise_code
```{r}
set.seed(11115)
library(metafor)
data(dat.normand1999)

los <- unlist(mapply(function(n, m, s){
	rnorm(n, m, s)
}, n = dat.normand1999$n1i, m = dat.normand1999$m1i, s = dat.normand1999$sd1i))

normand1999 <- data.frame(
	study = rep(1:9, dat.normand1999$n1i),
	los = ifelse(los < 0, 1, los)
)
```


*** =solution
```{r}
split_data <- split(normand1999, f = factor(normand1999$study))

data <- do.call("rbind", lapply(split_data, function(obj){
	fit <- glm(los ~ 1, data = obj, family = poisson)
	data.frame(
		yi = coef(fit),
		vi = vcov(fit)
	)
}))

fit <- rma(yi = yi, vi = vi, data = data, method = "DL")
summary(fit)
```

*** =sct
```{r}
test_error()
test_object("data")
test_function("rma", args = "method", not_called_msg = "You should use the rma function.")
success_msg("Fantastic! You have mastered IPD meta-analysis.")
```