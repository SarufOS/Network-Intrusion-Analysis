# Network-Intrusion-Analysis

Cyber intrusion analysis using **R** on the **UNSW-NB15 dataset**.  
This project combines **statistical analysis and machine learning models (Logistic Regression and Random Forest)** to investigate behavioural differences between normal and attack network traffic.

---

## Overview

The objective of this project is to analyse network flow characteristics and determine whether selected variables can effectively distinguish **malicious traffic from normal connections**.

The analysis focuses on variables such as:

- `dur` – connection duration  
- `sbytes` – bytes sent from source to destination  
- `dbytes` – bytes sent from destination to source  
- `sttl`, `dttl` – time-to-live (TTL) values  
- `proto` – network protocol  
- `state` – connection state  

Both **statistical methods and machine learning classifiers** are applied to identify meaningful patterns in network intrusion behaviour.

---

## Dataset

The project uses a subset of the **UNSW-NB15 network intrusion dataset**, which contains labelled network flow records representing both **normal traffic and attack scenarios**.

Target variable:

- `label`  
  - `0` = Normal traffic  
  - `1` = Attack traffic

---

## Methods

### 1. Descriptive Analysis
- Distribution analysis (histograms, density plot)
- Summary statistics
- Boxplots

### 2. Correlation Analysis
- Scatter plot
- Spearman correlation
- Correlation heatmap

### 3. Group Difference Analysis
- Welch's Two-Sample t-test
- Wilcoxon Rank-Sum Test

### 4. Predictive Analysis
- Logistic Regression
- Random Forest

---

## Results

- Statistical tests show **significant differences in connection duration and byte transfer behaviour** between attack and normal traffic.
- Logistic Regression achieved approximately **92% classification accuracy**.
- Random Forest achieved approximately **94% classification accuracy** and identified **TTL values, connection duration and byte-flow patterns** as the most important predictors.

These findings suggest that the selected variables provide a **strong basis for detecting malicious network activity**.

---

## Technologies Used

- **R**
- dplyr
- ggplot2
- reshape2
- caret
- caTools
- randomForest
- VIM

---

## Usage

1. Download the dataset
2. Open script.R in **RStudio**
3. Load the dataset (more details in the R script)
4. Run the analysis scripts to reproduce the results and visualisations
