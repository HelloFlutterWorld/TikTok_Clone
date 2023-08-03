import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// admin 초기화
admin.initializeApp();

// firestore 뿐만 아니라, storage이벤트, authentication도 listen할 수 있다.
export const onVideoCreated = functions.firestore
   // document에 listen할 데이터베이스 경로를 입력한다.
   // 중괄호를 사용하면 변수처럼 작동한다.
   // 따라서 영상의 ID가 바뀔 때마다, 즉 새로운 영상이 업로드될 때마다 알림을 받는다.
  .document("videos/{videoId}")
  // snapshot는 생성된 도큐먼트다, 
  // context는 어떤 도큐먼트(videoId의 정보)가 생성되었지를 나타낸다.
  .onCreate(async (snapshot, context) => {
    // ref는 document로 접근하게 해준다.
    await snapshot.ref.update({ hello: "from functions" });
  });   