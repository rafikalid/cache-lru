###*
 * This is a light LRU cache
 * if you need a full functionnality cache, use Core.LRU_TTL
###
class FastLRU
	constructor: (max, upsertCb)->
		# Check max value
		if max?
			throw new Error "Expected max>0" unless max>0
		else
			max= Infinity
		# prepare
		@_map= new Map()
		@_head= null
		@_tail= null
		@max= max
		@upsertCb= upsertCb
		return
	###*
	 * Put value in the Cache
	###
	set: (key, value)->
		if element= @_map.get key
			element.value= value
			@_refresh element
		else
			@_set key, value
		this # chain
	###* @private ###
	_set: (key, value)->
		map= @_map
		lastElement= @_head
		element=
			key: key
			value: value
			prev: lastElement
			next: null
		# Add
		lastElement?.next= element
		@_head= element
		map.set key, element
		# set tail as element if first one
		@_tail?= element
		# Remove oldest if exceeds count
		if (map.size > @max) and (oldest= @_tail)
			map.delete oldest.key
			# adjut chain
			if nxtElement= oldest.next
				@_tail= nxtElement
				nxtElement.prev= null
			else
				@_tail= @_head= null
		return
	###*
	 * Get value from Cache
	###
	get: (key)->
		if el= @_map.get key
			@_refresh el
			return el.value
		else
			return undefined
	###*
	 * Get value or create it
	###
	upsert: (key)->
		if element= @_map.get key
			@_refresh element
			value= element.value
			return value
		else
			value= @upsertCb key
			if value and typeof value.then is 'function'
				return value.then (v)=>
					@_set key, v
					return v
			else
				@_set key, value
				return value
	###*
	 * Refresh element
	 * @private
	###
	_refresh: (el)->
		last= @_head
		unless last is el
			# remove from chain
			el.prev?.next= el.next
			el.next?.prev= el.prev
			# put as the freshest
			@_head= el
			el.prev= last
			el.next= null
			last.next= el
		return
	###*
	 * Get cache len
	###
	```
	get size(){return this._map.size;}
	```
	###* Has ###
	has: (key)-> @_map.has key
	###* Delete ###
	delete: (key)->
		map= @_map
		if element= map.get key
			map.delete key
			element.prev.next= element.next if element.prev
			element.next.prev= element.prev if element.next
			@_tail= element.next if element is @_tail
			@_head= element.prev if element is @_head
		this # chain
	###* Remove all entries ###
	clear: ->
		@_map.clear()
		@_tail= @_head= null
		this # chain
	###* Iterable for keys ###
	keys: -> @_map.keys()

	###* ForEach ###
	forEach: (cb)->
		@_map.forEach (v, key)-> cb v.value, key
		this # chain

###* For of ###
FastLRU::[Symbol.iterator]= ->
	it= @_map[Symbol.iterator]() # Get map iterator
	return {
		next: ->
			vl= it.next()
			value: vl.value?.value
			done: vl.done
	}
