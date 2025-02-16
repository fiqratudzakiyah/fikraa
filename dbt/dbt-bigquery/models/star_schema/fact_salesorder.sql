-- fact_sales
{{
  config(
    materialized='table'
  )
}}

SELECT 
  `Order ID` AS order_id, 
  Date AS date,
  Status AS status,
  `Courier Status` AS courier_status,
  {{ dbt_utils.generate_surrogate_key([
    'SKU'
  ]) }} AS product_id,
  {{ dbt_utils.generate_surrogate_key([
    'Fulfilment', 
    '`fulfilled-by`'
  ])}} AS fulfillment_id,
  SUM(qty) AS qty,
  COALESCE(SUM(amount), 0) AS amount,
  {{ dbt_utils.generate_surrogate_key([
    '`Promotion-ids`'
  ]) }} AS promotion_id,
  {{ dbt_utils.generate_surrogate_key([
    '`Sales Channel `' 
  ]) }} AS sales_channel_id,  
  {{ dbt_utils.generate_surrogate_key([
    '`ship-service-level`', 
    '`ship-city`', 
    '`ship-state`', 
    '`ship-postal-code`', 
    '`ship-country`'
  ]) }} AS shipment_id
FROM
    {{ source('bronze', 'amazon_sale_report') }}
GROUP BY ALL  
