alter table "public"."RoomMember" add constraint "RoomMember_user_id_room_id_key" unique ("user_id", "room_id");
