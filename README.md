# SQL Data Cleaning Project – Layoffs Dataset

## Project Overview

This project focuses on cleaning a layoffs dataset using SQL. The goal is to transform raw data into a clean and analysis-ready dataset by removing duplicates, standardizing values, handling missing data, and removing unnecessary columns.

## Dataset

The dataset contains information about company layoffs, including:

* Company Name
* Location
* Industry
* Total Employees Laid Off
* Percentage Laid Off
* Date
* Company Stage
* Country
* Funds Raised (Millions)

## Data Cleaning Process

### 1. Create a Working Copy

A duplicate table was created to preserve the original dataset and perform cleaning operations safely.

### 2. Remove Duplicate Records

* Used `ROW_NUMBER()` with a window function.
* Partitioned records based on all relevant columns.
* Deleted rows where `row_num > 1`.

### 3. Standardize Data

Performed data standardization to ensure consistency:

* Removed leading and trailing spaces from company names.
* Standardized industry names (e.g., all Crypto-related values changed to "Crypto").
* Removed unnecessary punctuation from country names.
* Trimmed whitespace from text fields.

### 4. Convert Date Format

Converted date values stored as text into a proper MySQL date format using:

```sql
STR_TO_DATE(date, '%m/%d/%Y')
```

### 5. Handle Missing Values

* Converted blank industry values to NULL.
* Filled missing industries using existing records from the same company.

### 6. Remove Invalid Records

Deleted records where both:

* `total_laid_off`
* `percentage_laid_off`

were missing, as these rows provided no useful layoff information.

### 7. Remove Temporary Columns

Dropped the `row_num` column after duplicate removal was completed.

## SQL Concepts Used

* Window Functions (`ROW_NUMBER`)
* Common Table Expressions (CTEs)
* JOIN Operations
* Data Standardization
* String Functions (`TRIM`)
* Date Functions (`STR_TO_DATE`)
* NULL Handling
* Data Deletion and Table Alteration

## Final Outcome

The dataset was transformed into a clean, consistent, and analysis-ready format suitable for:

* Exploratory Data Analysis (EDA)
* Trend Analysis
* Layoff Impact Studies
* Business Intelligence Reporting

## Skills Demonstrated

* SQL Data Cleaning
* Data Quality Management
* Data Transformation
* Data Preparation for Analytics
* MySQL Query Writing

---

**Tools Used:** MySQL Workbench, SQL
