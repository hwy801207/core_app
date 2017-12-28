package CoreApp::Model::Comment;
use Mojo::Base -base;
use SQL::Abstract::More;

has 'pg';
has 'sql' => sub { SQL::Abstract::More->new();}


sub get {
    my ($self, $id) = @_;
    my $sql = 'SELECT id, content, created_time FROM'.
              ' blog_commnet where article=?';

    my $result = eval {
        $self->pg->db->query($sql, $id)->hashes;
    }

    if (defined $result) {
        return $result;
    } else {
        return { error => $! };
    }
}

sub count {
    my ($self, $id) = @_;
    my $sql = "SELECT COUNT(id) as count FROM blog_comment WHERE".
              " article=?".
    my $result = eval {
            $self->pg->db->query($sql, $id)
            ->hash->{count};
    };

    if (defined $result) {
        return { count => $result };
    } else {
        return { error => $!};
    }
}

sub statistics {
    my $self = shift;
    my $sql = "SELECT article, COUNT(id) as count FROM blog_comment GROUP BY article";

    my $result = eval {
        $self->pg->db->query($sql)->hashes;
       };
    if (defined $result) {
        return $result;
    } else {
        return { error => $!};
    }
}