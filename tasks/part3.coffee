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

#task 7
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0,0).setDouble(5), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xD0, 'val' : 8, 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0,0).setDouble(3.6), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0,0).setDouble(5.5), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xD0, 'val' : 9, 'size' : 8 )

#task 8
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(10), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xD8, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xE8, 'val' : 7, 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(5.6), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xD8, 'val' : new shared.OctaByte(0,0).setDouble(4.5), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xE8, 'val' : 1, 'size' : 8 )

#task 9
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(2), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(10), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(Math.sqrt(10)), 'size' : 8 )

#task 10
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x60, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x68, 'val' : 2, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x60, 'val' : new shared.OctaByte(0,0).setDouble(10), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x68, 'val' : 3, 'size' : 4 )

#task 11
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(2), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xE8, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(2 * 3), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(-2), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xE8, 'val' : new shared.OctaByte(0,0).setDouble(100), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(-200), 'size' : 8 )

#task 12
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(8), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x118, 'val' : new shared.OctaByte(0,0).setDouble(2), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(9), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x118, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )

#task 13
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(8), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 2, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(16), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xE0, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : 16, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(64), 'size' : 8 )

#task 14
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(8), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF8, 'val' : 2, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(10), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(3), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF8, 'val' : 3, 'size' : 4 )

#task 15
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xB8, 'val' : new shared.OctaByte(0,0).setDouble(8.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0,0).setDouble(4.3), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xB0, 'val' : new shared.OctaByte(0,0).setDouble(12), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xB8, 'val' : new shared.OctaByte(0,0).setDouble(8), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC0, 'val' : new shared.OctaByte(0,0).setDouble(32), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xB0, 'val' : new shared.OctaByte(0,0).setDouble(40), 'size' : 8 )

#task 16
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(8.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xE8, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF8, 'val' : new shared.OctaByte(0,0).setDouble(4), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xF0, 'val' : new shared.OctaByte(0,0).setDouble(4.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xE8, 'val' : new shared.OctaByte(0,0).setDouble(4.0), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xF8, 'val' : new shared.OctaByte(0,0).setDouble(0), 'size' : 8 )

#task 17
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(8.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(8.4), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(1.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x110, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )

#task 18
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(8.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x108, 'val' : new shared.OctaByte(0,0).setDouble(1.4), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(4.1), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x100, 'val' : new shared.OctaByte(0,0).setDouble(1.4), 'size' : 8 )
