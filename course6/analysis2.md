---
title: "Statistical Inference assignment"
author: "success"
date: "2024-09-01"
output: html_document
---


``` r
library(ggplot2)
library(dplyr)
```

### Overview
In this article we are going to the exploring the **ToothGrowth** data set in R. The goal is to explore the variables in the data set and see if we can draw any reasonable inference about ToothGrowth in guinea pigs.

### The data

``` r
data("ToothGrowth")
data = ToothGrowth
str(data)
```

```
## 'data.frame':	60 obs. of  3 variables:
##  $ len : num  4.2 11.5 7.3 5.8 6.4 10 11.2 11.2 5.2 7 ...
##  $ supp: Factor w/ 2 levels "OJ","VC": 2 2 2 2 2 2 2 2 2 2 ...
##  $ dose: num  0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 ...
```

The dataset consist of 60 observations in 3 columns.
The supp variable represent vitamin supplements given to guinea pigs. The length len represents tooth growth and the dose represents dosage

### Exploratory Data Analysis
We expect len to increase with dose. Figure below is a box plot of len for each of dose.

``` r
data$dose = as.factor(data$dose)

ggplot(data, aes(factor(dose), len)) + 
  geom_boxplot()
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png)

Now if we plot, make of similar box plot of len against supp, we see that average tooth growth when supplement 1 is given is greater than the average tooth growth when supplement 2 is given.


``` r
ggplot(data, aes(factor(supp), len)) + 
  geom_boxplot()
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png)


### Stastical Inference
Of course, this could be due to random chance so I am going to formally test the hypothesis that their averages are the same using a Welch Two Sample t-test at a type one error rate of 0.05


``` r
ojdata <- dplyr::filter(data, supp=='OJ')
vcdata <- dplyr::filter(data, supp=='VC')
test1 <- t.test(ojdata$len, vcdata$len, paired = TRUE)
test1
```

```
## 
## 	Paired t-test
## 
## data:  ojdata$len and vcdata$len
## t = 3.3026, df = 29, p-value = 0.00255
## alternative hypothesis: true mean difference is not equal to 0
## 95 percent confidence interval:
##  1.408659 5.991341
## sample estimates:
## mean difference 
##             3.7
```

In this case, I made the **assumption that the observations in the different groups are paired**. The p-value of the Welch test is 0.0025498. Hence we reject the null hypothesis at a 95% significance. **The average of the group that took the 'OJ' supplement is greater than the mean of the group that took the 'VC' supplement**.

Similarly, we can also run a Welch t-test for the significance of the observed difference in mean. Here we also make the **assumption that observations are paired**.


``` r
group1 <- dplyr::filter(data, dose==0.5)
group2 <- dplyr::filter(data, dose==1)
group3 <- dplyr::filter(data, dose==2)

test2 <- t.test(group1$len, group2$len, paired=TRUE)
test3 <- t.test(group2$len, group3$len, paired=TRUE)

test2$p.value < 0.05
test3$p.value < 0.05
```

```
## [1] TRUE
## [1] TRUE
```

The p-value of both test are below the threshold, hence we **reject** the null hypothesis that the mean are equal and conclude that **dosage increases tooth growth**
