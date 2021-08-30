
-- Cleaning Data In SQL Queries

SELECT*
FROM [dbo].[Nashville Housing]






-- Standardize Date Format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [dbo].[Nashville Housing]

UPDATE [dbo].[Nashville Housing]
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE [dbo].[Nashville Housing]
ADD SaleDateConverted Date;

UPDATE [dbo].[Nashville Housing]
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- 1. Populate Property Address Data 

SELECT*
FROM [dbo].[Nashville Housing]
--where PropertyAddress is null
order by ParcelID 

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Nashville Housing] a
JOIN [dbo].[Nashville Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM [dbo].[Nashville Housing] a
JOIN [dbo].[Nashville Housing] b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null






-- 2. Breaking out Address into Individual Colums(Address, City, State)

SELECT PropertyAddress
FROM [dbo].[Nashville Housing]
--where PropertyAddress is null
--order by ParcelID 

SELECT
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM [dbo].[Nashville Housing] 




ALTER TABLE [dbo].[Nashville Housing]
ADD PropertyPlitAddress NVARCHAR(225);

UPDATE [dbo].[Nashville Housing]
SET PropertyPlitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

ALTER TABLE [dbo].[Nashville Housing]
ADD PropertyPlitCity NVARCHAR(225);

UPDATE [dbo].[Nashville Housing]
SET PropertyPlitCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress))

SELECT*
FROM [dbo].[Nashville Housing]


SELECT OwnerAddress
FROM [dbo].[Nashville Housing]

SELECT
PARSENAME(Replace(OwnerAddress,',', '.'),3) 
, PARSENAME(Replace(OwnerAddress,',', '.'),2) 
, PARSENAME(Replace(OwnerAddress,',', '.'),1) 
FROM [dbo].[Nashville Housing]


ALTER TABLE [dbo].[Nashville Housing]
ADD OwnerSplitAddress NVARCHAR(225);

UPDATE [dbo].[Nashville Housing]
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',', '.'),3) 


ALTER TABLE [dbo].[Nashville Housing]
ADD OwnerSplitCity NVARCHAR(225);

UPDATE [dbo].[Nashville Housing]
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',', '.'),2) 


ALTER TABLE [dbo].[Nashville Housing]
ADD OwnerSplitState NVARCHAR(225);

UPDATE [dbo].[Nashville Housing]
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',', '.'),1) 


-- 3. Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM [dbo].[Nashville Housing]
Group by SoldAsVacant
Order by 2


SELECT SoldAsVacant
,CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 
FROM [dbo].[Nashville Housing]


UPDATE [dbo].[Nashville Housing]
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END 



-- 4. Remouve  duplicates
WITH RowNumbCTE AS(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY ParcelID,
             propertyAddress,
			 SaleDate,
			 SalePrice,
			 LegalReference
			 ORDER BY
			   UniqueId
			   ) row_num

FROM [dbo].[Nashville Housing]
--ORDER BY ParcelID
)
select *
FROM RowNumbCTE
where row_num > 1
order by PropertyAddress


SELECT*
FROM [dbo].[Nashville Housing]





-- 5. Delete Unused Colums

SELECT*
FROM [dbo].[Nashville Housing]

alter table [dbo].[Nashville Housing]
drop column ownerAddress, TaxDistrict, PropertyAddress

alter table [dbo].[Nashville Housing]
drop column SaleDate