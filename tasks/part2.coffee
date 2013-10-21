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
task.push( 'cmd': 'set', 'addr' : 0x60, 'val' : new shared.OctaByte(0xF0F0F0F0,0xF0F0F0F0), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x68, 'val' : new shared.OctaByte(0xFF00FF00,0x00FF00FF), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x60, 'val' : new shared.OctaByte(0xF000F000,0x00F000F0), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x60, 'val' : new shared.OctaByte(0xF0F0F0F0,0xF0F0F0F0), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x68, 'val' : new shared.OctaByte(0xFF00FF00,0x00FF00FF), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x60, 'val' : new shared.OctaByte(0xF000F000,0x00F000F0), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x60, 'val' : new shared.OctaByte(0x0,0x0), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0x68, 'val' : new shared.OctaByte(0x0,0x0), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x60, 'val' : new shared.OctaByte(0x0,0x0), 'size' : 8 )

#task 2
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x80, 'val' : 0xF0F00F0F, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x84, 'val' : 0x0F0FF0F0, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x84, 'val' : 0xFFFFFFFF, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x80, 'val' : 0xF0F00F0F, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0x84, 'val' : 0x0F0FF0F0, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x84, 'val' : 0xFFFFFFFF, 'size' : 4 )

#task 3
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x90, 'val' : 0x89AB, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x94, 'val' : 0xCDEF, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x92, 'val' : 0x4444, 'size' : 2 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x90, 'val' : 0x89AB, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0x94, 'val' : 0xCDEF, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x92, 'val' : 0x4444, 'size' : 2 )

#task 4
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x7A, 'val' : 0xfe, 'size' : 1 )
task.push( 'cmd': 'set', 'addr' : 0x7B, 'val' : 0x12, 'size' : 1 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x7C, 'val' : 0x13, 'size' : 1 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0x7A, 'val' : 0xfe, 'size' : 1 )
task.push( 'cmd': 'set', 'addr' : 0x7B, 'val' : 0x12, 'size' : 1 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0x7C, 'val' : 0x13, 'size' : 1 )

#task 5
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xAD, 'val' : 0xA7F0, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0xAE, 'val' : 0xA8F0, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xAB, 'val' : 0xF7FF, 'size' : 2 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xAD, 'val' : 0xA7F0, 'size' : 2 )
task.push( 'cmd': 'set', 'addr' : 0xAE, 'val' : 0xA8F0, 'size' : 2 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xAB, 'val' : 0xF7FF, 'size' : 2 )


#task 6
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xDA, 'val' : 0x0F0F0F0F, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0xDD, 'val' : 0x12345678, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xDA, 'val' : 0x10305070, 'size' : 4 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xDA, 'val' : 0x0F0F0F0F, 'size' : 4 )
task.push( 'cmd': 'set', 'addr' : 0xDD, 'val' : 0x12345678, 'size' : 4 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xDA, 'val' : 0x10305070, 'size' : 4 )

#task 7
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xD7, 'val' : new shared.OctaByte(0xF0F0F0F0,0x89ABCDEF), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xDF, 'val' : new shared.OctaByte(0x0F0F0F0F,0x01234567), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xDA, 'val' : new shared.OctaByte(0xFFFFFFFF,0xfedcba98), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xD7, 'val' : new shared.OctaByte(0xF0F0F0F0,0x89ABCDEF), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xDF, 'val' : new shared.OctaByte(0x0F0F0F0F,0x01234567), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xDA, 'val' : new shared.OctaByte(0xFFFFFFFF,0xfedcba98), 'size' : 8 )

#task 8
task = new Array()
part.push(task)

task.push( 'cmd': 'reg', 'val' : 'inc' )
task.push( 'cmd': 'mem', 'val' : 'inc' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0xF0F0F0F0,0x00000123), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC7, 'val' : new shared.OctaByte(0x0F0F0F0F,0x4567FFFF), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xCA, 'val' : new shared.OctaByte(0x00000000,0xba980000), 'size' : 8 )

task.push( 'cmd': 'reg', 'val' : 'random' )
task.push( 'cmd': 'mem', 'val' : 'random' )
task.push( 'cmd': 'load')
task.push( 'cmd': 'set', 'addr' : 0xC8, 'val' : new shared.OctaByte(0xF0F0F0F0,0x00000123), 'size' : 8 )
task.push( 'cmd': 'set', 'addr' : 0xC7, 'val' : new shared.OctaByte(0x0F0F0F0F,0x4567FFFF), 'size' : 8 )
task.push( 'cmd': 'go')
task.push( 'cmd': 'get', 'addr' : 0xCA, 'val' : new shared.OctaByte(0x00000000,0xba980000), 'size' : 8 )
