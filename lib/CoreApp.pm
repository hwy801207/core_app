package CoreApp;
use Mojo::Base 'Mojolicious';
use Mojo::Pg;
use CoreApp::Model::Blog;
use CoreApp::Model::User;
# This method will run once at server start
sub startup {
  my $self = shift;

  # Load configuration from hash returned by "my_app.conf"
  my $config = $self->plugin('Config');

  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer') if $config->{perldoc};

  # Router
  my $r = $self->routes;

  $self->helper(pg => sub {
		  state $pg = Mojo::Pg->new(shift->config('pg'));
		  $pg->abstract(SQL::Abstract::More->new);
	  });

  $self->helper(blog => sub {
		  state $blog = CoreApp::Model::Blog->new(pg => shift->pg);
	  });

  $self->helper(user => sub {
		  state $user = CoreApp::Model::User->new(pg => shift->pg);
	  });

  $self->helper(current => sub {
		  my $self = shift;
		  return $self->session('username');
	  });

  # load my command
  # push @{$self->commands->namespace}, 'CoreApp::Command';
  # Normal route to controller
  #$r->get('/')->to('example#welcome');
  #

  $r->get('/')->to('blog#index');
  $r->get('/data')->to('blog#json');
  $r->get('/blog/:id')->to('blog#show');
}

1;
