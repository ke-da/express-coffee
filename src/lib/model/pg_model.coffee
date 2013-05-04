## Postgres Model Abstract
## @author Da Ke <keda@outlook.com>

sql = require 'sql'

module.exports = class PG_Model
	table: "**GiveTableName**"
	@tableDefCache: {}

	@dbConn : null

	query:
		current: null #Current on going query
		instance: null #origin instance of sql query

	constructor: (@opt = {}) ->
		if @opt.table then @table = @opt.table 
		if @opt.db then @setDb @opt.db

		if @tableDef then @addTableDef @tableDef

	setDb: (conn) ->
		PG_Model.dbConn = conn
		@

	getDb: -> PG_Model.dbConn

	## Set a table definition
	addTableDef: (def) ->
		unless @query.instance
			PG_Model.tableDefCache[@table] = @query.instance = sql.define def

	## Get a table definition
	getTableDef: (tbName) -> PG_Model.tableDefCache[tbName]

	## Get current SQL query
	getQuery: -> if @query.current then @query.current else @query.instance
		
	updateQuery: (q = null) -> @query.current = q

	clearQuery: -> do @updateQuery
	
	select: (select) ->
		selectArgs = []
		query = @getQuery()
		if select
			if Array.isArray select #array
				for sel in select
					if sel is "*" then selectArgs.push query.star()
					else if query[sel]? then selectArgs.push query[sel]
			else #string
				selectArgs.push select

		else selectArgs.push query.star()

		@updateQuery query.select.apply(query, selectArgs)
		@

	## "WHERE" or "OR" operation
	_whereOp: (op, conditions) ->
		q = null
		query = @getQuery()
		ins = @query.instance
		for own key,val of conditions
			if ins[key]?
				unless q
					q = if Array.isArray val
						ins[key].in val
					else
						ins[key].equals val
				else
					q = q.and if Array.isArray val
						ins[key].in val
					else
						ins[key].equals val

		if q
			@updateQuery query[op](q)
		@

	where: (conditions) -> @_whereOp 'where', conditions

	orWhere: (conditions) ->
		@_whereOp 'or', conditions

	find: ->
		q = @getQuery().from(@query.instance).toQuery()
		console.log 'q',q
		do @clearQuery
		@getDb().query q

	findWhere: (where) ->
		q = @where(where)
				.getQuery()
				.from(@query.instance)
				.toQuery()

		@getDb().query q

	findAll: ->
		q = @getQuery().from(@query.instance)
						.where(@query.instance.id.isNotNull())
						.toQuery()
		console.log 'findall',q
		@getDb().query q

	insert: (row) ->
		q= @getQuery().insert row
