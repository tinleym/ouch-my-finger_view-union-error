

drop database if exists my_db;
create database my_db;

\c my_db;

create schema app_public;

create table app_public.toads(
    id serial primary key,
    name text not null
);
comment on table app_public.toads is $$
    '@unionMember SomeAnimal'
$$;

create table app_public.gerbils(
    id serial primary key,
    name text not null
);
comment on table app_public.gerbils is $$
    '@unionMember SomeAnimal'
$$;

create table app_public.sharks(
    id serial primary key,
    name text not null
);
comment on table app_public.sharks is $$
    '@unionMember SomeAnimal'
$$;

create view app_public.animals as
    select 
        't_' || id as id,
        id as toad_id,
        null::integer as gerbil_id,
        null::integer as shark_id,
        name
    from app_public.toads
    union all
    select
        'g_' || id as id,
        null::integer as toad_id,
        id as gerbil_id,
        null::integer as shark_id,
        name
    from app_public.gerbils
    union all
    select 
        's_' || id as id,
        null::integer as toad_id,
        null::integer as gerbil_id,
        id as shark_id,
        name
    from app_public.sharks;
comment on view app_public.animals is $$
    @ref thing to:SomeAnimal singular
    @refVia thing via:(toad_id)->toads(id)
    @refVia thing via:(gerbil_id)->gerbils(id)
    @refVia thing via:(shark_id)->sharks(id)
$$;

-- including the following with the app_public.animals comment solves the issue:
-- @foreignKey (toad_id) references toads(id)
-- @foreignKey (gerbil_id) references gerbils(id)
-- @foreignKey (shark_id) references sharks(id)


