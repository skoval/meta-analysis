---
title       : Influence and Controversy
description : Exercises to accompany the Lecture 1.2 for `Meta-Analysis with R'



--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Streptokinase and Heart Attack

What was the main point of the meta-analysis Lua and colleagues performed on the historical studies of streptokinase as a treatment for heart attack?


*** =instructions
- Streptokinase reduces heart attack 
- The cumulative evidence showed the benefit of streptokinase years before their was scientific consensus 
- Streptokinase had previously unrecognized harmful side effects


*** =sct
```{r}

msg1 <- "Try again. This was a conclusion of study but was only part of the main purpose."
msg2 <- "Correct! The authors showed that the treatment was not only effective, but consensus about its effectiveness could have come much earlier with a meta-analysis."
msg3 <- "Try again. Adverse effects were not a part of this study"


test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Traditional Versus Cumulative Meta-Analysis

The Lau et al. study is an example of a _cumulative meta-analysis_. What is unique about this type of meta-analysis?

*** =instructions
- The authors include randomized and non-randomized trials
- The analysis includes multiple outcomes
- The analysis is ordered by calendar time and is sequentially updated


*** =sct
```{r}

msg1 <- "No. The type of study design is not a specification of a cumulative meta-analysis."
msg2 <- "Nope. Cumulative meta-analysis summarizes evidence for one outcome type at a time."
msg3 <- "Correct. The defining characteristic of a cumulative meta-analysis is performed sequentially in the sequence the study was published, emulating the updating of evidence as new studies arise."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Impact of Meta-Analysis


What is one example where the use of meta-analysis influenced medical consensus in a positive way?

*** =instructions
- Showing the heart risks of Avandia
- Showing that screening mammography is ineffective
- Showing the harmful effects of climate change

*** =sct
```{r}

msg1 <- "You got it! Dr. Steve Nissen's meta-analysis of safety results for Avandia definitively demonstrated the heart risks associated with the drug." 
msg2 <- "Nope. Meta-analysis has had mixed results concerning mammography."
msg3 <- "Try again. Meta-analysis has not had a particulary integral role in this debate."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```

--- type:MultipleChoiceExercise lang:r xp:50 skills:5
## Limitations of Meta-Analysis

What is one of the criticisms that has made past meta-analyses of breast cancer screening mammography difficult to interpret?

*** =instructions

- It has mixed randomized and non-randomized studies
- It has not included women under age 50 years
- It has failed to report overall survival

*** =sct
```{r}

msg1 <- "You got it! A major concern is the mixing of different study designs with varying quality."
msg2 <- "Nope. The meta-analyses have generally included women under age 50 years."
msg3 <- "Try again. The meta-analysis have considered overall survival in addition to other outcomes."

test_mc(correct = 1, feedback_msgs = c(msg1, msg2, msg3)) 
```