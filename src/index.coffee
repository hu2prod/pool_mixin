require 'fy'
window = global
window.pool_mixin_constructor = (_t)->

window.pool_mixin = (_t, opt={})->
  _t.$pool_list = []
  _t.$exposed_object_count = 0
  _t.$alloc_counter = 0
  _t.prototype.$ref_count = 1
  _t.alloc = ()->
    _t.$exposed_object_count++
    _t.$alloc_counter++
    if _t.$pool_list.length
      ret = _t.$pool_list.pop()
      ret.$ref_count = 1
      return ret
    new _t
  
  _t.prototype.free = ()->
    if @$ref_count <= 0
      perr "over free"
      return
    @$ref_count--
    if @$ref_count == 0
      _t.$exposed_object_count--
      @delete()
      @clear()
      _t.$pool_list.upush @
      return
    return
  
  _t.prototype.delete ?= ()->
  _t.prototype.clear ?= ()->
  
  if opt.ref
    _t.prototype.ref = ()->
      @$ref_count++
      @