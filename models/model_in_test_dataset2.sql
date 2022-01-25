{% set project_id = env_var('PROJECT_ID') %}

{{
  config(
    materialized="view",
    database=project_id,
    schema="test_dataset2",
    alias="model_in_test_dataset2",
    tags=["test_dataset2"]
  )
}}

SELECT 1 AS x
