# SQL Project: Data Cleaning with MySQL

This project showcases how raw real-world data can be cleaned and transformed using SQL. The dataset focuses on global tech layoffs during 2022, and the objective is to make the data analysis-ready by removing inconsistencies, formatting issues, and redundant information using MySQL.

---

## 📄 Dataset Description

📊 **Dataset**: [Layoffs 2022 (Kaggle)](https://www.kaggle.com/datasets/swaptr/layoffs-2022)

This dataset contains information about layoffs at various companies, primarily in the tech sector, during the 2022 economic downturn. It includes the following fields:
- Company
- Industry
- Number of employees laid off
- Percentage laid off
- Location and country
- Date of layoff
- Funding stage

📁 **File Used**: `layoffs.csv`

---

## ✅ Project Objectives

- Remove duplicate records
- Standardize inconsistent formats (e.g., date and text casing)
- Handle missing values (such as null industry or location fields)
- Clean white spaces and uniform capitalization
- Split and transform columns for deeper analysis
- Remove irrelevant or redundant columns

---

## 🛠️ Technologies Used

- **MySQL** – for running and testing SQL queries
- **SQL** – CTEs, `ROW_NUMBER()`, `TRIM()`, `UPPER()`, joins, and more
- **Excel** – for data preview and initial inspection

---

## 🚀 How to Run

1. **Clone the repository**
   ```bash
   git clone https://github.com/basvi-chunara/SQL-Project-Data-Cleaning.git
