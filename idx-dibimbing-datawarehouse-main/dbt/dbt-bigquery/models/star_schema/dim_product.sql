-- dim_product
{{
  config(
    materialized='table'
  )
}}

SELECT DISTINCT 
  {{ dbt_utils.generate_surrogate_key([
	'SKU'
  ]) }} as product_id,
  Style AS style,
  SKU AS sku,
  Category AS category,
  Size AS size,
FROM
    {{ source('bronze', 'amazon_sale_report') }}
