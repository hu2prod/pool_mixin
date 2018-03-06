assert = require 'assert'

mod = require '../src/index.coffee'

describe 'index section >', ()->
  it 'mixin constructor with default delete/free', ()->
    class A
      pool_mixin @
      constructor:()->
        pool_mixin_constructor @
    assert.equal A.$exposed_object_count, 0
    tmp = A.alloc()
    assert.equal A.$exposed_object_count, 1
    tmp.free()
    assert.equal A.$exposed_object_count, 0
    assert.equal A.$pool_list.length, 1
    assert.equal A.$pool_list[0], tmp
    
    tmp2 = A.alloc()
    assert.equal tmp2, tmp
    
    return
  
  it 'mixin constructor with delete/free coverage', ()->
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
    assert.equal A.$exposed_object_count, 0
    tmp = A.alloc()
    assert.equal A.$exposed_object_count, 1
    tmp.free()
    assert.equal A.$exposed_object_count, 0
    assert.equal A.$pool_list.length, 1
    assert.equal A.$pool_list[0], tmp
    assert.equal fire_1, 1
    assert.equal fire_2, 1
    
    tmp2 = A.alloc()
    assert.equal tmp2, tmp
    
    return
  
  it 'over free', ()->
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
    assert.equal A.$exposed_object_count, 0
    tmp = A.alloc()
    assert.equal A.$exposed_object_count, 1
    tmp.free()
    assert.equal A.$exposed_object_count, 0
    tmp.free()
    assert.equal A.$exposed_object_count, 0
    assert.equal fire_1, 1
    assert.equal fire_2, 1
    return
  
  describe 'mode ref >', ()->
    it 'use ref no free', ()->  
      fire_1 = 0
      fire_2 = 0
      class A
        pool_mixin @, ref:true
        constructor:()->
          pool_mixin_constructor @
        delete : ()->
          fire_1++
        clear : ()->
          fire_2++
      tmp = A.alloc()
      tmp2 = tmp.ref()
      assert.equal tmp.$ref_count, 2
      tmp2.free()
      assert.equal fire_1, 0
      assert.equal fire_2, 0
      tmp.free()
      assert.equal fire_1, 1
      assert.equal fire_2, 1
      
      return
  
    it 'over free', ()->
      fire_1 = 0
      fire_2 = 0
      class A
        pool_mixin @, ref:true
        constructor:()->
          pool_mixin_constructor @
        delete : ()->
          fire_1++
        clear : ()->
          fire_2++
      tmp = A.alloc()
      tmp.free()
      tmp.free()
      assert.equal fire_1, 1
      assert.equal fire_2, 1
      return
    
  
