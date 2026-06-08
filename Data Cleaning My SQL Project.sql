-- =====================================================
-- DATA CLEANING PROJECT: LAYOFFS DATASET
-- Objectives:
-- 1. Remove duplicate records
-- 2. Standardize inconsistent values
-- 3. Handle null and blank values
-- 4. Remove unnecessary columns
-- =====================================================


-- =====================================================
-- STEP 1: CREATE A WORKING COPY OF THE ORIGINAL TABLE
-- =====================================================

CREATE TABLE layoffs_replica
LIKE layoffs;

INSERT layoffs_replica
SELECT * FROM layoffs;


-- =====================================================
-- STEP 2: IDENTIFY DUPLICATE RECORDS
-- Using ROW_NUMBER() to assign a sequence number
-- to records with identical values
-- =====================================================

SELECT ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_replica;


-- Create a CTE to isolate duplicate records

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_replica
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- =====================================================
-- STEP 3: CREATE NEW TABLE TO STORE DUPLICATE FLAGS
-- =====================================================

CREATE TABLE layoffs_replica1 (
company TEXT,
location TEXT,
industry TEXT,
total_laid_off INT DEFAULT NULL,
percentage_laid_off TEXT,
`date` TEXT,
stage TEXT,
country TEXT,
funds_raised_millions INT DEFAULT NULL,
row_num INT
);


-- Insert data along with duplicate row numbering

INSERT INTO layoffs_replica1
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry,
total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_replica;


-- Review duplicate records

SELECT *
FROM layoffs_replica1
WHERE row_num > 1;


-- Remove duplicate records

DELETE
FROM layoffs_replica1
WHERE row_num > 1;


-- =====================================================
-- STEP 4: STANDARDIZE DATA
-- Fix inconsistencies in text formatting and values
-- =====================================================


-- Remove leading/trailing spaces from company names

UPDATE layoffs_replica1
SET company = TRIM(company);


-- Review unique industry values

SELECT DISTINCT industry
FROM layoffs_replica1
ORDER BY 1;


-- Standardize Crypto-related industry values

UPDATE layoffs_replica1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Remove extra spaces in industry column

UPDATE layoffs_replica1
SET industry = TRIM(industry);


-- Standardize country names by removing trailing periods

UPDATE layoffs_replica1
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


-- =====================================================
-- STEP 5: FORMAT DATE COLUMN
-- Convert text dates into MySQL DATE format
-- =====================================================

UPDATE layoffs_replica1
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


-- =====================================================
-- STEP 6: HANDLE NULL AND BLANK VALUES
-- =====================================================


-- Find records with missing industry values

SELECT *
FROM layoffs_replica1
WHERE industry IS NULL
OR industry = '';


-- Convert blank industries to NULL

UPDATE layoffs_replica1
SET industry = NULL
WHERE industry = '';


-- Populate missing industry values
-- using records from the same company

UPDATE layoffs_replica1 g1
JOIN layoffs_replica1 g2
ON g1.company = g2.company
SET g1.industry = g2.industry
WHERE g1.industry IS NULL
AND g2.industry IS NOT NULL;


-- =====================================================
-- STEP 7: REMOVE IRRELEVANT RECORDS
-- Delete rows where layoff information is missing
-- =====================================================

DELETE
FROM layoffs_replica1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


-- =====================================================
-- STEP 8: REMOVE TEMPORARY COLUMNS
-- row_num was only used for duplicate detection
-- =====================================================

ALTER TABLE layoffs_replica1
DROP COLUMN row_num;


-- =====================================================
-- DATA CLEANING COMPLETED
-- Final dataset is ready for exploratory analysis
-- =====================================================