// ==========================================
// Power Query Transformations
// Table: Transactions
// Author: Brice Abogo
// ==========================================

let
    // Define file path (Update with your actual file path)
    Source = Excel.Workbook(File.Contents("C:\Path\To\Your\CoffeeShopData.xlsx"), null, true),
    
    // Select the specific sheet
    Transactions_Sheet = Source{[Item="Transactions",Kind="Sheet"]}[Data],
    
    // Promote first row to headers
    PromotedHeaders = Table.PromoteHeaders(Transactions_Sheet, [PromoteAllScalars=true]),
    
    // Define explicit data types for performance and accuracy
    ChangedType = Table.TransformColumnTypes(PromotedHeaders,{
        {"transaction_id", Int64.Type}, 
        {"transaction_date", type date}, 
        {"transaction_time", type time}, 
        {"transaction_qty", Int64.Type}, 
        {"store_id", Int64.Type}, 
        {"store_location", type text}, 
        {"product_id", Int64.Type}, 
        {"unit_price", type number}, 
        {"product_category", type text}, 
        {"product_type", type text}, 
        {"product_detail", type text}
    }),
    
    // Add calculated column for Total Sales
    AddedSalesColumn = Table.AddColumn(ChangedType, "Sales", each [unit_price] * [transaction_qty], type number),
    
    // Add calculated column for Hour of Day (for Day/Hour matrix)
    AddedHourColumn = Table.AddColumn(AddedSalesColumn, "Hour", each Time.Hour([transaction_time]), Int64.Type)
in
    AddedHourColumn
