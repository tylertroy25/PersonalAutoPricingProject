# PremiumProject

## 1.	Summary
In this project, we aim to use publicly available data to train a collection of models. We then used this data to make relativity tables for driver age and region. Finally, we used these tables to calculate the pure premium for a small sample of customers.
## 2.	Objective
The objective of this project is to make a GLM-based personal auto pricing model. This model will contain frequency and severity models to calculate pure premium as well as relativities for certain groups of policyholders. For this project, we will focus primarily on GLMs with no loss reserving and using only a single dataset.
## 3.	Data
For this project, we used the freMTPL2freq/sev dataset that contains ~678,000 policies and ~25,000 claims. To use this data, we first had to clean it. Firstly, we capped the exposure at 1.0 as it is impossible to have more than a year remaining on a year-long policy. We also capped each claim at $25,000 as this improved the accuracy of our models and is a realistic cap in the industry. We then excluded zero-payment claims from our severity model, while we included them in our frequency model. Finally, when inspecting the data, we noticed that area and density variables in our dataset were redundant. We proceeded to use density values in our models as they were more granular than our area variables. To test the accuracy of our models, we used 80% of the full dataset to train our models and reserved the other 20% to test and validate the accuracy of our models. For this step, we made two different programs. 01_data_prep.ipynb cleans the data entirely in Python, whereas 01.1_data_prep_SQL.ipynb cleans the data using SQL. Our SQL notebook runs much faster and produces the same output as the original, so it is recommended to use that one.
## 4.	Frequency Model
For our frequency model, we used a Poisson GLM offset by the exposure for each policy. We tested each variable’s significance in our dataset using a combination of p-values and AIC. After testing each variable, we concluded with the following formula:

No. of Claims ~ Driver Age + Bonus Malus + Density + Region + Vehicle Brand

The driver age, bonus malus, density, and region values were all somewhat expected. For example, it is widely known that young drivers typically have more accidents than more mature drivers. However, the significance of vehicle brands to the number of claims was surprising. To validate our models, we grouped the policies into deciles to test the accuracy of the model at both low and high expected and actual frequencies. Overall, it seems that our frequency model performs well for each decile. 

<img width="581" height="453" alt="image" src="https://github.com/user-attachments/assets/6d724ad4-0cc2-4c04-8786-5886d95d3cd7" />

## 5.	Severity Model
For our severity model, we used a Gamma GLM with no exposure offset. After testing each variable’s significance, we ended with the following formula:

Capped Claim Total ~ Driver Age + Region + Vehicle Brand + Vehicle Power

Originally, we trained the model on uncapped claim totals. In doing so, we found that the vehicle’s gas was a strong indicator of the claim total. However, this significance disappeared when training the model using the capped claim total. Like our frequency model, we grouped the policies into deciles and graphed the expected vs actual severity. We can see that our severity model doesn’t perform nearly as well as our frequency model. This could be due to several reasons that we will go into in the limitations section.

<img width="574" height="439" alt="image" src="https://github.com/user-attachments/assets/1221c199-2519-40ec-877f-09d1fba73c78" />

## 6.	Pure Premium & Rating Cells
To calculate the pure premium for each policy, we used the following formula:

Pure Premium = Predicted Frequency * Predicted Severity

After that, we constructed some rating cells for different age groups and regions. We looked at the credibility of each rating cell. If there were very few data points in a cell, we flagged it for low credibility. We then calculated the relativities of each cell. We found that in the age relativity table, there’s a U-shape, where younger and older drivers had higher relativities while drivers between the ages of 30 and 50 had lower relativities. In our region relativity table, we found that region R94 had the highest relativity, where region R83 had the lowest relativity.

<img width="386" height="116" alt="image" src="https://github.com/user-attachments/assets/e6ccae1f-f560-401c-81da-94255141ae28" />
<img width="377" height="377" alt="image" src="https://github.com/user-attachments/assets/7dc1fe44-f7f5-4d40-b945-54399e672d27" />

## 7.	Sample Output
To calculate the premium for three sample customers, we used the following formula:

Premium = Base Premium * Age Relativity * Region Relativity

Here, the base premium was taken as the average pure premium across every policy in our dataset. For three customers, we found the following data:

|Age|Region|Premium
| --- | --- | --- |
|22|R94|184.41|
|50|R24|92.30|
|70|R83|64.14|

## 8.	Limitations
In this project, there were a few limitations. To start, we had no vehicle value data or injury/litigation indicators. These limitations primarily affect our severity model, as severity is strongly influenced by the vehicle’s value or whether someone was injured. This could explain some of the inaccuracies of our severity model. Additionally, we assumed that age and region are independent in our relativity tables. This could give some inaccuracy to our premium calculations from our relativity tables, as these variables may not be multiplicatively independent. 
## 9.	Appendix
Frequency Data: https://www.kaggle.com/datasets/floser/french-motor-claims-datasets-fremtpl2freq 

Severity Data: https://www.kaggle.com/datasets/floser/fremtpl2sev 
