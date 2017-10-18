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


blog_tags
id name

article_tags

create table article_tags (id serial primary key, article_id int references blog_article(id), tag_id int references blog_tags(id));

blog_comment
id content created_time article 

create table blog_comment
(id serial primary key,
content text,
created_time timestamp,
article int references blog_article(id)
);


