---
title       : Meta-Analysis and R
description : Exercises to accompany the Lecture 1.4 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1,3
## Getting Help

Looking up functions for the `meta` package.

*** =instructions
- Use the `help` function to access the index of functions for the package.

*** =hint 
Use `help`.

*** =pre_exercise_code
```{r}
library(meta)
```


*** =solution
```{r}
help(package = "meta)
```

*** =sct
```{r}
test_error()


test_function("help", args = "package",
              not_called_msg = "You should use the help function and package argument.")

success_msg("Good job! Head over to the next exercise")
```