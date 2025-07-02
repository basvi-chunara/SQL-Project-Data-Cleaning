-- Data Cleaning

SELECT 
* FROM layoffs;

-- first thing I've done is creating a staging table. This is the one I've worked on and cleaned the data. There should be a table with the raaw data in case something happens.
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * FROM layoffs_staging;

INSERT layoffs_staging
SELECT * 
FROM layoffs;

-- while cleaning the data I've followed a few steps
-- 1. checking for duplicates and remove if any
-- 2. standardizing data and fixing errors
-- 3. checking for null values or blank values
-- 4. removing any columns and rows that are not necessary

-- 1. Removing Duplicates

-- first checking for duplicates
SELECT *
FROM layoffs_staging;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

SELECT *
FROM (
SELECT company, industry, total_laid_off, `date`,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, `date`) AS row_num
FROM layoffs_staging) duplicates WHERE row_num>1;

-- these are the real duplicates 
SELECT *
FROM (
	SELECT company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions,
		ROW_NUMBER() OVER (
			PARTITION BY company, location, industry, total_laid_off,percentage_laid_off,`date`, stage, country, funds_raised_millions
			) AS row_num
	FROM 
		layoffs_staging
) duplicates
WHERE row_num > 1;

-- these are the ones we want to delete where the row number is > 1 or 2 or greater essentially

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging
WHERE company = 'Casper';


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- Creating a new column and adding those row numbers in. Then deleting where row numbers are over 1 , then deleting that column.

ALTER TABLE layoffs_staging ADD row_num INT;

SELECT *
FROM layoffs_staging;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`, stage,
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

-- deleting rows where row_num is greater than 1
DELETE 
FROM layoffs_staging2
WHERE row_num > 1;



-- 2. Standardizing Data
-- which is finding issues in the data and fixing it
-- note: trim removes the whitespace

SELECT * 
FROM layoffs_staging2;

-- looking at industry, it does have some null and empty rows
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company=TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2;

-- Since Crypto has multiple different varistions, standardizing that now. 
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- There are some places where there;s "United States" and some "United States." with a period at the end. Standarding it below.

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
WHERE country LIKE 'United States%'
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


SELECT *
FROM layoffs_staging2;

-- Fixing the date columns by using str to date, to update the required field
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

-- converting he data type accurately
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. Checking for Null values or Blank values
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null
AND percentage_laid_off is null;

SELECT distinct industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Travel'
WHERE percentage_laid_off IS NULL 
AND company = 'Airbnb';


SELECT *
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT * FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions will make the calculations during the EDA phase a bit easier, hence not changing them


-- 4. removing any columns and rows that are not needed

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL or t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company=t2.company
SET t1.industry = t2.industry
WHERE industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null
AND percentage_laid_off is null;

DELETE
FROM layoffs_staging2
WHERE total_laid_off is null
AND percentage_laid_off is null;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;




