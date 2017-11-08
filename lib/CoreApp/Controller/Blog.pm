package CoreApp::Controller::Blog;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $c = shift;
	my $page = $c->stash('page') ? $c->stash('page') : 1; 
	if ($c->stash('dir') eq 'p') {
		$page -= 1;
		$page = 1 if $page == 0;
	}
	my $articles = $c->blog->index($page);
	$c->render( articles => $articles, page => $page);
}


sub show {
	my $c = shift;
	my $article = $c->blog->get_by_id($c->stash('id'));
	$c->render(article => $article);
}
sub json {
	my $c = shift;
	$c->render(json => {"key" => "18", "name"=> "all is over"});
}

sub add {
	my $c = shift;
	# 是否登录
	if (not $c->session->{'user'}) {
		return $c->redirect_to("/login");
	}
	my $user = $c->user->load_user($c->session->{'user'});
	if ($c->req->method eq 'GET') {
		return $c->render();
	}
	elsif ($c->req->method eq 'POST') {
		my $data = $c->req->params->to_hash;
		$data->{user} = $user->{id};
		$c->blog->add($data);
		$c->redirect_to("/");
	}
	else {
		$c->render(json => {"方法"=> "被禁止"})
	}
}

1;
