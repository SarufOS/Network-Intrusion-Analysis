# Network-Intrusion-Analysis

Cyber Intrusion Analysis using R. This project applies statistical analysis and machine learning techniques (Logistic Regression and Random Forest) to investigate network attack behaviour using the UNSW-NB15 dataset.

---

## 📌 Project Overview

This project investigates patterns of malicious and normal network traffic using a subset of the **UNSW-NB15 intrusion detection dataset**. The analysis focuses on identifying behavioural differences between attack and legitimate network flows and evaluating whether selected network-flow attributes can reliably detect cyber intrusions.

The project combines **exploratory data analysis, statistical testing, and machine learning classification** to understand how network characteristics such as connection duration, byte transfer patterns, protocol types, TTL values, and connection states relate to malicious activity.

---

## 📊 Dataset

The dataset used in this project is a subset of the **UNSW-NB15 network intrusion dataset**, containing **175,342 network flow records**.

Each record represents a **bi-directional network connection** generated from simulated attack scenarios and normal network traffic.

### Selected Variables

**Target Variable**

| Variable | Description |
|--------|-------------|
| `label` | Binary indicator of traffic type (0 = Normal, 1 = Attack) |

**Network Flow Behaviour**

| Variable | Description |
|--------|-------------|
| `dur` | Duration of the connection (seconds) |
| `sbytes` | Bytes transferred from source to destination |
| `dbytes` | Bytes transferred from destination to source |

**Protocol and Connection Information**

| Variable | Description |
|--------|-------------|
| `proto` | Network protocol used (e.g., TCP, UDP) |
| `state` | Connection state (e.g., FIN, INT, REQ) |

**TTL / Routing Characteristics**

| Variable | Description |
|--------|-------------|
| `sttl` | Time-to-live value from source to destination |
| `dttl` | Time-to-live value from destination to source |

These variables collectively describe **traffic behaviour, flow directionality, routing characteristics, and protocol states**, which are useful for identifying abnormal or malicious network activity.

---

## 🎯 Project Objective

The main objective of this analysis is to investigate whether **network traffic characteristics can effectively distinguish attack connections from normal traffic**.

Specifically, the study aims to:

- Analyse differences in **connection duration and byte transfers**
- Identify **statistical differences between attack and normal flows**
- Evaluate whether selected variables can **predict attack behaviour**
- Assess the effectiveness of **machine learning models for intrusion detection**

---

## ⚙️ Data Preparation

Several preprocessing steps were performed before analysis:

### Data Cleaning

- Imported dataset using `read.csv()` in R
- Removed irregular characters and formatting inconsistencies
- Converted variables to appropriate data types
- Continuous variables converted to **numeric**
- Categorical variables converted to **factors**

### Handling Missing Values

- Missing numerical values handled using **median imputation**
- Missing categorical values handled using **mode imputation**
- Rows with missing labels were removed

### Feature Engineering

To reduce category imbalance:

- Rare protocol categories were grouped using **factor lumping**
- `proto` reduced from **133 categories → 6**
- `state` reduced from **9 categories → 5**

### Data Validation

Validation checks were performed to ensure:

- No negative values in numeric fields
- TTL values fall within valid ranges
- Label variable only contains **0 (normal) or 1 (attack)**
- Dataset integrity after cleaning

---

## 🔎 Data Analysis

The project performs four main analyses.

---

### Analysis 1 — Descriptive Analysis

Investigates the **distribution of connection duration (`dur`) and source bytes (`sbytes`)** across normal and attack traffic.

Techniques used:

- Summary statistics
- Histograms
- Boxplots
- Density plots

These visualisations reveal differences in behaviour between attack and normal network flows.

---

### Analysis 2 — Relationship Analysis

Examines the **relationship between connection duration and source bytes**.

Methods used:

- Scatter plot analysis
- **Spearman’s correlation coefficient**
- Correlation heatmaps

This analysis evaluates whether the two variables are related and how they behave across network flows.

---

### Analysis 3 — Group Difference Analysis

Tests whether **dur** and **sbytes** significantly differ between attack and normal traffic.

Statistical tests applied:

- **Welch’s Two-Sample t-test**
- **Wilcoxon Rank-Sum Test**

These tests confirm whether the observed differences in duration and byte transfer patterns are statistically significant.

---

### Analysis 4 — Predictive Modelling

Machine learning models are used to determine whether multiple network-flow variables can **predict attack traffic**.

Models implemented:

#### Logistic Regression

A statistical classification model that evaluates how variables influence the probability of a connection being malicious.

Features used:

- dur
- sbytes
- dbytes
- sttl
- dttl
- proto
- state

Model performance is evaluated using:

- Confusion matrix
- Accuracy
- Sensitivity
- Specificity
- Balanced accuracy
- Kappa statistic

---

#### Random Forest

A tree-based ensemble machine learning model that captures **nonlinear interactions between variables**.

The model also provides **variable importance scores**, highlighting which features contribute most to attack detection.

Performance evaluation includes:

- Out-of-bag (OOB) error
- Confusion matrix
- Classification accuracy
- Variable importance analysis

---

## 📈 Key Findings

The analysis reveals several important patterns:

- **Attack traffic differs significantly from normal traffic in connection duration and byte transfer behaviour.**
- Statistical tests confirm strong differences between the two traffic categories.
- TTL values and connection states provide **additional behavioural signals of malicious activity**.
- Machine learning models achieve **high predictive accuracy (~92–94%)**, demonstrating that the selected variables form a strong basis for detecting network attacks.

---

## ⚠️ Limitations

Some limitations of the study include:

- The dataset is **simulated**, which may not fully represent real-world network environments.
- Only a **subset of features** from the full UNSW-NB15 dataset was analysed.
- Model performance may vary when applied to **different network infrastructures or attack types**.

---

## 🚀 Future Improvements

Potential extensions of this project include:

- Using **additional features from the dataset**
- Implementing **deep learning approaches**
- Applying **feature selection techniques**
- Testing models on **real-time network traffic**
- Developing a **real-time intrusion detection system**

---

## 🛠 Technologies Used

- **R**
- dplyr
- ggplot2
- caret
- caTools
- randomForest
- VIM
- reshape2

---

## 📂 Project Structure
Network-Intrusion-Analysis

│

├── README.md # Project overview

├── dataset.zip

│    ├── UNSW-NB15_uncleaned.csv/ # UNSW-NB15 dataset subset

├── script.R/ # R full script

└── documentation.pdf/ # Project documentation

---

## 📚 References

- UNSW-NB15 Network Intrusion Dataset
- Various statistical and machine learning techniques implemented in R for intrusion detection analysis.

---
