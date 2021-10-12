
 

Select *
From [dbo].[NashvilleHousing]


--Standardize Date format

Select SaleDateConverted,  convert (date, saledate)
From PortofolioProject.dbo.NashvilleHousing

update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

Alter Table [dbo].[NashvilleHousing]
Add SaledateConverted Date; 
update NashvilleHousing
Set SaleDateconverted = Convert(Date,SaleDate)

-- Populate Property Address

Select * 
From NashvilleHousing
Where PropertyAddress is null
order by ParcelID


Select a.parcelid, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
on a.parcelid = b.parcelid
AND a.[UniqueID] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
join NashvilleHousing b
on a.parcelid = b.parcelid
AND a.[UniqueID] <> b.[UniqueID ]
Where a.PropertyAddress is null

----- Breaking out address into columns

Select PropertyAddress
From [dbo].[NashvilleHousing]

Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',Propertyaddress)-1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',',Propertyaddress)+1, LEN(Propertyaddress)) as Address

From PortofolioProject.dbo.NashvilleHousing

Alter table nashvillehousing
Add PropertyAddress1 NVARCHAR(255);

Update nashvillehousing
Set PropertyAddress1  = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',Propertyaddress)-1)

Alter table nashvillehousing
Add City NVARCHAR(255);

Update nashvillehousing
Set City  = SUBSTRING (PropertyAddress, CHARINDEX(',',Propertyaddress)+1, LEN(Propertyaddress))

Select *
From PortofolioProject.dbo.NashvilleHousing


Select *
From NashvilleHousing

Select
PARSENAME(Replace(owneraddress,',','.'),3),
PARSENAME(Replace(owneraddress,',','.'),2),
PARSENAME(Replace(owneraddress,',','.'),1)
From NashvilleHousing

Alter table nashvillehousing
Add OwnerAddress1 NVARCHAR(255);

Update nashvillehousing
Set OwnerAddress1  = PARSENAME(Replace(owneraddress,',','.'),3)

Alter table nashvillehousing
Add OwnerCity NVARCHAR(255);

Update nashvillehousing
Set OwnerCity  = PARSENAME(Replace(owneraddress,',','.'),2)

Alter table nashvillehousing
Add OwnerState NVARCHAR(255);

Update nashvillehousing
Set OwnerState  = PARSENAME(Replace(owneraddress,',','.'),1)



--- Change Y and N to Yes and No in "Sold as Vacant" Field

Select distinct (SoldasVacant), Count(SoldasVacant) 
From PortofolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
,case when soldasvacant = 'Y' THEN 'Yes'
     when soldasvacant = 'N' THEN 'No'
     Else Soldasvacant
END
From [dbo].[NashvilleHousing]

Update NashvilleHousing
Set SoldAsVacant = case when soldasvacant = 'Y' THEN 'Yes'
     when soldasvacant = 'N' THEN 'No'
     Else Soldasvacant
	 End



--- Remove Duplicates 

With ROWNUMCTE as (
Select * ,
  ROW_NUMBER() over (
  Partition by parcelid,
				Propertyaddress,
				SalePrice,
				legalReference
				Order by 
				UniqueID
				) Row_num

From [dbo].[NashvilleHousing] 
)
Select *
From RowNumCTE
where row_num > 1
--order by propertyaddress 


--- Delete Unused Columns


Select *
From [dbo].[NashvilleHousing]


Alter Table [dbo].[NashvilleHousing]
drop column Owneraddress, taxdistrict, PropertyAddress, saledate

Select *
From PortofolioProject.dbo.NashvilleHousing


