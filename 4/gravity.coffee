class Space
	@playing: true
	@bg : 'rgb(0,0,0)'
	@gravG : 1
	@objects : []

class GravitatingBody
	constructor: () ->
		@_d = {}
		@_posX = 0
		@_posY = 0
		@_m = 0
		@_traces = []
		@_gravX = 0
		@_gravY = 0
		@_velx = 0
		@_vely = 0
		@_restX = 0
		@_restY = 0
		@_diam = 0
		@_col = {
			r:0,
			g:0,
			b:0
		}
	build: () ->
		@_d = document.createElement 'div'
		@_d.style.borderRadius = @_diam/2 + 'px'
		@_d.style.height = @_diam + 'px'
		@_d.style.width = @_diam + 'px'
		@_d.style.position = 'absolute'
		@_d.style.backgroundColor = 'rgb(' + @_col.r + ',' + @_col.g + ',' + @_col.b + ')';
		document.documentElement.appendChild @_d
		@moveTo @_posX, @_posY
	mass: () -> @_m
	moveTo: (x,y) ->
		@_d.style.top = Math.floor(y) + 'px'
		@_d.style.left = Math.floor(x) + 'px'

	coords: -> return {
		x: parseInt @_d.style.left
		y: parseInt @_d.style.top
	}

	colour: -> @_d.style.backgroundColor
	frame: ->
		self = this
		self._gravX = self._gravY = 0
		Space.objects.forEach (object) ->
			return if object == self
			MCtr = object.mass()
			dy = self.coords().y - object.coords().y
			dx = self.coords().x - object.coords().x
			d2 = (Math.pow(dy, 2) + Math.pow(dx, 2))
			d = Math.sqrt d2
			d2xp = dx / d
			d2yp = dy / d
			grav = ( Space.gravG * MCtr ) / d2
			self._gravX += d2xp * grav
			self._gravY += d2yp * grav
		self._vely -= self._gravY
		self._velx -= self._gravX
		newPosX = self.coords().x + self._velx
		newPosY = self.coords().y + self._vely
		self.moveTo newPosX, newPosY
			#@_velx = -@_velx * @_restX if 0 >= this.x() or this.x() >= @el.clientWidth
			#@_vely = -@_vely * @_restY if 0 >= this.y() or this.y() >= @el.clientHeight
	setPositionFromEvent : (event) ->
			@_posY = event.clientY
			@_posX = event.clientX
	setPositionRandom: () ->
			el = document.documentElement
			@_posY = Math.floor Math.random()*el.clientHeight
			@_posX = Math.floor Math.random()*el.clientWidth
	setPositionMiddle: () ->
			el = document.documentElement
			@_posY = 0.5*el.clientHeight
			@_posX = 0.5*el.clientWidth

class Star extends GravitatingBody
	constructor: ()->
		super
		@_m = 3000
		@_diam = 3
		@_col = {
			r:255,
			g:255,
			b:255
		}

class BlackHole extends GravitatingBody
	constructor: ()->
		super
		@_m = 300000
		@_diam = 30
		@_col = {
			r:32,
			g:32,
			b:32
		}
	frame: () ->

$(document).ready ->
	$(document.documentElement).css({backgroundColor: Space.bg});
	$(document.documentElement).click (e)->
		if e.button is 0 then b = new Star
		b.setPositionFromEvent e
		b.build()
		Space.objects.push b

	bh = new BlackHole
	bh.setPositionMiddle()
	bh.build()
	Space.objects.push bh

	for num in [1..100]
		star = new Star
		star.setPositionRandom()
		star.build()
		Space.objects.push star

	animate = ->
		Space.objects.forEach (object) ->
			object.frame()
		window.requestAnimationFrame(animate)
	animate()