---
title       : Reference Management in R
description : Exercises to accompany Part 2 for `Meta-Analysis with R'


--- type:NormalExercise lang:r  xp:100 skills:1 key:3b49f7b50dc33e885800c57c775a01d4be7a5f74
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



--- type:NormalExercise lang:r  xp:200 skills:1 key:266e97d7e08f6f10cf8392bfa4cd1103e4adab68
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


--- type:NormalExercise lang:r  xp:100 skills:1 key:b29d69eb23522694b2aaae1e0cd74cebc72a4241
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

--- type:NormalExercise lang:r  xp:200 skills:1 key:45a2c54097a8b6d4e34111c3c09b9e422ce3bd1a
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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:99b7e607fdb72718e8dccc8ed1ef854684f5485a

## Identifying Dataset Format

Inspect that dataset `smoking`. Which format is this an example of?

*** =instructions
- Wide format
- Long format

*** =hint
Type `smoking` in the console.

*** =pre_exercise_code
```{r}
library(meta)
data(smoking)
```

*** =sct
```{r}
msg1 <- "Correct! Each row corresponds to one study and there are columns for separate treatment groups."
msg2 <- "Try again. Long format would not have separate variables for each treatment group."
test_mc(correct = 1, feedback_msgs = c(msg1, msg2)) 
```


--- type:NormalExercise lang:r  xp:100 skills:1 key:964f5b71241df483c72f36f5d2be9b46bcecf3dd
## Creating Long Format

Use the `study`, `trt`, and `event` variables in the workshape and put them into a data.frame in long format.

*** =instructions
- Store your data.frame as the object `meta_data`

*** =hint 
Use the `data.frame` function.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
```


*** =solution
```{r}
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)


meta_data
```

*** =sct
```{r}
test_error()
test_object("meta_data")
success_msg("Good job! Head over to the next exercise")
```


--- type:NormalExercise lang:r  xp:100 skills:1 key:7b83fe983c36736a6f1e3ae813975ab0479dccb6
## Creating Wide Format

Convert the long data.frame created in the previous exercise into wide format using the `reshape` function.

*** =instructions
- Store your new data.frame as the object `wide_meta_data`

*** =hint 
Use the `reshape` function.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)
```


*** =solution
```{r}
wide_meta_data <- reshape(meta_data, idvar = "study", timevar = "trt", direction = "wide")
wide_meta_data
```

*** =sct
```{r}
test_error()
test_object("wide_meta_data")
success_msg("Good job! Head over to the next exercise")
```



--- type:NormalExercise lang:r  xp:100 skills:5 key:5ebb83dc172e1e181c19d3fdabf9002178288b65
## Deriving Variables in Wide Format

Create a new variable for the `wide_meta_data` that is the difference in the events between treatment groups.

*** =instructions
- Take the difference from treatment group "a" and "b"
- Call this variable `diff`

*** =hint 
Use the `$` operator.

*** =pre_exercise_code
```{r}
study <- rep(1:3, each = 2)
trt <- rep(c("a", "b"), 3)
event <- c(10, 5, 4, 3, 6, 7)
meta_data <- data.frame(
	study = study,
	trt = trt,
	event = event
)
wide_meta_data <- reshape(meta_data, idvar = "study", timevar = "trt", direction = "wide")
```


*** =solution
```{r}
wide_meta_data$diff <- with(wide_meta_data, event.a - event.b)
wide_meta_data
```

*** =sct
```{r}
test_error()
test_object("wide_meta_data")
success_msg("Good job! Head over to the next exercise")
```


