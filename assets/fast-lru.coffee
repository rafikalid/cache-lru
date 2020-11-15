###*
 * Router
###
<% var Core= false; %>
do->
	"use strict"
	#=include _utils.coffee
	#=include cache/_main.coffee

	# Export interface
	if module? then module.exports= FastLRU
	else if window? then window.FastLRU= FastLRU
	else
		throw new Error "Unsupported environement"
	return
