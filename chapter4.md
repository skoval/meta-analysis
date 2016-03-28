---
title       : Meta-Analysis and R
description : Exercises to accompany the Lecture 1.4 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1
## Getting Help

Looking up the function `funnel` to see how to access documentation for the `meta` package.

*** =instructions
- Use the `help` function.

*** =hint 
Use `help`.

*** =pre_exercise_code

```{r}
library(meta)
```


*** =solution
```{r}
# library(meta) is pre-loaded
help("funnel") # ?funnel is also okay
```

*** =sct
```{r}
test_error()


test_function("help", args = "topic",
              not_called_msg = "You should use the help function.")

success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Function Arguments

How would you determine the arguments for the function `funnel`?

*** =instructions
- Use a function that can display a function's arguments to the console.

*** =hint 
Use `args`.

*** =pre_exercise_code

```{r}
library(meta)
```


*** =solution
```{r}
# library(meta) is pre-loaded
args(funnel)
```

*** =sct
```{r}
test_error()


test_function("args", args = "name",
              not_called_msg = "You should use the args function.")

success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:100 skills:5
## Manipulating Data


Determine the number of studies available in the example dataset `catheter` from the `rmeta` package.

*** =instructions
- Load `catheter`.
- Inspect the dataset.
- Count the number of rows.

*** =hint 
Use `nrow`.

*** =pre_exercise_code

```{r}
library(rmeta)
```


*** =solution
```{r}
# library(rmeta) is pre-loaded
data(catheter)

catheter # display dataset

nrow(catheter) # Each row is one study
```

*** =sct
```{r}
test_error()


test_function("nrow", args = "x",
              not_called_msg = "You should use the nrow function.")

success_msg("Good job! Head over to the next exercise")
```

--- type:NormalExercise lang:r  xp:100 skills:5
## Inspecting Data

Determine the type of outcome examined in the `dat.bonett2010` dataset of the `metafor` package.

*** =instructions
- Load the data
- Inspect the data.frame
- Create `outcome` to store the value `binary` or `continuous` for your answer to the type of outcome used.

*** =hint 
Use `data`.

*** =pre_exercise_code

```{r}
library(metafor)
```


*** =solution
```{r}
# library(metafor) is pre-loaded

data(dat.bonett2010)

str(dat.bonett2010)

outcome <- "continuous"

```

*** =sct
```{r}
test_error()

test_object("outcome")

success_msg("Good job! Head over to the next exercise")
```

