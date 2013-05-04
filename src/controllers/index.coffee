# Just renders index.jade

exports.index = (param) ->
	{req,res} = param
	res.render 'index', name: 'Da Ke'