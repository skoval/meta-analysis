---
title       : Reference Management in R
description : Exercises to accompany the Lecture 2 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1
## Querying References

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


test_function("QueryCount", args = "object",
              not_called_msg = "You should use the ReadPubMed function for your search.")

success_msg("Good job! Head over to the next exercise")
```



--- type:NormalExercise lang:r  xp:200 skills:1
## Importing References

Import the first 10 records from the search of articles on meta-analysis.

*** =instructions
- Use the `EUtilsGet` function to find the number of articles with `meta-analysis` in the title.
- Restrict the dates to the past 30 days.
- Restrict to the first 10 hits.
- Store your imported results in an object named `fetch`.

*** =hint 
Use the `retmax` field to restrict the count of returned articles.

*** =pre_exercise_code
```{r}
library(RISmed)
```


*** =solution
```{r}
query <- EUtilsSummary("meta-analysis[ti]", reldate = 30, retmax = 10)

fetch <- EUtilsGet(query)
```

*** =sct
```{r}
test_error()


test_function("EUtilsGet", args = "x",
              not_called_msg = "You should use EUtilsGet to import metadata.")

test_object("fetch")

success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:100 skills:1
## Manipulating References

Examine the journals that the articles were published in.

*** =instructions
- Assume that the `fetch` object of the `EUtilsGet` call is already in the workspace.
- Save the titles as the object `journals`.

*** =hint 
Use the `Title` method.

*** =pre_exercise_code
```{r}
library(RISmed)

query <- EUtilsSummary("meta-analysis[ti]", reldate = 30, retmax = 10)

fetch <- EUtilsGet(query)
```

*** =solution
```{r}
journals <- Title(fetch)

journals
```

*** =sct
```{r}
test_error()


test_function("Title", args = "object",
              not_called_msg = "You should use the Title method.")

test_object("journals")

success_msg("Good job! Head over to the next exercise")
```

--- type:NormalExercise lang:r  xp:200 skills:1
## Analyzing Results

Conduct a search of journals with `diabetes` in the abstract and find the subset of matches that are likely to focus on type 2 diabetes.

*** =instructions
- Conduct a query for articles with `diabetes` in the abstract.
- Restrict your search to the first 30 articles.
- Search for studies involving type 2 diabets by looking for abstracts containing `type 2` or `type II` in the text.
- Save the index of matches as the object `type2`.

*** =hint 
Use the `grep` function to search for matching text patterns.

*** =pre_exercise_code
```{r}
library(RISmed)
```


*** =solution
```{r}
query <- EUtilsSummary("diabetes[ab]", retmax = 30)

fetch <- EUtilsGet(query)

abstracts <- AbstractText(fetch)

type2 <- grep("type [2|II]", abstracts)
```

*** =sct
```{r}
test_error()


test_function("AbstractText", args = "object",
              not_called_msg = "You should use the AbstractText method.")

test_object("type2")

success_msg("Good job! Head over to the next exercise")
```

