package CoreApp::Controller::Blog;
use Mojo::Base 'Mojolicious::Controller';

sub index {
	my $c = shift;
	my $articles = $c->blog->index;
	$c->render( articles => $articles);
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



1;
