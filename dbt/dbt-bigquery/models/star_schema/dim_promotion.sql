{{
  config(
    materialized='table'
  )
}}

SELECT DISTINCT 
  {{ dbt_utils.generate_surrogate_key([
    '`Promotion-ids`'
  ]) }} as promotion_id,
FROM
    {{ source('bronze', 'amazon_sale_report') }}
