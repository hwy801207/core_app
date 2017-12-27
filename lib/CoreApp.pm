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

  # $self->helper('cache_control.no_caching' => sub {
  # 		  my $c = shift->c;
  # 		  $c->res->headers->cache_control('private, max-age=0, no-cache');
  # 	  });

  $self->helper(pg => sub {
		  state $pg = Mojo::Pg->new(shift->config('pg'));
		  $pg->abstract(SQL::Abstract::More->new);
	  });

  $self->helper(blog => sub {
		  state $blog = CoreApp::Model::Blog->new(pg => shift->pg);
	  });
 # tags 分类
  $self->helper(tags => sub {
    state $tags = shift->pg->db->select(
        -from => [ 'blog_tag', 'article_tags'],
        -columns => [qw/blog_tag.id blog_tag.name COUNT(article_tags.id)/],
        -where   => "blog_tag.id = article_tags.tag_id", 
        -group_by => ['blog_tag.name', 'blog_tag.id'],
      )->hashes;
  });

# 最新10post
  $self->helper(top10post => sub {
    state $top_10_post = shift->pg->db->select(
      -from => 'blog_article',
      -limit => 10,
      -order_by => '-created_time',
    )->hashes;
  });

# 最新回复
$self->helper(new10post => sub {
  state $new10post = shift->pg->db->select(
    -from => 'blog_article',
    -order_by => '-created_time', 
    -limit => 10,
  )->hashes;
});


# 最新回复10
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
  $r->get('/blog/:id' => [id => qr/\d+/])->to('blog#show');
  $r->any('/blog/new/')->to('blog#add'); #for get or post 
  $r->get('/blog/:dir/:page' => [page => qr/\d+/])->to('blog#index');


  $r->get('/login')->to('user#login');
  $r->post('/register')->to('user#register');
  $r->post('/auth')->to('user#auth');
  $r->get('/logout')->to('user#logout');
}

1;
