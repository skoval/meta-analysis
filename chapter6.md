---
title       : Presenting Results
description : Exercises to accompany Part 6 of `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:2593fa681e5a11e25b2838da971a334c43a466ad

## Reproducibility 

What is a _reproducible_ document in a scientific study?

*** =instructions
- A document that can be copied. 
- A document produced by `knitr`.
- A document that mixes text and code.

*** =hint
It has to do with combining all scientific activities into a single document. 

*** =sct
```{r}

msg1 <- "Try again. This isn't a definition of reproducibility."
msg2 <- "No. `Knitr` is used for reproducible reporting but this isn't a definition of such a document."
msg3 <- "You got it. Reproducible documents allow uses to combine text and code in one document."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r  xp:100 skills:1 key:c16aeb39e660a1d21a7f8d048f4ab091f99d931c
## Creating a Descriptive Table

Create a data.frame with information for the summary table in a report using the `dat.bcg` study.


*** =instructions
- Include the author, year, total treatment group size, total control group size.
- Name the variables author, year, `trt n`, and `control n`.
- Call the data.frame `output`.

*** =hint
Remember to creat the sample size variables.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
output <- data.frame(
	author = dat.bcg$author,
	year = dat.bcg$year,
	`trt n` = dat.bcg$tpos + dat.bcg$tneg,
	`control n` = dat.bcg$cpos + dat.bcg$cneg
)

output
```

*** =sct
```{r}
test_error()
test_object("output")
success_msg("Great job! That's exactly right.")
```


--- type:NormalExercise lang:r  xp:100 skills:1 key:94501452d0c66248f04564c62ad6dd9f3300057a
## Add Effect Sizes

Add the odds ratio effect size to the data.frame.


*** =instructions
- Assume `output` is already available.
- Obtain the odds ratio effect sizes for each study.
- Call this variable `OR`.

*** =hint
Remember that the default `OR` is on the log-scale.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
data(dat.bcg)

output <- data.frame(
	author = dat.bcg$author,
	year = dat.bcg$year,
	`trt n` = dat.bcg$tpos + dat.bcg$tneg,
	`control n` = dat.bcg$cpos + dat.bcg$cneg
)
```


*** =solution
```{r}
obj <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

output$OR <- exp(obj$yi)
```

*** =sct
```{r}
test_error()
test_object("output")
success_msg("Fantastic work!")
```

--- type:NormalExercise lang:r  xp:100 skills:1 key:236ff2234345bbc556a502d210fc7ce241ff2285
## Output to Markdown Format

Create a markdown table of the output.

*** =instructions
- Use the `knitr` function to create a markdown version of the table.
- Assume `output` is already available.

*** =hint
Remember that the default `OR` is on the log-scale.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
library(knitr)

data(dat.bcg)

output <- data.frame(
	author = dat.bcg$author,
	year = dat.bcg$year,
	`trt n` = dat.bcg$tpos + dat.bcg$tneg,
	`control n` = dat.bcg$cpos + dat.bcg$cneg
)
obj <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

output$OR <- exp(obj$yi)
```


*** =solution
```{r}
kable(output, format = "markdown")
```

*** =sct
```{r}
test_error()

test_function("kable", args = "format",
              not_called_msg = "You should use kable with the format argument.")

success_msg("Great! You are really mastering this.")
```

--- type:NormalExercise lang:r  xp:100 skills:1 key:ac39364cc794abf5b1bd6dc047faf065f023663d
## Customizing the Ouput

Modify the output to have only 1 significant digit.

*** =instructions
- Assume `output` is already available.
- Modify the `kable` function so that only one significant digit is used.

*** =hint
Use the `digits` argument.

*** =pre_exercise_code
```{r}
library(rmeta)
library(metafor)
library(knitr)

data(dat.bcg)

output <- data.frame(
	author = dat.bcg$author,
	year = dat.bcg$year,
	`trt n` = dat.bcg$tpos + dat.bcg$tneg,
	`control n` = dat.bcg$cpos + dat.bcg$cneg
)
obj <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, 
	data=dat.bcg)

output$OR <- exp(obj$yi)
```


*** =solution
```{r}
kable(output, format = "markdown", digits = 1)
```

*** =sct
```{r}
test_error()

test_function("kable", args = "digits",
              not_called_msg = "You should use kable with the format argument.")

success_msg("Great! You are really mastering this.")
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:d151fe74a51df95c8f20a73aaf229129c090116c

## Forest Plot

What is a forest plot?

*** =instructions
- A plot of regression trees. 
- A plot of study effect sizes in a meta-analysis.
- A plot of heterogeneity of studies in a meta-analysis.


*** =hint
This is the most common way of summarising the results of a meta-analysis.

*** =sct
```{r}

msg1 <- "Try again. A forest plot doesn't have anything to do with regression trees."
msg2 <- "Right! A forest plot is a summary of each study's finding."
msg3 <- "Nope. The plot can show heterogeneity but that isn't its main purpose."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:NormalExercise lang:r  xp:100 skills:1 key:6499f57f9c37c307eb34ae3a5a3c5cd44fb8e0e5
## Create a Forest Plot

Create a forest plot for the `dat.bcg` trial.

*** =instructions
- Use the log-OR effect size.
- Use the method provided by the `metafor` package.


*** =hint
Use the `forest` method.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
```


*** =solution
```{r}
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
forest(fit)
```

*** =sct
```{r}
test_error()

test_function("forest", not_called_msg = "You should use the forest function.")

success_msg("Great! You are really demonstrating your understanding.")
```

--- type:NormalExercise lang:r  xp:100 skills:1 key:421033ed1df35b4a9f6bf3abac617fd9b7baab9d
## Customize the Forest Plot

Add the study names to your plot.


*** =instructions
- Use the `slab` argument to create the author and year description for each study.
- Repeat the forest plot command.

*** =hint
Use the `slab` argument.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)

```


*** =solution
```{r}
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg,
	slab=paste(author, year, sep=", "))

forest(fit)
```

*** =sct
```{r}
test_error()

test_function("forest", args = "x",
              not_called_msg = "You should use the forest function.")

success_msg("Really excellent work!")
```


--- type:NormalExercise lang:r  xp:100 skills:1 key:8aa0c91ac04cdd496cd6d93f9e261d092548304f
## Transform the Scale

Present the results on the odds ratio scale.


*** =instructions
- Assume the object `fit` is available with the random effects object.
- Use a command in `forest` to change the scale from the log-OR to the OR.

*** =hint
Use the `transf` argument.

*** =pre_exercise_code
```{r}
library(metafor)
data(dat.bcg)
fit <- rma(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg,
	slab=paste(author, year, sep=", "))
```


*** =solution
```{r}
forest(fit, transf = exp)
```

*** =sct
```{r}
test_error()

test_function("forest", args = "transf",
              not_called_msg = "You should use the transformation argument.")

success_msg("That's fantastic. You are doing so well!")
```


--- type:NormalExercise lang:r  xp:200 skills:1 key:485d0a091592bf368b8a18ef18588c124d1441ef
## Forest Plots with the `meta` Package

Create the OR forest plot of the dat.bcg data using the `meta` package.


*** =instructions
- Make sure to specific the package `meta`.
- Use `metabin` to fit the model.
- Use this package's function instead of the method for `metafor`.

*** =hint
Use the `metabin` function.

*** =pre_exercise_code
```{r}
library(meta)
library(metafor)
data(dat.bcg)
```

*** =solution
```{r}
fit <- metabin(tpos, tneg + tpos, cpos, cneg + cpos, data = dat.bcg,
	sm = "OR")
forest(fit)
```

*** =sct
```{r}
test_error()
test_function("forest", not_called_msg = "You should use the forest function.")
success_msg("Great job. You're all done.")
```

