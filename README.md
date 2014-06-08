Enum values in SQL Server.

Every database developer has to deal with enum values. They often come in a form of system tables. I've found (and worked) at least 4 different ways of dealing with them.

1. Magic numbers
	Pros:
	+ Quite good for query plans 
		Query optimizer can use statistics effectively

	Cons:
	- Completely unreadable
		It's not that bad when there is comment right next to value but when there is only magic value the only choice is to guess or lookup at system table.
	
	- Extremely hard/impossible to maintain
		Adding, modifying or removing the value force to look through whole database and change all the stored procedure, functions, views etc.
	
	- Can easily produce bugs or misunderstandings
		Simply mistype and instead of returning approved (statusID 2) orders query will return backordered (3) ones.
		When someone change the magic value while not bothering to change the comment next developer has to stop and analyze business logic whether the magic value or comment is correct.

2. Variables
	Pros:
	+ Readable
		Single look at variable @Approved gives more information the magic value (2).
	
	+ Reusable (in one scope)
		When there is need to query for approved orders multiple time variable can be reused.

	Cons:
	- Hard to maintain
		Same as with magic numbers. Adding, modifying or removing the value force to look through whole database and change all the stored procedure, functions, views etc.
	
	- Can easily produce bugs
		Similar to the magic number. Simple mistype and variable @Approved end up with wrong value (3 instead of 2).
	
	- Bad for statistics
		When query optimizer creates execution plan for a query it does not know the value of variable (unless the specific hint is provided) so it is assuming that average number of rows will be returned. This can lead to awfully wrong query plans especially when there is huge disproportion in data distribution.

3. Views - tables filtered with value
	Pros:
	+ Readable
		Name of the view "vSalesOrderHeader_Approved" is quite clear and communicative.
	
	+ Reusable (whole database)
		Once declared they can be used in every stored procedure, function or other view that requires filtered data.

	+ Good for statistics
		Similar to the magic number case. Numeric values are good for query optimizer and since the views are expanded the execution plans for the queries that use them can be saved and reused.

	Cons:
	- Require a lot of work to maintain.
		Every change to underling table has to apply to every view from which it was derived.
		
	- There is a possibility that the bugs or misunderstanding can occur but there are easier to spot and fix.

4. Schema with static views
	Pros:
	+ Readeable
		Selecting column Approved from view Enum.vSalesOrderHeader_Status is self-explaining. 
	
	+ Reausable (whole database)
		Same as with previous example. Once declared they can be used in every stored procedure, function or other view that requires filtering data.
		
	+ Easy to mantain
		In contrast to the previous example change to the tables that are filtered does not require the change in the static view.
	
	+ Can be easily extended
		When necessery additional views can be declared on top of the static ones just like the view Enum.vSalesOrderHeader_Status_Failed.
	
	+ Quite good for statistics
		Because the views are expanded query optimizer is able to use table statistics to optimize the execution plan.

	Cons:
	- Require a change in how the queries are written. From now on every column has to be written in different way, e.g.
		Instead of:
			OrderStatusID = 2 -- Approved
		It has to be filtered in this way:
			OrderStatusID IN (SELECT Approved FROM Enum.vSalesOrderHeader_Status)
	
	- Can't be used in indexed views (only const value can be use in indexed views).