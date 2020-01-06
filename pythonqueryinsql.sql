-- Microsoft Learning course 55247A, Lab 1
-- Use Python and R to import and query database records
-- Create Database and Table Using Python
EXECUTE sp_execute_external_script 
@language = N'Python', 
@script = N'
import pyodbc
conn = pyodbc.connect("Driver={SQL Server};Server=vm55247srv;Database=Master;Trusted_Connection=yes;AutoCommit=True")
conn.autocommit = True
cursor = conn.cursor()
try: cursor.execute("Create Database Database1")
except: pass
try: cursor.execute("USE Database1")
except: pass
try: cursor.execute("IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='goldprices' AND xtype='U') CREATE TABLE goldprices ([Date] Date, [Price] Decimal(18,10))")
except: pass
# Truncate the table if it already exists
try: cursor.execute("Truncate Table database1.dbo.goldprices")
except: pass
conn.close()
'
GO
-- Insert Records Into Table Using Python
Insert Into Database1.dbo.goldprices
EXECUTE sp_execute_external_script 
@language = N'Python', 
@script = N'
import pandas as pd
csv_file = "c:\\labfiles\\lab1\\goldprices.csv"
csvdata = pd.read_csv(csv_file)
csvdata.to_csv("c:\\labfiles\\lab1\\goldprices2.csv")
csvdata.to_csv("c:\\labfiles\\lab1\\goldprices2.tsv", sep = "\t")
OutputDataSet = csvdata
'
GO
-- Query Records in the New Table Usng R
EXECUTE sp_execute_external_script
@language = N'R',
@script = N' 
# Query the goldprices table using R
OutputDataSet = InputDataSet;',
@input_data_1 = N' SELECT *  FROM database1.dbo.goldprices;'
WITH RESULT SETS (([Date] Date, [Price] Decimal(18,10)));
GO



