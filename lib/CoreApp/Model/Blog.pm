package CoreApp::Model::Blog;
use Mojo::Base -base;
use SQL::Abstract::More;

has 'pg';
has 'sql' => sub { SQL::Abstract::More->new(); };
sub index {
    my $self = shift;
    $self->pg->db->select(
        -from => 'blog_article',
        -columns => ['id', 'title', 'content'],
        -limit => 20,
        -offset => 40,
        )->hashes->to_array;
}

sub get_by_id {
    my ($self, $id) = @_;
    return unless defined $id;
    $self->pg->db->select('blog_article',undef, {id => $id})->hash;
}
1;


