// Generated by CoffeeScript 1.6.2
(function() {
  var part, shared, task;

  shared = window;

  if (!(typeof shared === "function" ? shared(tasks) : void 0)) {
    shared.tasks = new Array();
  }

  part = new Array();

  shared.tasks.push(part);

  task = new Array();

  part.push(task);

  task.push({
    'cmd': 'reg',
    'val': 'random'
  });

  task.push({
    'cmd': 'mem',
    'val': 'random'
  });

  task.push({
    'cmd': 'load'
  });

  task.push({
    'cmd': 'set',
    'addr': 0x100,
    'val': 0x10,
    'size': 8
  });

  task.push({
    'cmd': 'set',
    'addr': 0x108,
    'val': 0x20,
    'size': 8
  });

  task.push({
    'cmd': 'go'
  });

  task.push({
    'cmd': 'get',
    'addr': 0x110,
    'val': 0x30,
    'size': 8
  });

}).call(this);

/*
//@ sourceMappingURL=part1.map
*/
