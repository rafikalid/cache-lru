# cache-lru
Extremely fast and light weight LRU cache for browser and Node

# Install
Will be added very soon.

# Use
The constructor takes the max entries in the cache.
The cache will delete the least recently used element if entries count exceed the maxSize

```javascript
// Create your cache instance
var myCache= new FastLRU(maxSize);

// Or with optional upsert function
var myCache= new FastLRU(maxSize, function optionalUpsertFunction(key){
	// Create new instance if not exists when calling "myObject.upsert(key)"
});
```

# Methods
```javascript
// Add new value to cache
// Key & value could be of any type (not restricted to strings)
myCache.set(key, value);

// Get value from the cache
var value= myCache.get(key);

// Get value from the cache, or create one if not found
var value= myCache.upsert(key);

// If the "upsert" callback in the constructor is an "Async function" or returns a Promise
// Then you will receive a promise as return value of "myCache.upsert"
// You can use "await" or ".then" for it
var value= await myCache.upsert(key);

// Get cache size
var cacheSize= myCache.size

// Check if a key is set
var hasKey= myCache.has('key');

// Delete entry
myCache.delete('key');

// Delete all elements
myCache.clear();

// Iterate over keys
var kiesIterator= myCache.keys();

// ForEach
myCache.forEach(function(value, key){ /* Logic */ });

// For ... of
for([key, value] of myCache){
	/* Your logic */
}
```
