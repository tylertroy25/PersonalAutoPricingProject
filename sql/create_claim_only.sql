CREATE VIEW IF NOT EXISTS claim_only AS
SELECT * FROM cleaned_policies
WHERE ClaimTotalCapped > 0;
