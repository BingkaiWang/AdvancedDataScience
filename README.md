# AdvancedDataScience
#### Class project for advanced data science I

This repository stores all codes, data and writeups for the course Advanced Data Science I (Sep. 1 - Oct. 20, 2017) in Bloomberg School of Public Health, Johns Hopkins University. Course website: http://jtleek.com/advdatasci/index.html

***

## Problem and Solution 

Perform an analysis of “data scientist” jobs listed on job boards and on the employment pages of major companies. What are the most common skills that employers look for? What are the most unique skills that employers look for? Where are the types of companies that employ the most data scientists?

We solve this problem in the following steps:

#### 1. Scraped data from Glassdoor.com (`R/data_collecting_glassdoor.R`)

Using R package rvest and google extension "SelectorGadget", 1000 job postings with company name, rating, salary, location (city, state), company size, industry and full text of job description were scraped.

#### 2. Identify skill phrases from job description and data cleaning (`R/data_cleaning.R`)

Developed a new method to identify skills from text of job description. Cleaned raw data.

#### 3. Exploratory analysis and Visualization (`R/data_visualization.R`)

Estimated the top 10 skills for data scientist, top 10 unique skills for data scientist, top industries hiring data scientist and geo-distribution of data scientist jobs.

#### 4. Statistical analysis (`R/statistical_model.R`)

Implemented multi-variate linear regression and multi-way ANOVA to find skills significantly impacting salary and factors (salary, location, industry and company size) influencing employee's satisfaction.

***

## Final Writeup and Code

See `final_report/final_writeup.pdf` for writeup and `final_report/final_code.Rmd` for code.

***

## Contact the Author

Author: Bingkai Wang (bingkai.w@gmail.com)
