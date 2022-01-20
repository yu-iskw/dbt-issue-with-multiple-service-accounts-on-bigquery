{% set project_id = env_var('PROJECT_ID') %}

{{
  config(
    materialized="view",
    database=project_id,
    schema="test_dataset1",
    alias="model_in_test_dataset1",
    tags=["test_dataset1"]
  )
}}

SELECT 1
