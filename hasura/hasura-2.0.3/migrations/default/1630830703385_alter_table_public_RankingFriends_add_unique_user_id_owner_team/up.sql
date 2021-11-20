alter table "public"."RankingFriends" add constraint "RankingFriends_user_id_owner_team_key" unique ("user_id", "owner_team");
