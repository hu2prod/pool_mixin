window = global
window.pool_mixin_constructor = (_t)->

window.pool_mixin = (_t)->
  _t.$pool_list = []
  _t.alloc = ()->
    if _t.$pool_list.length
      return _t.$pool_list.pop()
    new _t
  
  _t.prototype.free = ()->
    @delete()
    @clear()
    _t.$pool_list.push @
    return
  
  _t.prototype.delete ?= ()->
  _t.prototype.clear ?= ()->
  