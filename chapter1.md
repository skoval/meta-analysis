---
title       : Introduction to Meta-Analysis
description : Exercises to accompany Part 1 for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:c1bfbf3c41e91d8f0d49daba64d12e7b4d98798d
## Invention of Meta-Analysis

Which one of the following best describes the situation that prompted the development of meta-analysis? 

*** =instructions
- To prove the harmful effects of Avandia
- To settle a scientific dispute
- To support claims about climate change

*** =hint
Recall Gene Glass and his interest in psychotherapy.

*** =sct
```{r}

msg1 <- "Try again. Meta-analysis was involved with the takedown of Avandia but it wasn't the reason for its invention."
msg2 <- "Correct! Gene Glass invented meta-analysis to settle a dispute over the effectiveness of pyshcotherapy."
msg3 <- "Try again. This debate got heated up long after meta-analysis came on the scene."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:96f0fb919b5a22b0aed78fb973c5fc8bb18990fb
## Meta-Analysis Versus Literature Review

Glass's criticism of Han Eysenck's review points out a number of ways that meta-analysis differs from a literature review. Which of the following is one of those differences?


*** =instructions
- Inclusion of multiple scientific studies
- Attempts to summarize past evidence on a scientific question
- Includes a statistical summary of findings

*** =hint
Sometimes meta-analysis is called a _quantitative_ review.

*** =sct
```{r}

msg1 <- "Try again. Both literature reviews and meta-analyses include scientific studies."
msg2 <- "Nope. Both review methods summarize evidence. Literature reviews use a qualitative summary and meta-analysis a quantitative summary."
msg3 <- "Correct. Meta-analysis is distinct in its inclusion of a numerical summary of evidence."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r xp:100 skills:3 key:99f5dc3cd37ec9a6b55f72608d8a0ae79735f68a
## Vote Counting

To understand the concerns with vote counting, you will apply the method yourself. 

A dataset with the p-values for 10 studies in a meta-analysis is included in the workspace, and is named `votes`.

*** =instructions
- Type `votes' in the command line to see the p-values.
- Determine how many positive studies there are based on a 0.05 criterion.
- What would vote counting conclude about the tested hypothesis?
- Create the object `positive' and assign it the number of positive studies.

*** =hint
Use `sum` or `table` to count the positive studies.

*** =pre_exercise_code
```{r}
votes <- structure(list(pvalues = c(0.259529271489009, 0.0586773202987388, 
0.236969744972885, 0.0285978539614007, 0.209024939755909, 0.208146497933194, 
0.00168275807518512, 0.168483346374705, 0.214195363945328, 0.192846733960323
)), .Names = "pvalues", row.names = c(NA, -10L), class = "data.frame")
```

*** =sample_code
```{r}
# votes is available in your workspace

# create the object positive to summarize what you found
```

*** =solution
```{r}
# votes is available in your workspace
votes

table(votes$pvalues < 0.05) # Positive studies

positive <- 2 # Only 2 of the 10 were positive studies
```

*** =sct
```{r}
test_object("positive")
test_error()
success_msg("Good work!")
```
--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:55dd6f1af98cfcb9ad270271be6f69e39259b645
## Reasons for Conducting Meta-Analysis

Which one of the following is a reason to conduct a meta-analysis?

*** =instructions

- To obtain a more precise summary of tests of the same hypothesis
- To prove a point
- Because a literature review isn't taken as seriously

*** =hint
Recall that, by combining across multipe studies, meta-analysis is more powerful than a single study.

*** =sct
```{r}

msg1 <- "Correct! A meta-analysis should attempt to combine similar evidence in order to get a more precise estimate for the same effect."
msg2 <- "Think again. This isn't a sufficient condition for performing a meta-analysis."
msg3 <- "Try again. This might be true, but it doesn't mean a meta-analysis is appropriate."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:100 skills:5 key:8cd40690155b45cec47255d7582caa7bf8b5184e
## Identifying a Meta-Analysis (1)

Read the following study's objective and methods and determine whether this study is an example of a meta-analysis?

"OBJECTIVE: To estimate the odds and prevalence of clinically relevant depression in adults with type 1 or type 2 diabetes. METHOD: MEDLINE and PsycINFO databases and published references were used to identify studies that reported the prevalence of depression in diabetes. Prevalence was calculated as an aggregate mean weighted by the combined number of subjects in the included studies."


*** =instructions
- Yes
- No


*** =hint
Recall that meta-analysis is the summary of findings from multiple separate studies.

*** =sct
```{r}

msg1 <- "That's right. Odds ratios were combined from multiple independent studies."
msg2 <- "Try again. Recall the definition of a meta-analysis. Does the study fit that description?"

test_mc(correct = 1, feedback_msgs = c(msg1, msg2)) 
```

--- type:MultipleChoiceExercise lang:r xp:100 skills:5 key:6098538e77f590a73623d36f299754358cb0872b
## Identifying a Meta-Analysis (2)

Read the following study's objective and methods and determine whether this study is an example of a meta-analysis?

"OBJECTIVE: The goals our analyses were to establish the frequency and duration of delayed antifungal treatment and to evaluate the relationship between treatment delay and mortality. METHOD: We conducted a retrospective cohort study of patients with candidemia from 4 medical centers who were prescribed fluconazole. Time to initiation of fluconazole therapy was calculated by subtracting the date on which fluconazole therapy was initiated from the culture date of the first blood sample positive for yeast."


*** =instructions
- Yes
- No

*** =hint
Recall that meta-analysis is the summary of findings from multiple separate studies.

*** =sct
```{r}

msg1 <- "Try again. Recall the definition of a meta-analysis. Does the study fit that description?"
msg2 <- "That's right. Although the study uses multiple sites, it is a retrospective cohort using patient-level outcomes and not a summary of effects from multiple studies."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:06306d067374c2a3d5f0191909736bf94f9560a9
## Streptokinase and Heart Attack

What was the main point of the meta-analysis Lua and colleagues performed on the historical studies of streptokinase as a treatment for heart attack?


*** =instructions
- Streptokinase reduces heart attack 
- The cumulative evidence showed the benefit of streptokinase years before their was scientific consensus 
- Streptokinase had previously unrecognized harmful side effects

*** =hint
This meta-analysis was called a _cumulative_ meta-analysis.


*** =sct
```{r}

msg1 <- "Try again. This was a conclusion of study but was only part of the main purpose."
msg2 <- "Correct! The authors showed that the treatment was not only effective, but consensus about its effectiveness could have come much earlier with a meta-analysis."
msg3 <- "Try again. Adverse effects were not a part of this study"


test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:2b81b58218d2ba5238f444a220c6284ae8bce3b8
## Traditional Versus Cumulative Meta-Analysis

The Lau et al. study is an example of a _cumulative meta-analysis_. What is unique about this type of meta-analysis?

*** =instructions
- The authors include randomized and non-randomized trials
- The analysis includes multiple outcomes
- The analysis is ordered by calendar time and is sequentially updated

*** =hint
The time of year of each study was particularly important.

*** =sct
```{r}

msg1 <- "No. The type of study design is not a specification of a cumulative meta-analysis."
msg2 <- "Nope. Cumulative meta-analysis summarizes evidence for one outcome type at a time."
msg3 <- "Correct. The defining characteristic of a cumulative meta-analysis is performed sequentially in the sequence the study was published, emulating the updating of evidence as new studies arise."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:8e9b571bb0f55dbfe5753a95c5c5970cfa848252
## Impact of Meta-Analysis


What is one example where the use of meta-analysis influenced medical consensus in a positive way?

*** =instructions
- Showing the heart risks of Avandia
- Showing that screening mammography is ineffective
- Showing the harmful effects of climate change

*** =hint
Recall the story of Dr. Steve Nissen and a drug for diabetes.

*** =sct
```{r}

msg1 <- "You got it! Dr. Steve Nissen's meta-analysis of safety results for Avandia definitively demonstrated the heart risks associated with the drug." 
msg2 <- "Nope. Meta-analysis has had mixed results concerning mammography."
msg3 <- "Try again. Meta-analysis has not had a particulary integral role in this debate."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:47a2b8ad3d34d7d27dcd488e8f09b18c01821a3d
## Limitations of Meta-Analysis

What is one of the criticisms that has made past meta-analyses of breast cancer screening mammography difficult to interpret?

*** =instructions

- It has mixed randomized and non-randomized studies
- It has not included women under age 50 years
- It has failed to report overall survival

*** =hint
This criticism concerns the quality of the study design.

*** =sct
```{r}

msg1 <- "You got it! A major concern is the mixing of different study designs with varying quality."
msg2 <- "Nope. The meta-analyses have generally included women under age 50 years."
msg3 <- "Try again. The meta-analysis have considered overall survival in addition to other outcomes."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:c6f73ba4d81fe2da5e1e6d4f5f15a6a25ce5197c
## Definition of a Systematic Review

Which of the following is the most accurate description of a systematic review?

*** =instructions
- A discussion of some papers on the same topic
- The results of a search on Google Scholar
- A reproducible review of literature on a specific scientific question

*** =hint
What makes a systematic review _systematic_?

*** =sct
```{r}

msg1 <- "Try again. This sounds more arbitrary a review approach than is done in a systematic review."
msg3 <- "Yes! The key point of a systematic review is that the steps can be repeated by another researcher."
msg2 <- "Try again. This might be a part of the search process for a review but it is not an adequate definition."


test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:8ee7514396962f8479d727ab5c55a32c7f705506
## Checklists for Systematic Review

A number of resources are available for helping perfom a systematic review. Which of the following is _not_ a checklist discussed?

*** =instructions

- MOOSE
- PRISMA
- REVMAN

*** =hint
Two of the three are acronyms for an existing checklist.

*** =sct
```{r}

msg1 <- "No. MOOSE, or Meta-Analyses and Systematic Reviews of Observational Studies, is a review checklist."
msg2 <- "Nope. PRISMA, or Preferred Reporting Items for Systematic Reviews and Meta-Analyses, is a review checklist."
msg3 <- "Correct. RevMan is a kind of reference software not a checklist."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:113064af4e439c89652a8cfc10855254cf4f931c
## Systematic Review versus Meta-Analysis


Is a systematic review a meta-analysis?

*** =instructions
- Yes, always.
- Not necessarily.

*** =hint
Recall the definition of meta-analysis. Does a systematic review always include this?

*** =sct
```{r}

msg1 <- "Ty again. A systematic review might not always have sufficient or appropriate studies to conduct a meta-analysis."
msg2 <- "Right! A meta-analysis is always a systematic review but a review need not include a meta-analysis."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:c69efefc456704a1af38129b6b23f1f64446261d
## What Meta-Analysis Adds


In what part of a systematic review is a meta-analysis performed?

*** =instructions

- The presentation of results
- The evaluation of risk of bias
- The search strategy

*** =hint
Recall that a meta-analysis is concerned with summarizing the findings.

*** =sct
```{r}

msg1 <- "You got it! A meta-analysis statistically summarizes the findings so it would be part of the presentation of results."
msg2 <- "Nope. Bias evaluation is separate from the summary of results."
msg3 <- "Try again. The search for studies happens before the meta-analysis."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5 key:ca7104d708e3098c797eafab9a471873b84a434e
## When a Meta-Analysis is Appropriate

Which of the following would be a reason you might _not_ perform a meta-analysis as part of a systematic review?

*** =instructions

- You only have randomized controlled studies
- You only have studies reporting odds ratios
- The studies don't report the same outcomes

*** =hint
Consider which situation is the closest to an "apples and oranges" problem.

*** =sct
```{r}

msg3 <- "That's right! If the studies don't use the same outcome, the combined effect wouldn't have a meaningful interpretation."
msg1 <- "Nope. If bias is absent, the similarity of study designs would actually be a strength of the meta-analysis."
msg2 <- "Try again. Similarity of effect types helps to facilitate a meta-analysis."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:NormalExercise lang:r  xp:100 skills:1 key:f5f5b69988226c01cb7dcf28c3fa73c0108f311c
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


--- type:NormalExercise lang:r  xp:100 skills:1 key:0262a285392519ff16d9976fe828800de67515fd
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


--- type:NormalExercise lang:r  xp:100 skills:5 key:3f6f42d264983a298b37a6d801b35b10703d5eba
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

--- type:NormalExercise lang:r  xp:100 skills:5 key:077ed83361f1e18d0f36d33cbbeaa210f3008c9c
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

