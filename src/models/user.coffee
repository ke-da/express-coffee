# User model

module.exports = class Users extends require '../lib/model/pg_model'
	table = "users"

	tableDef:
		name: table
		columns: ['id','first_name','last_name', 'email']

	output: (str) -> "hello from users #{table}"

	insert: (data) ->
		unless Array.isArray data then data = [data]
		q = @query.insert(data).toQuery()
		@getDb().query q
