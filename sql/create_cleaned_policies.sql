CREATE VIEW IF NOT EXISTS cleaned_policies AS
SELECT
	f.IDpol,
	CASE WHEN f.ClaimNb > 11 THEN 11 ELSE f.ClaimNb END AS ClaimNb,
	COALESCE(c.ClaimTotal, 0) AS ClaimTotal,
	COALESCE(c.ClaimTotalCapped, 0) AS ClaimTotalCapped,
	CASE WHEN f.Exposure > 1.0 THEN 1.0 ELSE f.Exposure END AS Exposure,
	f.Area,
	f.VehPower,
	f.VehAge,
	f.DrivAge,
	f.BonusMalus,
	f.VehBrand,
	f.VehGas,
	f.Density,
	f.Region
FROM freq f
LEFT JOIN (
	SELECT
		IDpol,
		SUM(ClaimAmount) AS ClaimTotal,
		SUM(CASE WHEN ClaimAmount > 25000 THEN 25000 ELSE ClaimAmount END) AS ClaimTotalCapped
	FROM sev
	GROUP BY IDpol
) c ON f.IDpol = c.IDpol;
