mixin Subscription {
  static String getInfoUser = '''
    subscription userUpdated(\$id: String!) {
      User(where: {id: {_eq: \$id}}) {
        email
        gender
        money
        name
        id
        user_skin_id
        badges
        is_premium
      }
    }
  ''';

  static String listenInvite = '''
    subscription listenInvite(\$guest_email: String!) {
      Invite(where: {_and: {guest_email: {_eq: \$guest_email}}}) {
        guest_email
        room_id
        user_id
        owner_name
        gender
      }
    }
  ''';

  static String inviteAdded = '''
    subscription inviteAdded(\$guest_email: String!, \$room_id: Int!) {
      Invite(where: {_and: {guest_email: {_eq: \$guest_email}, room_id: {_eq: \$room_id}}}) {
        guest_email
        room_id
        user_id
        owner_name
        gender
      }
    }
  ''';

  static String listenRoomMember = '''
    subscription listenRoomMember(\$room_id: Int!) {
      RoomMember(where: {room_id: {_eq: \$room_id}}, order_by: {id: asc}) {
        avatar
        name
        user_id
      }
    }
  ''';

  static String listenListGroup = '''
    subscription listenListGroup(\$user_id: String!) {
      RoomMember(where: {user_id: {_eq: \$user_id}}) {
        owner_group_id
        user_id
        room_id
        name
        avatar
      }
    }
  ''';
}
