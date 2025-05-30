SELECT 
	footprint.source_transaction_id,
	footprint.dim_footprint_certificateholder_id,
	CAST(
	STUFF(
		STUFF(
		CAST(footprint.dim_reportingdate_id AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS DATE)   AS reporting_date,
	footprint.dim_reporting_certificateholder_id,
	CAST(
	STUFF(
		STUFF(
		CAST(footprint.dim_transactiondate_id AS VARCHAR(8)), 5, 0, '-'), 8, 0, '-') AS DATE) AS transaction_date,
	footprint.dim_subproduct_id,
	footprint.dim_from_certificateholder_id,
	footprint.dim_to_certificateholder_id,
	footprint.certification_year                                                              AS certification_year,
	footprint.scheme_owner,
	footprint.original_scheme_owner,
	footprint.original_volume                                                                 AS original_volume,
	footprint.standard_mt_equivalent_volume                                                   AS equivalent_mt_volume,
	trans.royalty_applied, 
	trans.royalty_calculated,
	trans.royalty_fee_rate,
	trans.royalty_MT_equivalent_volume,
	trans.standard_premium,
	footprint.standard_mt_volume,
	footprint.standard_mt_equivalent_volume,
	footprint.farmch_sale_flag,
	trans_detail.transaction_type,
	trans_detail.transaction_status,
	product.crop,
	product.crop_category,
	product.royalty_method,
	cert_holder.reporting_certificateholder_id                                                AS cert_id_owner,
	cert_holder.reporting_certificateholder_name                                              AS cert_name,
	cert_holder.reporting_certificateholder_country                                           AS certificate_holder_country,
	license.license_volume                                                                    AS license_volume,
	license.carry_over_volume,
	licence_year.license_status,
	licence_year.start_date_license,
	YEAR(licence_year.start_date_license) AS license_year
FROM prd.fact_transactionfootprint AS footprint
LEFT JOIN prd.fact_transaction AS trans ON
  footprint.dim_transactiondetail_id = trans.dim_transactiondetail_id AND
  trans.source_transaction_id = footprint.source_transaction_id
LEFT JOIN prd.dim_transactiondetail AS trans_detail ON
  trans.dim_transactiondetail_id = trans_detail.dim_transactiondetail_id
LEFT JOIN prd.dim_subproduct AS product ON
	footprint.dim_subproduct_id = product.dim_subproduct_id
LEFT JOIN prd.dim_reporting_certificateholder AS cert_holder ON
	footprint.dim_reporting_certificateholder_id = cert_holder.dim_reporting_certificateholder_id
LEFT JOIN prd.dim_license AS licence_year ON  
	footprint.dim_footprint_certificateholder_id = licence_year.dim_certificateholder_id 
LEFT JOIN prd.dim_certificateholder AS cert_owner ON  
	cert_holder.dim_reporting_certificateholder_id = cert_owner.dim_certificateholder_id
LEFT JOIN prd.fact_licensevolume AS license ON  
	cert_owner.dim_certificateholder_id = license.dim_certificateholder_id AND
	license.dim_license_id = licence_year.dim_license_id AND
	footprint.certification_year = YEAR(licence_year.start_date_license)
LEFT JOIN prd.dim_crop AS crop ON
	license.dim_crop_id = crop.dim_crop_id
WHERE
	product.crop = 'Cocoa' AND
	license.dim_certificateholder_id = footprint.dim_footprint_certificateholder_id  --AND
	--footprint.source_transaction_id = '1000618'
ORDER BY 
    footprint.source_transaction_id

