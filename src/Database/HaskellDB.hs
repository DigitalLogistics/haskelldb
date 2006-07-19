-----------------------------------------------------------
-- |
-- Module      :  HaskellDB
-- Copyright   :  Daan Leijen (c) 1999, daan@cs.uu.nl
--                HWT Group (c) 2003, haskelldb-users@lists.sourceforge.net
-- License     :  BSD-style
-- 
-- Maintainer  :  haskelldb-users@lists.sourceforge.net
-- Stability   :  experimental
-- Portability :  non portable
--
-- HaskellDB is a Haskell library for expressing database queries and
-- operations in a type safe and declarative way. HaskellDB compiles a
-- relational algebra-like syntax into SQL, submits the operations to the
-- database for processing, and returns the results as ordinary Haskell
-- values.
--
-- This is the main module that the user should 
-- import. Beside this module, the user should import a
-- particular database binding (ie. "Database.HaskellDB.HSQL.ODBC") 
-- and database definitions.
--
-- HaskellDB was originally written by Daan Leijen and it's 
-- design is described in the paper Domain Specific Embedded 
-- Compilers, Daan Leijen and Erik Meijer. 2nd USENIX 
-- Conference on Domain-Specific Languages (DSL), Austin, 
-- USA, October 1999 (<http://www.usenix.org/events/dsl99/>).
--
-- This new version of HaskellDB was produced as a student project at
-- Chalmers University of Technology in Gothenburg, Sweden. The aim of the
-- project was to make HaskellDB a practically useful database library.
-- That work is described in 
-- Student Paper: HaskellDB Improved, 
-- Bj�rn Bringert, Anders H�ckersten, Conny Andersson, Martin Andersson, 
-- Mary Bergman, Victor Blomqvist and Torbj�rn Martin. 
-- In Proceedings of the ACM SIGPLAN 2004 Haskell Workshop, Snowbird, Utah, 
-- USA, September 22, 2004.
-- (<http://haskelldb.sourceforge.net/haskelldb.pdf>)
--
-----------------------------------------------------------
module Database.HaskellDB
	( Rel, Attr, Expr, Table, Query, Order

        -- * Records
	, HasField, Record, Select, ( # ), ( << ), (<<-), (!), (!.)
	
        -- * Relational operators
	, restrict, table, project
	, union, intersect, divide, minus

	-- * Query expressions
	, (.==.) , (.<>.), (.<.), (.<=.), (.>.), (.>=.)
	, (.&&.) , (.||.)
	, (.*.) , (./.), (.%.), (.+.), (.-.), (.++.)
	, _not, like, _in, cat, _length
	, isNull, notNull, fromNull
	, constant, constJust
	
	, count, _sum, _max, _min, avg
	, stddev, stddevP, variance, varianceP
	
	, asc, desc, order
	, top --, topPercent

        , _case
	, _default

	-- * Database operations
	, Database				-- abstract
	, query, lazyQuery, strictQuery
	, insert, delete, update, insertQuery
	, tables, describe, transaction

	-- * Showing queries
	, showQ, showOpt, showSql
	) where

import Database.HaskellDB.HDBRec
-- PrimQuery type is imported so that haddock can find it.
import Database.HaskellDB.PrimQuery (PrimQuery,ppPrimQuery)
import Database.HaskellDB.Sql       (toSql)
import Database.HaskellDB.Sql.Print (ppSql)
import Database.HaskellDB.Optimize  (optimize)
import Database.HaskellDB.Query
import Database.HaskellDB.Database
import Text.PrettyPrint.HughesPJ (Doc)

-- | Shows the optimized SQL for the query.
instance Show (Query (Rel r)) where
  showsPrec _ query = shows (showSql query)

-- | Pretty-prints the unoptimized 'PrimQuery'.
showQ :: Query (Rel r) -> Doc
showQ = ppPrimQuery . runQuery

-- | Pretty-prints the optimized 'PrimQuery'.
showOpt :: Query (Rel r) -> Doc
showOpt = ppPrimQuery . optimize . runQuery

-- | Pretty-prints the optimized SQL query.
showSql :: Query (Rel r) -> Doc
showSql = ppSql . toSql . optimize . runQuery 
