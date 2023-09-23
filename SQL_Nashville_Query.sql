--Selecting the Data

Select *
From Nashville_Housing_Cleaning..Nashville

-- Changing the Date format

ALTER TABLE Nashville_Housing_Cleaning..Nashville
ADD FormattedSaleDate DATE;

UPDATE Nashville_Housing_Cleaning..Nashville
SET FormattedSaleDate = CONVERT(DATE, SaleDate);

Select SaleDate, FormattedSaleDate
From Nashville_Housing_Cleaning..Nashville


---------------------------------------------------------------------------------------------------------------------------------------------------

--Populating Property Address Data

Select *
From Nashville_Housing_Cleaning..Nashville
--Where PropertyAddress is null
order by ParcelID


---------------------------------------------------------------------------
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) as Saket
From Nashville_Housing_Cleaning..Nashville a
JOIN Nashville_Housing_Cleaning..Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing_Cleaning..Nashville a
JOIN Nashville_Housing_Cleaning..Nashville b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is  null


-- Breaking out Address into Individual Columns (Address, City, State)

-- Splitting PropertyAddress
UPDATE nhc
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress) - CHARINDEX(',', PropertyAddress))
FROM Nashville_Housing_Cleaning..Nashville AS nhc;


-- Splitting OwnerAddress
UPDATE nhc
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM Nashville_Housing_Cleaning..Nashville AS nhc;

-- Show updated data
SELECT * FROM Nashville_Housing_Cleaning..Nashville;




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant) as Count
From Nashville_Housing_Cleaning..Nashville
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Nashville_Housing_Cleaning..Nashville


Update Nashville_Housing_Cleaning..Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END 


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville_Housing_Cleaning..Nashville
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Nashville_Housing_Cleaning..Nashville





---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Nashville_Housing_Cleaning..Nashville


ALTER TABLE Nashville_Housing_Cleaning..Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate













