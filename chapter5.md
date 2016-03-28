---
title       : Reference Management in R
description : Exercises to accompany the Lecture 2 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1
## Importing References

Use the `RISmed` package to search for PubMed articles on meta-analysis. How many articles were found?

*** =instructions
- Use the `EUtilsSummary` function to find the number of articles with `meta-analysis` in the title.
- Restrict the dates to the past 30 days.

*** =hint 
Use the `title` field in the query.

*** =pre_exercise_code

```{r}
library(RISmed)
```


*** =solution
```{r}
# library(RISmed) is pre-loaded
query <- EUtilsSummary("meta-analysis[ti]", reldate = 30)

QueryCount(query)
```

*** =sct
```{r}
test_error()


test_function("QueryCount", args = "query",
              not_called_msg = "You should use the ReadPubMed function for your search.")

success_msg("Good job! Head over to the next exercise")
```
