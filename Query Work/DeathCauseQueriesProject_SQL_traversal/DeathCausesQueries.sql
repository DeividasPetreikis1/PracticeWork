/* 
   This is a project looking at using simple sql commands to traverse the datset 
   A look into the different causes of death in different countries.

   Skills used: Select, From, Order by, Where

*/

-- Selects the full table and places in alphabetical order.
Select *
From NewAustraliaProject..Death_causes2
Order by 1,2

-- Countries with Alchohol and drug issues effecting interpersonal violence
Select Country_Terrain, Alcohol_use_disorders,Drug_use_disorders,Interpersonal_violence
From NewAustraliaProject..Death_causes2
Order by 1,2

-- Selects countries that have deaths from terrorisim as 0
Select Country_Terrain,Terrorism_deaths
From NewAustraliaProject..Death_causes2
Where Terrorism_deaths = 0
Order by 1,2

-- Countries with terrosism deaths below 10 or at 0
Select Country_Terrain,Terrorism_deaths
From NewAustraliaProject..Death_causes2
Where Terrorism_deaths = 0 OR Terrorism_deaths < 10
Order by 1,2


