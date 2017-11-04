blog_article
id title content created_time is_allow_comment is_delete user

create table blog_article (
id serial primary key, 
title char(128), 
content text, 
created_time timestamp,
is_allow_comment boolean, 
is_delete boolean, 
user_id int references blog_user(id)  
)

# user　可能是个保留字，所以不要在ｓｑｌ中使用这个关键字否则错误的很诡异

blog_user
id username password active

create table blog_user (
id serial primary key,
username char(128),
password char(128),
active  boolean
)


blog_tag
id name

create table blog_tag (
id serial primary key,
name char(128)
)


article_tags

create table article_tags (id serial primary key, article_id int references blog_article(id), tag_id int references blog_tag(id));


table: blog_comment

fields: id content created_time article 

sql:
create table blog_comment
(id serial primary key,
content text,
created_time timestamp,
article int references blog_article(id)
);


#form 表单
%= form_for '/blog/new' => (method => 'POST') =>(class=>'form') => begin
    <div class="form_group"
    %= label_for title => '标题'
    %= text_field 'title'
    </div>
    <div class="form_group"
    %= label_for content => '标题'
    %= text_field 'content'
    </div>
    <div class="form_group">
        %= submit_button "提交", id=>"new_blog"
    </div>
% end

# route 限制类型
$r->get('/blog/:id' => [ id => qr/\d+/])->to('blog#show');
通过正则表达式限制id只能是数字的，不能是字符串的形式



