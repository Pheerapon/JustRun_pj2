alter table "public"."Room" drop constraint "Room_user_id_key";
alter table "public"."Room" add constraint "Room_user_id_name_room_key" unique ("user_id", "name_room");
