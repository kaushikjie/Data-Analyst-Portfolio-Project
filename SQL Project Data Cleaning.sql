/*

Cleaning Data in SQL Queries

*/


Select *
From NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

/* Changing Saledate column datatype from datetime to only date. */

update NashvilleHousing
set saledate = CONVERT(date, saledate)

Select *
From NashvilleHousing

/* If it doesn't Update properly, use the method that is described below. */

alter table NashvilleHousing
alter column saledate date

Select *
From NashvilleHousing



 --------------------------------------------------------------------------------------------------------------------------

/* Populate Property Address data where it is null. 
:
The query which is written below states that if the property address in table 'a' is null than update that coloumn of property address  
with property address of table 'b' , where parcelid of table 'a' is equal to parcelid of table 'b' but uniqueid is different 
of both the tables.
*/

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
on A.parcelid = B.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a 
set a.PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on A.parcelid = B.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

select * 
from NashvilleHousing
where PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

/*Breaking out Property Address into Individual Columns (Address, City) using substring
:
1.) What I am doing in this query is breaking the property address after the comma and updating the table with same but tranformed address
in two columns.
2.) After doing that we need to drop the existing column named as propertyaddress because it is of no use now as we have broken down the 
address into two columns.
*/

select
SUBSTRING(propertyaddress,1, Charindex(',' , propertyaddress) -1) as Property_Address,
SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress)) as Property_City
from NashvilleHousing


alter table NashvilleHousing
add Property_Address Nvarchar(255)

update NashvilleHousing
set Property_Address = SUBSTRING(propertyaddress,1, Charindex(',' , propertyaddress) -1) 

alter table NashvilleHousing
add Property_City Nvarchar(255)

update NashvilleHousing
set Property_City = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress) +1, LEN(propertyaddress))

alter table nashvillehousing
drop column propertyaddress 



/* Breaking out owner address into columns (Address, City, State) with ParseName. 
:
Before this query we encountered the same problem with substring but now let's do it with ParseName.
The thing about ParseName when it comes to breaking things up, it does the breaking from backward.
By breaking out the address into different columns, the data seems more readable.
*/


select 
PARSENAME(replace(owneraddress,',','.'), 3),
PARSENAME(replace(owneraddress,',','.'), 2),
PARSENAME(replace(owneraddress,',','.'), 1)
from nashvillehousing

alter table nashvillehousing
add Owner_Address Nvarchar(255)

update NashvilleHousing
set owner_Address = PARSENAME(replace(owneraddress,',','.'), 3)

alter table nashvillehousing
add Owner_City nvarchar(255)

update NashvilleHousing
set owner_city = PARSENAME(replace(owneraddress,',','.'), 2)

alter table nashvillehousing
add Owner_State Nvarchar(255)

update NashvilleHousing
set owner_state = PARSENAME(replace(owneraddress,',','.'),1)

alter table nashvillehousing
drop column owneraddress

select * 
from NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


/* Change Y and N to Yes and No in "Sold as Vacant" field */

select distinct(soldasvacant), COUNT(soldasvacant)
from NashvilleHousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
	end as Sold_As_Vacant
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
					when soldasvacant = 'N' then 'No'
					else soldasvacant
					end 


-----------------------------------------------------------------------------------------------------------------------------------------------------------

/* Remove Duplicates with partition by */

with Rownumcte as 
(
select *,
	ROW_NUMBER() over(
	PARTITION by parcelid,
				legalreference,
				saledate,
				saleprice,
				property_address
				order by uniqueID
				) row_num
from NashvilleHousing
)

delete 
from Rownumcte
where row_num > 1


-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	



/*Using BULK INSERT */

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Users\nkkau\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning.xlsx'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


/* Using OPENROWSET */

--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO



















