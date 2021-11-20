mixin Queries {
  static String getGender = '''
    query getGender(\$id: String!) {
      User(where: {id: {_eq: \$id}}) {
        gender
      }
    }
  ''';
  static String getHistories = '''
    query getHistories(\$user_id: String!) {
      RunHistory(order_by: {date: desc}, where: {user_id: {_eq: \$user_id}}) {
        id
        avg
        date
        distance
        image
        imageUrl
        steps
        time
        user_id
      }
    }
  ''';
  static String getInfoUser = '''
    query getUser(\$id: String!) {
      User(where: {id: {_eq: \$id}}) {
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
  ''';

  static String getGoal = '''
    query getGoal(\$user_id: String!) {
      Goal(where: {user_id: {_eq: \$user_id}}) {
        step
        time
        distance
      }
    }
  ''';

  static String get7DaysHistories = '''
   query get7DaysHistories(\$user_id: String!, \$date: timestamp!) {
      RunHistory(order_by: {date: desc}, where: {user_id: {_eq: \$user_id}, date: {_gte: \$date}}) {
        avg
        date
        distance
        id
        steps
        time
        user_id
      }
    }
  ''';

  static String getSumDistanceToday = '''
    query getSumDistanceToday(\$user_id: String!, \$date: timestamp!) {
      RunHistory_aggregate(where: {_and: {user_id: {_eq: \$user_id}, date: {_gte: \$date}}}) {
        aggregate {
          sum {
            distance
            steps
          }
        }
      }
    }
    ''';

  static String getRewardDaily = '''
   query getDailyReward(\$user_id: String!) {
      DailyReward(where: {user_id: {_eq: \$user_id}}) {
        days_row
        current_daily
      }
    }
  ''';

  static String getAllBadges = '''
    query getAllBadges {
      Badges {
        id
        subtitle
        title
        level
      }
    }
  ''';
  static String getUserByEmail = '''
    query getUserByEmail(\$email: String!) {
      User(where: {email: {_eq: \$email}}) {
        email
        id
        name
        avatar
      }
    }
  ''';

  static String getRoomById = '''
    query GetRoom(\$id: Int = "") {
      Room(where: {id: {_eq: \$id}}) {
        user_id
        id
      }
    }
  ''';
  static String getListGroup = '''
    query getListGroup(\$user_id: String!) {
      RoomMember(where: {user_id: {_eq: \$user_id}}) {
        owner_group_id
        user_id
        room_id
        name
        avatar
      }
    }
  ''';

  static String getGroup = '''
    query getGroup(\$id: Int!) {
      Room(where: {id: {_eq: \$id}}) {
        user_id
        id
        name_room
      }
    }
  ''';

  static String getRoomMember = '''
    query getRoomMember(\$room_id: Int!) {
      RoomMember(where: {room_id: {_eq: \$room_id}}, order_by: {id: asc}) {
        avatar
        name
        user_id
        owner_group_id
      }
    }
  ''';

  static String getSumDistanceAndSteps = '''
    query GetSumDistanceAndSteps(\$user_id: String = "", \$date: timestamp = "") {
      RunHistory_aggregate(where: {_and: {user_id: {_eq: \$user_id}, date: {_gte: \$date}}}) {
        aggregate {
          sum {
            distance
            steps
          }
        }
      }
    }
  ''';
}
