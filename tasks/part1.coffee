shared = window

shared.tasks = new Array() if not shared?tasks

part = new Array()
shared.tasks.push(part)

task = new Array()
part.push(task)


task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x10, 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : 0x20, 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : 0x30, 'size' : 8 )



