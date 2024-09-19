{{ config(
    tags=['normalized', 'xero', 'accounts']
) }}

WITH accounts_raw AS (
    SELECT
        ingestion_time,
        JSON_VALUE(data, '$.AccountID') AS account_id,
        CAST(JSON_VALUE(data, '$.AddToWatchlist') AS BOOL) AS add_to_watchlist,
        JSON_VALUE(data, '$.BankAccountNumber') AS bank_account_number,
        JSON_VALUE(data, '$.BankAccountType') AS bank_account_type,
        JSON_VALUE(data, '$.Class') AS class,
        JSON_VALUE(data, '$.Code') AS code,
        JSON_VALUE(data, '$.CurrencyCode') AS currency_code,
        JSON_VALUE(data, '$.Description') AS description,
        CAST(JSON_VALUE(data, '$.EnablePaymentsToAccount') AS BOOL) AS enable_payments_to_account,
        CAST(JSON_VALUE(data, '$.HasAttachments') AS BOOL) AS has_attachments,
        JSON_VALUE(data, '$.Name') AS name,
        JSON_VALUE(data, '$.ReportingCode') AS reporting_code,
        JSON_VALUE(data, '$.ReportingCodeName') AS reporting_code_name,
        CAST(JSON_VALUE(data, '$.ShowInExpenseClaims') AS BOOL) AS show_in_expense_claims,
        JSON_VALUE(data, '$.Status') AS status,
        JSON_VALUE(data, '$.SystemAccount') AS system_account,
        JSON_VALUE(data, '$.TaxType') AS tax_type,
        JSON_VALUE(data, '$.Type') AS type,
        TIMESTAMP_MILLIS(
            CAST(
                REGEXP_EXTRACT(JSON_VALUE(data, '$.UpdatedDateUTC'), r'/Date\((\d+)\+\d+\)/') AS INT64
            )
        ) AS updated_date_utc
    FROM 
        {{ source('raw', 'xero_accounts') }}
)

SELECT
    ingestion_time,
    account_id,
    add_to_watchlist,
    bank_account_number,
    bank_account_type,
    class,
    code,
    currency_code,
    description,
    enable_payments_to_account,
    has_attachments,
    name,
    reporting_code,
    reporting_code_name,
    show_in_expense_claims,
    status,
    system_account,
    tax_type,
    type,
    updated_date_utc
FROM 
    accounts_raw