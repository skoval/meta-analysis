---
title       : Introduction to Meta-Analysis
description : Exercises to accompany the first lecture for `Meta-Analysis with R'

--- type:MultipleChoiceExercise lang:r xp:50 skills:1
## Invention of Meta-Analysis

Which one of the following best describes the situation that prompted the development of meta-analysis? 

*** =instructions
- To prove the harmful effects of Avandia
- To settle a scientific dispute
- To support claims about climate change


*** =sct
```{r}

msg1 <- "Try again. Meta-analysis was involved with the takedown of Avandia but it wasn't the reason for its invention."
msg2 <- "Correct! Gene Glass invented meta-analysis to settle a dispute over the effectiveness of pyshcotherapy."
msg3 <- "Try again. This debate got heated up long after meta-analysis came on the scene."

test_mc(correct = 2, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:MultipleChoiceExercise lang:r xp:50 skills:1
## Meta-Analysis Versus Literature Review

Glass's criticism of Han Eysenck's review points out a number of ways that meta-analysis differs from a literature review. Which of the following is one of those differences?


*** =instructions
- Inclusion of multiple scientific studies
_ Attempts to summarize past evidence on a scientific question
- Includes a statistical summary of findings


*** =sct
```{r}

msg1 <- "Try again. Both literature reviews and meta-analyses include scientific studies."
msg2 <- "Nope. Both review methods summarize evidence. Literature reviews use a qualitative summary and meta-analysis a quantitative summary."
msg3 <- "Correct. Meta-analysis is distinct in its inclusion of a numerical summary of evidence."

test_mc(correct = 3, feedback_msgs = c(msg1, msg2, msg3)) 
```


--- type:NormalExercise lang:r xp:100 skills:1
## Vote Counting

To understand the concerns with vote counting, you will apply the method yourself. 

A dataset with the p-values for 10 studies in a meta-analysis is included in the workspace, and is named `votes`.

*** =instructions
- Type `votes' in the command line to see the p-values.
- Determine how many positive studies there are based on a 0.05 criterion.
- What would vote counting conclude about the tested hypothesis?
- Create the object `positive' and assign it the number of positive studies.


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
test_function("assign", args = "x",
              not_called_msg = "You didn't summarize your findings")

test_object("positive")
test_error()
success_msg("Good work!")
```
---