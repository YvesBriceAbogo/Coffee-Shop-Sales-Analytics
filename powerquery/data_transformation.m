/*
Project: Coffee Shop Sales Analytics
Description: ETL process to import and clean transaction data from Excel.
*/

let
    Source = Excel.Workbook(File.Contents(CoffePath), null, true),
    Transactions_Sheet = Source{[Item="Transactions",Kind="Sheet"]}[Data],
    #"Promoted Headers" = Table.PromoteHeaders(Transactions_Sheet, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{
        {"transaction_id", Int64.Type}, 
        {"transaction_date", type date}, 
        {"transaction_time", type datetime}, 
        {"transaction_qty", Int64.Type}, 
        {"store_id", Int64.Type}, 
        {"store_location", type text}, 
        {"product_id", Int64.Type}, 
        {"unit_price", type number}, 
        {"product_category", type text}, 
        {"product_type", type text}, 
        {"product_detail", type text}
    })
in
    #"Changed Type"
