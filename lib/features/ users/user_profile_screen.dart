import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    //텝바는 콘틀로러가 필요하므로 화면 전체를
    //DefaultTabController로 감싸줌, 탭은 총 2개
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        //슬리버는 스크롤뷰의 일다.
        //사용자들이 스크로할 때 사용하는 것들이다.
        slivers: [
          SliverAppBar(
            title: const Text("Yoon"),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  foregroundImage: NetworkImage(
                      "https://d1telmomo28umc.cloudfront.net/media/public/avatars/customs0529-1679985124.jpg"),
                  child: Text("Yoon"),
                ),
                Gaps.v20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "@Yoon",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size18,
                      ),
                    ),
                    Gaps.h5,
                    FaIcon(
                      FontAwesomeIcons.solidCircleCheck,
                      size: Sizes.size16,
                      color: Colors.blue.shade500,
                    ),
                  ],
                ),
                Gaps.v24,
                SizedBox(
                  //VerticalDivider는 father의 높이를 따른다.
                  //Row는 높이가 없기 때문에 SizedBox로 감싸준다.
                  height: Sizes.size48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "97",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.size18,
                            ),
                          ),
                          Gaps.v5,
                          Text(
                            "Following",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        //위젯이 차지하는 수평공간
                        width: Sizes.size32,
                        thickness: Sizes.size1,
                        color: Colors.grey.shade400,
                        //막대의 들여쓰기
                        indent: Sizes.size14,
                        endIndent: Sizes.size14,
                      ),
                      Column(
                        children: [
                          const Text(
                            "10M",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.size18,
                            ),
                          ),
                          Gaps.v3,
                          Text(
                            "Followers",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      VerticalDivider(
                        //위젯이 차지하는 수평공간
                        width: Sizes.size32,
                        thickness: Sizes.size1,
                        color: Colors.grey.shade400,
                        //막대의 들여쓰기
                        indent: Sizes.size14,
                        endIndent: Sizes.size14,
                      ),
                      Column(
                        children: [
                          const Text(
                            "194.3M",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: Sizes.size18,
                            ),
                          ),
                          Gaps.v3,
                          Text(
                            "Likes",
                            style: TextStyle(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.v14,
                //father의 너비와 높이에 의존해서 너비와 높이를 가진다.
                FractionallySizedBox(
                  widthFactor: 0.33,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: Sizes.size12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          Sizes.size4,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Follow",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Gaps.v14,
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.size32,
                  ),
                  child: Text(
                    "All highlights and where to watch live matches on FIFA+ I wonder how it would look",
                    textAlign: TextAlign.center,
                  ),
                ),
                Gaps.v14,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.link,
                      size: Sizes.size12,
                    ),
                    Gaps.h4,
                    Text(
                      "https://nomadcoders.co",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Gaps.v20,
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.black,
                    labelPadding: EdgeInsets.only(
                      bottom: Sizes.size10,
                    ),
                    labelColor: Colors.black,
                    tabs: [
                      //인디케이터의 사이즈을 늘리기 위해 패딩을 준다.
                      //왜냐면 indicatorSize: TabBarIndicatorSize.label
                      //사이즈가 레이블에 맞춰져 있기 때문이다.
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: Icon(Icons.grid_4x4_rounded),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.size20,
                        ),
                        child: FaIcon(FontAwesomeIcons.heart),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  //탭바뷰는 사이즈를 가져야 한다.
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      GridView.builder(
                        //스크롤할때는 키보드가 사라지도록
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: 20,
                        padding: const EdgeInsets.all(
                          Sizes.size6,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          //세로 갯수
                          crossAxisCount: 2,
                          //가로 간격
                          crossAxisSpacing: Sizes.size10,
                          //세로 간격
                          mainAxisSpacing: Sizes.size10,
                          //가로세로 비욜
                          childAspectRatio: 9 / 20,
                        ),
                        itemBuilder: (context, index) => Column(
                          children: [
                            //종행비율 조절위젯
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Sizes.size4,
                                ),
                              ),
                              child: AspectRatio(
                                aspectRatio: 9 / 16,
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  placeholder: "assets/images/image.jpg",
                                  image:
                                      "https://images.unsplash.com/photo-1673844969019-c99b0c933e90?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80",
                                ),
                              ),
                            ),
                            Gaps.v10,
                            const Text(
                              "This is a very long caption for my tiktok that im upload just now currently.",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: Sizes.size16 + Sizes.size2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gaps.v8,
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 12,
                                    backgroundImage: NetworkImage(
                                      "https://d1telmomo28umc.cloudfront.net/media/public/avatars/customs0529-1679985124.jpg",
                                    ),
                                  ),
                                  Gaps.h4,
                                  const Expanded(
                                    child: Text(
                                      "My avatar is going to be very long",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Gaps.v4,
                                  FaIcon(
                                    FontAwesomeIcons.heart,
                                    size: Sizes.size16,
                                    color: Colors.grey.shade600,
                                  ),
                                  Gaps.h2,
                                  const Text(
                                    "2.5M",
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Center(
                        child: Text(
                          "Page two ",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
