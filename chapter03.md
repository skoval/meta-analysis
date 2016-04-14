---
title       : Systematic Review and Meta-Analysis
description : Exercises to accompany Lecture 1.3 for `Meta-Analysis with R'


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
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


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
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


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5
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

--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## When a Meta-Analysis is Appropriate

Which of the following would be a reason you might not perform a meta-analysis as part of a systematic review?

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