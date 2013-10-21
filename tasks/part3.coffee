shared = window

shared.tasks = new Array() if not shared.tasks

part = new Array()
shared.tasks.push(part)

#task 1
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(4 + 16), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(20), 'size' : 8 )

#task 2
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(20), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(20 - 16), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(20), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(20 - 16), 'size' : 8 )

#task 3
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x70, 'val' : new shared.OctaByte(0,4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x78, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x80, 'val' : new shared.OctaByte(0,0).setDouble(4 + 16), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x70, 'val' : new shared.OctaByte(0,4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x78, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x80, 'val' : new shared.OctaByte(0,0).setDouble(4 + 16), 'size' : 8 )

#task 4
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x98, 'val' : new shared.OctaByte(0,0).setDouble(20), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x90, 'val' : 0x00000004, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x98, 'val' : new shared.OctaByte(0,0).setDouble(20 - 4), 'size' : 8 )

#task 5
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0xFFFFFFFF,0xFFFFFFFC), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xD0, 'val' : new shared.OctaByte(0,0).setDouble(0), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0x0,0x1), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xD0, 'val' : new shared.OctaByte(0,0).setDouble(5), 'size' : 8 )

#task 6
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xA0, 'val' : 0xFFFF, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0xA8, 'val' : new shared.OctaByte(0,0).setDouble(-1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xA8, 'val' : new shared.OctaByte(0,0).setDouble(0), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xA0, 'val' : 0xA, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0xA8, 'val' : new shared.OctaByte(0,0).setDouble(5), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xA8, 'val' : new shared.OctaByte(0,0).setDouble(5), 'size' : 8 )
