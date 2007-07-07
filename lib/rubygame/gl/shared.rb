require 'rubygame'

require 'gl'
require 'glu'
include Gl
include GLU



def pushpop_matrix(&block)
	glPushMatrix()
	block.call()
	glPopMatrix()
end

def glbegin(type, &block)
	glBegin(type)
	block.call()
	glEnd()
end
