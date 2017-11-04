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
	my $tags = $c->blog->tags_all;
	$c->render( articles => $articles, tags => $tags, page => $page);
}


sub show {
	my $c = shift;
	my $article = $c->blog->get_by_id($c->stash('id'));
	my $tags = $c->blog->tags_all;
	$c->render(article => $article, tags=>$tags);
}
sub json {
	my $c = shift;
	$c->render(json => {"key" => "18", "name"=> "all is over"});
}

sub add {
	my $c = shift;
	my $tags = $c->blog->tags_all;
	if ($c->req->method eq 'GET') {
		$c->render(tags=>$tags);
	}
	elsif ($c->req->method eq 'POST') {
		my $data = $c->req->params->to_hash;
		$c->blog->add($data);
		$c->redirect_to("/")
	}
	else {
		$c->render(json => {"方法"=> "被禁止"})
	}
}

1;
