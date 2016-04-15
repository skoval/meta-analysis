---
title       : Presenting Results
description : Exercises to accompany Part 6 of `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5

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


--- type:NormalExercise lang:r  xp:100 skills:1
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


--- type:NormalExercise lang:r  xp:100 skills:1
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

--- type:NormalExercise lang:r  xp:100 skills:1
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

--- type:NormalExercise lang:r  xp:100 skills:1
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

