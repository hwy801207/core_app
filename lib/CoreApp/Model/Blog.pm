package CoreApp::Model::Blog;
use Mojo::Base -base;
use SQL::Abstract::More;
use DateTime;

has 'pg';
has 'sql' => sub { SQL::Abstract::More->new(); };
sub index {
    my $self = shift;
    my $articles = $self->pg->db->select(
        -from => 'blog_article',
        -columns => ['id', 'title', 'content'],
        -limit => 20,
        -offset => 0,
        )->hashes->to_array;
    for my $article (@$articles) {
        my $tags = $self->tags_by_articele_id($article->{'id'});
        $article->{'tags'} = $tags;
    }    
    return $articles;
}

sub get_by_id {
    my ($self, $id) = @_;
    return unless defined $id;

    my $article = $self->pg->db->select('blog_article',undef, {id => $id})->hash;
    my $tags = $self->tags_by_articele_id($article->{'id'});
    $article->{'tags'} = $tags;
    return $article;
	# 如果id不存在的情况下hash为空
}
# get tag name by tag id
sub tag_by_id {
    my ($self, $id) = @_;
    $self->pg->db->select('blog_tag', ['name'], {id => $id})->hash;
}

# 统计每个tags对应的blog数目
sub tags_all {
    my $self = shift;
    $self->pg->db->select(
        -from => [ 'blog_tag', 'article_tags'],
        -columns => [qw/blog_tag.id blog_tag.name COUNT(article_tags.id)/],
        -where   => "blog_tag.id = article_tags.tag_id", 
        -group_by => ['blog_tag.name', 'blog_tag.id'],
    )->hashes;
}

# 关联表 article_tags 通过article_id 查对应的tags
sub tags_by_articele_id {
    my ($self, $article_id) = @_;
    my $tags = $self->pg->db->select('article_tags', ['tag_id'], {article_id => $article_id})->hashes;
    my @tags;
    push @tags, $self->tag_by_id($_->{'tag_id'}) for $tags->each;
    return \@tags;
}

sub add {
    my ($self, $data) = @_;
    my $now = DateTime->now->strftime(join(" ", "%F", "%T"));

    my $article = $self->pg->db->insert(
        -into     => 'blog_article',
        -values   => {'title'        => $data->{'title'}, 
                    'content'      => $data->{'content'},
                    'created_time' => "$now",
                    'is_allow_comment' => 1,
                    'is_delete'        => 0,
                    'user_id'          => 5,
                    },
        -returning => 'id'
    )->hash;

    $self->pg->db->insert(
        -into       => 'article_tags',
        -values     => {'article_id'     => $article->{id},
                        'tag_id'         => $_,
                       }
    ) for @{$data->{tags}};
}
1;


