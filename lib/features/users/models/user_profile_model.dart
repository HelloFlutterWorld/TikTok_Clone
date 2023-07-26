class UserProfileModel {
// firebase auth는 현재 로그인한 유저에 대한 정보만 준다
// 로그인한 유저의 이름, 사진, 이메일 같은 것들을 준다.
// 근데, 어떤 유저가 다른 유저의 프로필을 방문할 수 있는 페이지가 있는 경우,
// 거기건  firebase auth를 사용할 수 없기 때문에,
// 그런건 데이터베이스(fireStror)에 있어야 한다.

  final String uid;
  final String email;
  final String name;
  final String bio;
  final String link;
  final String birthday;
  final bool hasAvater;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
    required this.birthday,
    required this.hasAvater,
  });

  UserProfileModel.empty()
      : hasAvater = false,
        uid = "",
        email = "",
        name = "",
        bio = "",
        link = "",
        birthday = "";

  UserProfileModel.fromJson(Map<String, dynamic> json)
      : hasAvater = json["hasAvatar"],
        uid = json["uid"],
        email = json["email"],
        name = json["name"],
        bio = json["bio"],
        link = json["link"],
        birthday = json["birthday"];

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
      "birthday": birthday,
    };
  }

  UserProfileModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? bio,
    String? link,
    String? birthday,
    bool? hasAvater,
  }) {
    return UserProfileModel(
      // uid는 파라미터로 받은 것, this.uid는 원래 갖고 있던 것
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      birthday: birthday ?? this.birthday,
      hasAvater: hasAvater ?? this.hasAvater,
    );
  }
}
