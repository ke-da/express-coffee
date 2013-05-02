# Post model

module.exports = class Post extends require '../lib/model/pg_model'
	table = "posts"

	tableDef:
		name: table
		columns: ['id','body','title', 'author_id']

	insert: (data) ->
		unless Array.isArray data then data = [data]
		q = @query.insert(data).toQuery()
		@getDb().query q
