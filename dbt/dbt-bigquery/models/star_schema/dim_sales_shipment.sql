-- dim_sales_shipment
{{
  config(
    materialized='table'
  )
}}

SELECT DISTINCT 
  {{ dbt_utils.generate_surrogate_key([
    '`ship-service-level`', 
    '`ship-city`', 
    '`ship-state`', 
    '`ship-postal-code`', 
    '`ship-country`'
  ]) }} AS shipment_id,
  'ship-service-level' AS service_level,
  'ship-city' AS city,
  'ship-state' AS state,
  'ship-postal-code' AS postal_code,
  'ship-country' AS country
FROM
  {{ source('bronze', 'amazon_sale_report') }}
