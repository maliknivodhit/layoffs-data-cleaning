-- Step 1: Find duplicates
WITH dup AS (
  SELECT *,
    ROW_NUMBER() OVER(
      PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
  FROM staging
)
SELECT * FROM dup WHERE row_num > 1;

-- Step 2: Create staging2
CREATE TABLE staging2 LIKE staging;

-- Step 3: Insert data into staging2 with row_num
INSERT INTO staging2
SELECT *,
  ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
  ) AS row_num
FROM staging;

-- Step 4: Delete duplicates
DELETE FROM staging2 WHERE row_num > 1;

-- Step 5: Standardize dates
UPDATE staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE staging2
MODIFY COLUMN `date` DATE;

-- Step 6: Trim spaces from text fields
UPDATE staging2
SET company = TRIM(company),
    industry = TRIM(industry),
    location = TRIM(location),
    stage = TRIM(stage),
    country = TRIM(country);

-- Step 7: Standardize casing (example: all lower case)
UPDATE staging2
SET industry = LOWER(industry),
    stage = LOWER(stage),
    country = LOWER(country);

-- Step 8: Handle blanks as NULLs
UPDATE staging2
SET industry = NULL WHERE industry = '';
UPDATE staging2
SET stage = NULL WHERE stage = '';
UPDATE staging2
SET location = NULL WHERE location = '';
UPDATE staging2
SET country = NULL WHERE country = '';

-- Step 9: Fill missing industry from other rows of same company
UPDATE staging2 t1
JOIN staging2 t2
  ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

-- Step 10: Drop completely useless rows (if both layoffs columns are NULL)
DELETE FROM staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- Step 11: Convert funds column to numeric (if not already)
ALTER TABLE staging2
MODIFY COLUMN funds_raised_millions DECIMAL(15,2);

-- Step 12: Drop helper column
ALTER TABLE staging2 DROP COLUMN row_num;
