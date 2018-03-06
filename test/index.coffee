assert = require 'assert'

mod = require '../src/index.coffee'

describe 'index section', ()->
  it 'mixin constructor with default delete free', ()->
    class A
      pool_mixin @
      constructor:()->
        pool_mixin_constructor @
    tmp = A.alloc()
    tmp.free()
    assert.equal A.$pool_list.length, 1
    assert.equal A.$pool_list[0], tmp
    
    tmp2 = A.alloc()
    assert.equal tmp2, tmp
    
    return
  
  it 'mixin constructor', ()->
    fire_1 = 0
    fire_2 = 0
    class A
      pool_mixin @
      constructor:()->
        pool_mixin_constructor @
      delete : ()->
        fire_1++
      clear : ()->
        fire_2++
    tmp = A.alloc()
    tmp.free()
    assert.equal A.$pool_list.length, 1
    assert.equal A.$pool_list[0], tmp
    assert.equal fire_1, 1
    assert.equal fire_2, 1
    
    tmp2 = A.alloc()
    assert.equal tmp2, tmp
    
    return
  