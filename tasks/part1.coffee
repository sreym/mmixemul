shared = window

shared.tasks = new Array() if not shared?tasks

part = new Array()
shared.tasks.push(part)

#task 1
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x10, 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : 0x20, 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : 0x30, 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x10, 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : 0x20, 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : 0x30, 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0xFFFFFFFF,0xFFFFFFFF), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0, 1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : 0x0, 'size' : 8 )

#task 2
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x10, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x20, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0x30, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x10, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x20, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0x30, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0xFFFFFFFF, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x1, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0x0, 'size' : 4 )

#task 3
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x30, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x20, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0x10, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x30, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x20, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0x10, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x0, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x104, 'val' : 0x1, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : 0xFFFFFFFF, 'size' : 4 )

#task 4
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x30, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x102, 'val' : 0x20, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x104, 'val' : 0x10, 'size' : 2 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x30, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x102, 'val' : 0x20, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x104, 'val' : 0x10, 'size' : 2 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x0, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x102, 'val' : 0x1, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x104, 'val' : 0xFFFF, 'size' : 2 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 0x0, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x102, 'val' : 0xFFFF, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x104, 'val' : 0x1, 'size' : 2 )


