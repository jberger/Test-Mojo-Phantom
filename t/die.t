use Mojolicious::Lite;

any '/' => { text => 'Hello World'};

use Test::More;
use Test::Mojo;

use Test::Mojo::Phantom;

use Test::Stream::Tester;

my $t = Test::Mojo->new;

my $grab = grab();

$t->phantom_ok('/', <<'JS');
  perl.ok(1, 'dummy test from javascript');
  var system = require('system');
  perl('CORE::die', 'die');
  perl.ok(1, "don't get here");
JS

events_are(
  $grab->finish->[0]->events,
  check {
    event ok => { bool => 1, name => qr/dummy/ };
    event ok => { bool => 0, name => qr/signal/ };
    directive 'end';
  },
);

done_testing;

