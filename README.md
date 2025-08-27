# 🌍 Layoffs Data Cleaning Project

This project focuses on cleaning and preparing a real-world dataset on **global layoffs** using SQL.  
The dataset contains information about companies, industries, locations, and the number of employees laid off worldwide.

---

## 📌 Objectives
- Remove duplicate records
- Standardize and format dates
- Handle missing/blank values
- Ensure consistency in industry names
- Create a cleaned dataset for further analysis

---

## 🛠️ Tools & Tech
- **MySQL** (used for all queries)
- **SQL Window Functions** (`ROW_NUMBER`)
- **GitHub** for version control

---

## ⚡ Data Cleaning Steps
1. Remove duplicates using `ROW_NUMBER()`
2. Create a staging table to store cleaned data
3. Insert data into staging table and drop duplicates
4. Standardize and format the `date` column
5. Handle missing values (industries, blanks → NULL, fill from other rows)
6. Drop helper columns (like `row_num`)

---

## 📊 Final Dataset
The cleaned dataset is ready for:
- Analysis of layoff trends
- Visualization in Power BI / Tableau
- Further predictive modeling

---

## 🚀 Next Steps
- Add **exploratory analysis SQL scripts**
- Build **dashboards** to visualize global layoffs
