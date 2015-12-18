# callback-delay-queue

This class creates queue objects that invoke the passed on callback.  However,
this call may be delayed by calling wait() on the queue.  Only once .done() has
been called as many times as wait() has been called will the callback be called.

These objects were designed to be passed through to event handlers so that they
can delay some behavior on the event trigger.

A Vue.js + vue-router example:

```coffee

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

```
