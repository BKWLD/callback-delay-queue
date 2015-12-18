###
This class creates queue objects that invoke the passed on callback.  However,
this call may be delayed by calling wait() on the queue.  Only once .done() has
been called as many times as wait() has been called will the callback be called.

These objects were designed to be passed through to event handlers so that they
can delay some behavior on the event trigger.

Vue.js with vue-router example:

	# A route component
	new Vue
		el: '#home'
		route: deactivate: (transition) ->
			queue = new Queue(transition.next)
			@$broadcast 'deactivating', queue
			transition.next() if queue.isEmpty()

	# A child of the route component
	new Vue
		el: '#home .marquee'
		events: deactivating: (queue) ->
			queue.waitFor (done) => Velocity(@$el, {opacity: 0}, done)

###
module.exports = class CallbackDelayQueue

	# The count of pending transitions
	# @var {integer}
	pending: 0

	# Pass in the vue-router transition.next callback
	constructor: (@callback) ->

	# Add to the queue, resulting in the resolution waiting
	wait: -> @pending++

	# Remove an item from the queue and see if we can resolve the transition
	done: ->
		console.log 'done'
		@callback() if --@pending == 0

	# Convenience method that invokes passed callback with a the `done` callback
	# @params {function} cb
	waitFor: (cb) ->
		this.wait()
		cb => @done()

	# Check whether the queue is finished
	# @return {boolean}
	isEmpty: -> @pending == 0
