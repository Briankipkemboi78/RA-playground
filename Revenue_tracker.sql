SELECT 
  footprint.source_transaction_id,
  footprint.dim_reportingdate_id,
  CAST(
    STUFF(
	  STUFF(
	    CAST(footprint.dim_reportingdate_id AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS DATE) AS reporting_date,
  footprint.dim_reporting_certificateholder_id,
  footprint.dim_transactiondate_id,
  CAST(
    STUFF(
	  STUFF(
	    CAST(footprint.dim_transactiondate_id AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS DATE) AS transaction_date,
  footprint.dim_subproduct_id,
  footprint.dim_from_certificateholder_id,
  footprint.dim_to_certificateholder_id,
  footprint.dim_footprint_certificateholder_id,
  footprint.certification_year,
  footprint.scheme_owner,
  footprint.original_scheme_owner,
  footprint.original_volume,
  footprint.standard_mt_volume,
  footprint.standard_mt_equivalent_volume,
  footprint.farmch_sale_flag,
  product.crop,
  product.crop_category,
  product.royalty_method,
  cert_holder.reporting_certificateholder_id   AS cert_id_owner,
  cert_holder.reporting_certificateholder_name AS cert_name,
  cert_holder.reporting_certificateholder_country,
  license.license_volume,
  license.carry_over_volume,
  licence_year.start_license_date
FROM prd.fact_transactionfootprint AS footprint
LEFT JOIN prd.dim_subproduct AS product ON
  footprint.dim_subproduct_id = product.dim_subproduct_id
LEFT JOIN prd.dim_reporting_certificateholder AS cert_holder ON
  footprint.dim_reporting_certificateholder_id = cert_holder.dim_reporting_certificateholder_id
LEFT JOIN prd.dim_certificateholder AS cert_owner ON  
  cert_holder.dim_reporting_certificateholder_id = cert_owner.dim_certificateholder_id
LEFT JOIN prd.fact_licensevolume AS license ON  
  cert_owner.dim_certificateholder_id = license.dim_certificateholder_id
LEFT JOIN prd.dim_license AS licence_year ON  
  license.dim_license_id = licence_year.dim_license_id
WHERE
  -- LOWER(footprint.fact_source) = 'mtt'
  footprint.dim_reporting_certificateholder_id = '595CB924704A4E5CF2C4CC78BD9BF7B0' 

SELECT * FROM prd.dim_certificateholder
  WHERE dim_certificateholder_id = '595CB924704A4E5CF2C4CC78BD9BF7B0'

  SELECT * FROM prd.fact_licensevolume
  WHERE  dim_certificateholder_id = '595CB924704A4E5CF2C4CC78BD9BF7B0'

SELECT * FROM prd.dim_crop
WHERE  
  dim_license_id = '5F149CCEC3119C7E636876BA327B6443'