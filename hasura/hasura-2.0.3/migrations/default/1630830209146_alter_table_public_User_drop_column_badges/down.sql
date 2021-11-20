alter table "public"."User" alter column "badges" drop not null;
alter table "public"."User" add column "badges" int4range;
