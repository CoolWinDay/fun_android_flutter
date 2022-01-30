
class User {

  bool admin;
  List<Object> chapterTops;
  List<Object> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String token;
  int type;
  String username;

	User.fromJsonMap(Map<String, dynamic> map): 
		admin = map["admin"],
		chapterTops = map["chapterTops"],
		collectIds = map["collectIds"],
		email = map["email"],
		icon = map["icon"],
		id = map["id"],
		nickname = map["nickname"],
		password = map["password"],
		token = map["token"],
		type = map["type"],
		username = map["username"];

	User.fromJsonMapSfcv(Map<String, dynamic> map):
				email = map["user_email"],
				nickname = map["user_display_name"],
				token = map["token"],
				username = map["user_nicename"],
				admin = map["admin"],
				chapterTops = [],
				// collectIds = map["collect_ids"],
				icon = map["icon"],
				id = map["id"],
				password = map["password"],
				type = map["type"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['admin'] = admin;
		data['chapterTops'] = chapterTops;
		data['collectIds'] = collectIds;
		data['email'] = email;
		data['icon'] = icon;
		data['id'] = id;
		data['nickname'] = nickname;
		data['password'] = password;
		data['token'] = token;
		data['type'] = type;
		data['username'] = username;
		return data;
	}
}
