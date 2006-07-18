module TestCases where

import DB1
import DB1.String_tbl as TString
import DB1.Int_tbl as TInt
import DB1.Integer_tbl as TInteger
import DB1.Double_tbl as TDouble
import DB1.Bool_tbl as TBool
import DB1.Calendartime_tbl as TCalendartime
import DB1.Hdb_t1

import DBTest

import Database.HaskellDB
import Database.HaskellDB.HDBRec ((.=.))
import Database.HaskellDB.Query (attributeName,constantRecord)

import System.Time
import Test.HUnit



tests = allTests hdb_test_db

allTests = 
    dbtests [
             insertAndQueryTests,
             testDeleteEmpty
            ]

insertAndQueryTests = 
    dbtests [
             testField string_tbl string_data_1 TString.f01,
             testField string_tbl string_data_1 TString.f02,
             testField string_tbl string_data_1 TString.f03,
             testField string_tbl string_data_1 TString.f04,

             testField int_tbl int_data_1 TInt.f01,
             testField int_tbl int_data_1 TInt.f02,
             testField int_tbl int_data_1 TInt.f03,
             testField int_tbl int_data_1 TInt.f04,

             testField integer_tbl integer_data_1 TInteger.f01,
             testField integer_tbl integer_data_1 TInteger.f02,
             testField integer_tbl integer_data_1 TInteger.f03,
             testField integer_tbl integer_data_1 TInteger.f04,

             testField double_tbl double_data_1 TDouble.f01,
             testField double_tbl double_data_1 TDouble.f02,
             testField double_tbl double_data_1 TDouble.f03,
             testField double_tbl double_data_1 TDouble.f04,

             testField bool_tbl bool_data_1 TBool.f01,
             testField bool_tbl bool_data_1 TBool.f02,
             testField bool_tbl bool_data_1 TBool.f03,
             testField bool_tbl bool_data_1 TBool.f04,

             testField calendartime_tbl calendartime_data_1 TCalendartime.f01,
             testField calendartime_tbl calendartime_data_1 TCalendartime.f02,
             testField calendartime_tbl calendartime_data_1 TCalendartime.f03,
             testField calendartime_tbl calendartime_data_1 TCalendartime.f04
            ]

testField tbl r f = 
    dbtests [
             testInsertAndQuery tbl r f,
             testDistinct tbl r f
            ]

testInsertAndQuery tbl r f = dbtest name $ \db ->
    do insert db tbl (constantRecord r)
       rs <- query db $ do t <- table tbl
                           project (f << t!f)
       assertEqual "Bad result length" (length rs) 1
       assertEqual "Bad field value" (head rs!f) (r!f)
  where name = "insertAndQuery " ++ attributeName f

testDistinct tbl r f = dbtest name $ \db ->
    do insert db tbl (constantRecord r)
       insert db tbl (constantRecord r)
       rs <- query db $ do t <- table tbl
                           project (f << t!f)
       assertEqual "Bad result length" (length rs) 1
  where name = "distinct " ++ attributeName f

testDeleteEmpty = dbtest "deleteEmpty" $ \db ->
    do mapM_ (insert db hdb_t1) data1
       delete db hdb_t1 (\_ -> constant True)
       rs <- query db $ table hdb_t1
       assertBool "Query after complete delete is non-empty" (null rs)



-- * Test data

string_data_1 =
          TString.f01 .=. Just "foo" #
          TString.f02 .=. "bar" #
          TString.f03 .=. Nothing #
          TString.f04 .=. "baz"

int_data_1 = 
          TInt.f01 .=. Just 42 #
          TInt.f02 .=. 43 #
          TInt.f03 .=. Nothing #
          TInt.f04 .=. (-1234)

integer_data_1 = 
          TInteger.f01 .=. Just 1234567890123456789012345678901234567890 #
          TInteger.f02 .=. 123 #
          TInteger.f03 .=. Nothing #
          TInteger.f04 .=. (-453453)

double_data_1 = 
          TDouble.f01 .=. Just 0.0 #
          TDouble.f02 .=. pi #
          TDouble.f03 .=. Nothing #
          TDouble.f04 .=. (-8.6e15)

bool_data_1 = 
          TBool.f01 .=. Just True #
          TBool.f02 .=. True  #
          TBool.f03 .=. Nothing #
          TBool.f04 .=. False

calendartime_data_1 = 
          TCalendartime.f01 .=. Just epoch #
          TCalendartime.f02 .=. epoch #
          TCalendartime.f03 .=. Nothing #
          TCalendartime.f04 .=. someTime

data1 = [(
          t1f01 <<- Just "foo" #
          t1f02 <<- "bar" #
          t1f03 <<- Nothing #
          t1f04 <<- "baz" #

          t1f05 <<- Just 42 #
          t1f06 <<- 43 #
          t1f07 <<- Nothing #
          t1f08 <<- (-1234) #

          t1f09 <<- Just 324234 #
          t1f10 <<- 123 #
          t1f11 <<- Nothing #
          t1f12 <<- (-453453) #

          t1f13 <<- Just 0.0 #
          t1f14 <<- pi #
          t1f15 <<- Nothing #
          t1f16 <<- (-8.6e15) #

-- Disabled for now, since booleans don't really work anywhere
--          t1f17 <<- Just True #
--          t1f18 <<- True  #
--          t1f19 <<- Nothing #
--          t1f20 <<- False #

          t1f21 <<- Just epoch #
          t1f22 <<- epoch #
          t1f23 <<- Nothing #
          t1f24 <<- someTime
         )]




epoch :: CalendarTime
epoch = CalendarTime {
                      ctYear = 1970,
                      ctMonth = January,
                      ctDay = 1,
                      ctHour = 0,
                      ctMin = 0,
                      ctSec = 0,
                      ctPicosec = 0,
                      ctWDay = Thursday,
                      ctYDay = 1,
                      ctTZName = "UTC",
                      ctTZ = 0,
                      ctIsDST = False
                     }

someTime = CalendarTime {
                         ctYear = 2006, 
                         ctMonth = July, 
                         ctDay = 18, 
                         ctHour = 13, 
                         ctMin = 37, 
                         ctSec = 15, 
                         ctPicosec = 413289000000, 
                         ctWDay = Tuesday, 
                         ctYDay = 198, 
                         ctTZName = "PDT", 
                         ctTZ = -25200, 
                         ctIsDST = True
                        }