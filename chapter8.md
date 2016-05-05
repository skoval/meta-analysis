---
title       : Advanced Topics 2
description : Exercises to accompany Part 7.3 - 7.5 of `Meta-Analysis with R'

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

In this exercise, you will perform a pooled meta-analysis and examine between-study heterogeneity.

*** =instructions
- The dataset `normand1999` contains pooled data for 9 studies.
- The outcome is the length of stay (in days) among hospital patients.
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
	los = ceiling(ifelse(los < 0, 1, los))
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
	los = ceiling(ifelse(los < 0, 1, los))
)
```


*** =solution
```{r}
split_data <- split(normand1999, f = factor(normand1999$study))

data <- do.call("rbind", lapply(split_data, function(obj){
	fit <- glm(los ~ 1, data = obj, family = poisson)
	data.frame(
		yi = coef(fit),
		vi = vcov(fit)[1,1]
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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

## Rare Events

Examine the dataset `dat.bcg`. Are rare events a concern for this meta-analysis?

*** =instructions
- Yes.
- No.

*** =hint
Rare events are when the events are close or equal to zero for some groups.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =sct
```{r}

msg1 <- "Correct. Some groups have fewer than 5 events, so rare-event effects are a concern."
msg2 <- "Wrong.  There are ver few events for some groups."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2)) 
```

--- type:NormalExercise lang:r  xp:150 skills:1
## Peto Method

Use the `metabin` function and Peto's method to perform a meta-analysis of odds ratios for the `dat.bcg` study. What does the analysis suggest about the effect of the BCG vaccine?


*** =instructions
- Load `meta` package.
- Fit using the `metabin` function.
- Save the `OR` for the fixed effects model as the object `OR`.



*** =hint
Remember to compute the total sample size for each group.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
library(meta)

dat.bcg$tn <- with(dat.bcg, tpos + tneg)
dat.bcg$cn <- with(dat.bcg, cpos + cneg)

fit <- metabin(tpos, tn, cpos, cn, data = dat.bcg,
	method = "Peto", sm = "OR")

summary(fit)

OR <- exp(summary(fit)$fixed$TE)	
```

*** =sct
```{r}
test_error()
test_object("OR")
success_msg("Excellent! That was challenging, and you got it!")
```



--- type:NormalExercise lang:r  xp:150 skills:1
## Mantel-Haenszel Method

Use the `metabin` function and the Mantel-Haenszel method to perform a meta-analysis of odds ratios for the `dat.bcg` study. What do you find in this case?


*** =instructions
- Load `meta` package.
- Fit using the `metabin` function.
- Save the `OR` for the fixed effects model as the object `OR`.



*** =hint
Make sure to prevent a correction factor from being included.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
library(meta)

dat.bcg$tn <- with(dat.bcg, tpos + tneg)
dat.bcg$cn <- with(dat.bcg, cpos + cneg)

fit <- metabin(tpos, tn, cpos, cn, data = dat.bcg,
	method = "MH", sm = "OR", MH.exact = TRUE)

summary(fit)

OR <- exp(summary(fit)$fixed$TE)	
```

*** =sct
```{r}
test_error()
test_object("OR")
success_msg("That's great! You are really mastering this.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Small Study Effects

In this problem, we look at possible small study effects among 48 studies looking at the effectiveness of school-based writing-to-learn interventions on academic achievement.



*** =instructions
- The dataset `dat.bangertdrowns2004` has 46 studies.
- Count the number of studies with fewer than 100 subjects.
- Save the count as `small.n`


*** =hint
The variable `n` has the sample sizes.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bangertdrowns2004)
```


*** =solution
```{r}
head(dat.bangertdrowns2004)
small.n <- sum(dat.bangertdrowns2004$n < 100)
small.n
```

*** =sct
```{r}
test_error()
test_object("small.n")
success_msg("That's right! You are ready for the next problem.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Funnel Plot for Small Study Effects

Using the `dat.bangertdrowns2004` study, plot the data in a way that will help visualize possible small study effects.


*** =instructions
- Use the mean differences in `yi` and variances `vi`
- Fit a DerSimonian-Laird model with `rma`.
- Make a funnel plot
- What does this suggest?

*** =hint
The function `funnel` makes a funnel plot of a fitted `rma` object.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bangertdrowns2004)
```


*** =solution
```{r}
fit <- rma(yi = yi, vi = vi, data = dat.bangertdrowns2004, method = "DL")
funnel(fit)
```

*** =sct
```{r}
test_error()
test_function("funnel", args = "x", not_called_msg = "You should make a funnel plot.")
success_msg("Great job! You are mastering this.")
```


--- type:NormalExercise lang:r  xp:200 skills:1
## Influence Diagnostics

Using the `dat.bangertdrowns2004` study, conduct a leave-one-out sensitivity analysis and find the range of the effect sizes for the mean difference. Does this raise concern about the robustness of the analysis?


*** =instructions
- Use the mean differences in `yi` and variances `vi`
- Fit a DerSimonian-Laird model with `rma`
- Use the `leave1out` method
- Store the range as `effect.range`

*** =hint
The effect sizes are the variable `estimate` in the `leave1out` output.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bangertdrowns2004)
```


*** =solution
```{r}
fit <- rma(yi = yi, vi = vi, data = dat.bangertdrowns2004, method = "DL")
leave_out <- leave1out(fit)
effect.range <- range(leave_out$estimate)
effect.range
```

*** =sct
```{r}
test_error()
test_object("effect.range")
success_msg("Really well done! Excellent job.")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Network Meta-Analysis

The `parkinson` data set contains the mean lost work-time reduction in patients given dopamine agonists as adjunct therapy in Parkinson’s disease. Treatments are placebo, coded 1, and four active drugs coded 2 to 5. 


*** =instructions
- Examine the Parkinson data
- Determine the total pairwise comparisons (direct and indirect) that are possible
- Determine the number that were observed
- Store each answer as `total` and `observed`

*** =hint
Use the function `choose`.

*** =pre_exercise_code
```{r}
library(netmeta)

data(parkinson)

# Transform data from arm-based format to contrast-based format
parkinson <- pairwise(list(Treatment1, Treatment2, Treatment3),
               n=list(n1, n2, n3),
               mean=list(y1, y2, y3),
               sd=list(sd1, sd2, sd3),
               data=parkinson, studlab=Study)
```


*** =solution
```{r}
parkinson
total <- choose(5, 2) # 5 total treatments
observed <- 6
c(total, observed)
```

*** =sct
```{r}
test_error()
test_object("total")
test_object("observed")
success_msg("Great job! You are ready for the next question.")
```

--- type:NormalExercise lang:r  xp:200 skills:1
## Network Graph

Create a network graph with the `parkinson` data set.

*** =instructions
- Fit a fixed effects model on the mean differenes with `netmeta`
- Use this to draw the network graph using the function `netgraph`
- Make treatment 1 (placebo) your reference

*** =hint
Give the `TE` and `seTE` to `netmeta`.

*** =pre_exercise_code
```{r}
library(netmeta)
data(parkinson)

# Transform data from arm-based format to contrast-based format
parkinson <- pairwise(list(Treatment1, Treatment2, Treatment3),
               n=list(n1, n2, n3),
               mean=list(y1, y2, y3),
               sd=list(sd1, sd2, sd3),
               data=parkinson, studlab=Study)
```


*** =solution
```{r}
fit <- netmeta(TE, seTE, treat1, treat2, studlab,
        data = parkinson, sm = "MD", reference = "1")

netgraph(fit)
```

*** =sct
```{r}
test_error()
test_function("netgraph", args = "x", not_called_msg = "You should use netgraph")
success_msg("Fantastic! That was challenging, but you got it!")
```

--- type:NormalExercise lang:r  xp:250 skills:1
## Network Meta-Analysis

Fit a random effects network meta-analysis on the `parkinson` data set.

*** =instructions
- Fit a random effects model on the mean differenes with `netmeta`
- Inspect your findings using the `forest` method.

*** =hint
Make sure to use `comb.random`.

*** =pre_exercise_code
```{r}
library(netmeta)
data(parkinson)

# Transform data from arm-based format to contrast-based format
parkinson <- pairwise(list(Treatment1, Treatment2, Treatment3),
               n=list(n1, n2, n3),
               mean=list(y1, y2, y3),
               sd=list(sd1, sd2, sd3),
               data=parkinson, studlab=Study)
```


*** =solution
```{r}
fit <- netmeta(TE, seTE, treat1, treat2, studlab,
        data = parkinson, sm = "MD", reference = "1",
        comb.random = TRUE)

fit

forest(fit, ref = "1")
```

*** =sct
```{r}
test_error()
test_object("fit")
success_msg("You should be really pleased! You mastered the advanced coursework!")
```

