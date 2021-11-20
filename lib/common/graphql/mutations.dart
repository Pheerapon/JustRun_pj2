mixin Mutations {
  static String addHistory() {
    return '''mutation InsertRunHistory(\$avg: Int!, \$date: timestamp!, \$distance: float8!, \$image: String!, \$steps: Int!, \$time: String!, \$user_id: String!, \$money: Int!, \$imageUrl: String!) {
      insert_RunHistory(objects: {avg: \$avg, date: \$date, distance: \$distance, image: \$image, steps: \$steps, time: \$time, user_id: \$user_id, money: \$money, imageUrl: \$imageUrl}) {
        returning {
          id
          avg
          distance
          date
          image
          steps
          time
          money
          user_id
          imageUrl
        }
      }
    }''';
  }

  static String addUserInfo() {
    return '''mutation InsertUser(\$id: String!, \$name: String!, \$email: String!, \$money: Int!, \$avatar: String!) {
      insert_User(objects: {id: \$id, name: \$name, email: \$email, money: \$money, avatar: \$avatar}) {
        returning {
          id
          email
          money
          name
          user_skin_id
          avatar
        }
      }
    }''';
  }

  static String updateGender() {
    return '''mutation UpdateGenderUser(\$gender: Gender_enum!, \$id: String!) {
      update_User(where: {id: {_eq: \$id}}, _set: {gender: \$gender}) {
        returning {
          id
          gender
        }
      }
    }''';
  }

  static String updateAvatar() {
    return '''mutation UpdateAvatar(\$id: String!, \$avatar: String = "") {
      update_User(where: {id: {_eq: \$id}}, _set: {avatar: \$avatar}) {
        returning {
          email
          gender
          money
          name
          id
          user_skin_id
          badges
          is_premium
          avatar
        }
      }
    }''';
  }

  static String addGoals() {
    return '''mutation updateGoal(\$distance: float8!, \$time: Int!, \$step: Int!, \$user_id: String!) {
      delete_Goal(where: {user_id: {_eq: \$user_id}}) {
        affected_rows
      }
      insert_Goal(objects: {distance: \$distance, time: \$time, step: \$step, user_id: \$user_id}) {
        returning {
          distance
          step
          time
          user_id
        }
      }
    }''';
  }

  static String updateMoney() {
    return '''mutation updateUser(\$user_id: String!, \$money: Int!) {
      update_User(where: {id: {_eq: \$user_id}}, _set: {money: \$money}) {
        returning {
          money
          email
          name
        }
      }
    }''';
  }

  static String updatePremium() {
    return '''mutation updatePremium(\$id: String!, \$is_premium: Boolean!, \$money: Int!) {
      update_User(where: {id: {_eq: \$id}}, _set: {is_premium: \$is_premium, money: \$money}) {
        returning {
          is_premium
          money
        }
      }
    }
  ''';
  }

  static String updateBadges() {
    return '''mutation UpdateUser(\$id: String = "", \$badges: _int4 = "") {
      update_User(where: {id: {_eq: \$id}}, _set: {badges: \$badges}) {
        returning {
          badges
        }
      }
    }''';
  }

  static String insertRewardDaily() {
    return '''mutation insertDailyReward(\$user_id: String!, \$current_daily: timestamp!) {
      insert_DailyReward(objects: {days_row: 0, user_id: \$user_id, current_daily: \$current_daily}) {
        returning {
          current_daily
          days_row
        }
      }
    }
  ''';
  }

  static String updateRewardDaily() {
    return '''mutation updateDailyReward(\$user_id: String!,\$current_daily: timestamp!, \$days_row: Int!) {
      update_DailyReward(where: {user_id: {_eq: \$user_id}}, _set: {current_daily: \$current_daily, days_row: \$days_row}) {
        returning {
          current_daily
          days_row
        }
      }
    }
  ''';
  }

  static String createRoom() {
    return '''mutation CreateRoom(\$user_id: String = "", \$name_room: String = "") {
      insert_Room(objects: {user_id: \$user_id, name_room: \$name_room}) {
        returning {
          id
          user_id
          name_room
        }
      }
    }
  ''';
  }

  static String deleteRoom() {
    return '''mutation deleteRoom(\$id: Int !) {
      delete_Room(where: {id: {_eq: \$id}}) {
        returning {
          id
        }
      }
    }
  ''';
  }

  static String deleteRoomMember() {
    return '''mutation deleteRoomMember(\$room_id: Int!, \$user_id: String!) {
      delete_RoomMember(where: {_and: {room_id: {_eq: \$room_id}, user_id: {_eq: \$user_id}}}) {
        returning {
          id
        }
      }
    }
  ''';
  }

  static String insertMember() {
    return '''mutation InsertMember(\$room_id: Int!, \$user_id: String!, \$name: String = "", \$avatar: String = "", \$owner_group_id: String = "") {
      insert_RoomMember(objects: {room_id: \$room_id, user_id: \$user_id, name: \$name, avatar: \$avatar, owner_group_id: \$owner_group_id}) {
        returning {
          room_id
          user_id
        }
      }
    }
  ''';
  }

  static String insertInvite() {
    return '''mutation InsertInvite(\$user_id: String = "", \$room_id: Int!, \$owner_name: String = "", \$guest_email: String = "", \$gender: String = "") {
      delete_Invite(where: {_and: {guest_email: {_eq: \$guest_email}, room_id: {_eq: \$room_id}}}) {
        returning {
          room_id
          guest_email
        }
      }
      insert_Invite(objects: {gender: \$gender, guest_email: \$guest_email, owner_name: \$owner_name, room_id: \$room_id, user_id: \$user_id}) {
        returning {
          gender
          guest_email
          owner_name
          room_id
          user_id
        }
      }
    }
  ''';
  }

  static String updateInvite() {
    return '''mutation UpdateInvite(\$user_id: String = "", \$room_id: Int!, \$owner_name: String = "", \$guest_email: String = "", \$gender: String = "") {
      update_Invite(_set: {gender: \$gender, guest_email: \$guest_email, owner_name: \$owner_name, room_id: \$room_id, user_id: \$user_id}, where: {_and: {guest_email: {_eq: \$guest_email}, room_id: {_eq: \$room_id}}}) {
        returning {
          gender
          guest_email
          owner_name
          room_id
          user_id
        }
      }
    }
  ''';
  }

  static String deleteInvite() {
    return '''mutation DeleteInvite(\$guest_email: String!, \$room_id: Int!) {
      delete_Invite(where: {_and: {guest_email: {_eq: \$guest_email}, room_id: {_eq: \$room_id}}}) {
        returning {
          room_id
          guest_email
        }
      }
    }
  ''';
  }
}
