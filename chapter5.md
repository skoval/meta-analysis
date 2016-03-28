---
title       : Reference Management in R
description : Exercises to accompany the Lecture 2 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1
## Importing References

Use the `RefManageR` package to search for PubMed articles on meta-analysis.

*** =instructions
- Use the `ReadPubMed` function to find articles with `meta-analysis` in the title.
- Restrict the dates to 2016.

*** =hint 
Use the `field` argument.

*** =pre_exercise_code

```{r}
library(RefManageR)
```


*** =solution
```{r}
# library(RefManageR) is pre-loaded
refs <- ReadPubMed("meta-analysis", field = "title", database = "PubMed", mindate = 2016)

refs[1:5] # First 5 matches
```

*** =sct
```{r}
test_error()


test_function("ReadPubMed", args = "query",
              not_called_msg = "You should use the ReadPubMed function for your search.")

success_msg("Good job! Head over to the next exercise")
```
