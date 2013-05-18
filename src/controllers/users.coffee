## Users Controller
User = require '../models/user'

# User model's CRUD controller.
module.exports =

	index: (param) ->
		{req,res,db} = param

		user = new User	db:db
		data = []
		user.select("id")
			.where( id:[2] )
			.findAll().on('row', (row) ->
				data.push row
			).on 'end', ->
				res.send data or 'no data'
