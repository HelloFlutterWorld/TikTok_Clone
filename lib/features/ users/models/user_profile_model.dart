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

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.bio,
    required this.link,
  });

  UserProfileModel.empty()
      : uid = "",
        email = "",
        name = "",
        bio = "",
        link = "";

  Map<String, String> toJson() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "bio": bio,
      "link": link,
    };
  }
}
