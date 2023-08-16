import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// admin 초기화
admin.initializeApp();

// 콜렉션>도큐먼트>필드
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
    // await snapshot.ref.update({ hello: "from functions" });
    // 아래의 코드가 ffmpeg를 사용할 수 있게 해준다.
    const spawn = require("child-process-promise").spawn;
    // snapshot에는 ref도 있고 data도 있다.
    // 이렇게 하면 갓 데이터베이스에 업로드된 데이터를 준다.
    // 이렇게 하면서 필드의 데이터들을 받아온다.
    const video = snapshot.data();
    await spawn("ffmpeg", [
      // 입력파일을 나타내는 옵션이다.
      "-i",
      // 입력파일의 Url주소 ffmpeg가 비디오파일을 다운로드 한다.
      video.fileUrl,
      // 영상의 특정시간으로 이동하기 위한 옵션이다.
      "-ss",
      "00:00:01.000",
      // 추출할 비디오 프레임의 개수를 지정하는 옵션
      "-vframes",
      "1",
      // 비디오 필터링 옵션으로, 영상의 크기를 조절하는데 사용
      "-vf",
      // ffmpeg가 영상 비율에 맞춰서 높이를 설정한다는 뜻이다.
      // 가로 크기를 150 픽셀로 고정하고, 세로 크기는 비율에 맞추어 자동으로 조절
      "scale=150:-1",
      // 추출된 프레임이 임시로 저장될 파일 경로
      `/tmp/${snapshot.id}.jpg`,
    ]);
    const storage = admin.storage();
    const [file, _] = await storage.bucket().upload(`/tmp/${snapshot.id}.jpg`, {
      destination: `thumbnails/${snapshot.id}.jpg`,
    });
    await file.makePublic();
    await snapshot.ref.update({ thumbnailUrl: file.publicUrl() });

    const db = admin.firestore();

    await db
      .collection("users")
      .doc(video.creatorUid)
      .collection("videos")
      // {videoId}의 값을 가져온다.
      .doc(snapshot.id)
      .set({
        thumbnailUrl: file.publicUrl(),
        videoId: snapshot.id,
      });
  });

// /videos/123
// /users/nico/videos/123

export const onLikedCreated = functions.firestore
  .document("likes/{likeId}")
  // {likeId}가 생성될 때 발동되는 함수
  .onCreate(async (snapshot, contest) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");

    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(1),
      });

    const videoSnapshot = await db.collection("videos").doc(videoId).get();
    const thumbnailUrl = videoSnapshot.data()!.thumbnailUrl;
    const createdAt = videoSnapshot.data()!.createdAt;

    await db
      .collection("users")
      .doc(userId)
      .collection("likedVideos")
      .doc(videoId)
      .set({
        thumbnailUrl: thumbnailUrl,
        videoId: videoId,
        createdAt: createdAt,
      });
  });

export const onLikedRemoved = functions.firestore
  .document("likes/{likeId}")
  // {likeId}가 제거될 때 발동되는 함수
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [videoId, userId] = snapshot.id.split("000");
    await db
      .collection("videos")
      .doc(videoId)
      .update({
        likes: admin.firestore.FieldValue.increment(-1),
      });
    await db
      .collection("users")
      .doc(userId)
      .collection("likedVideos")
      .doc(videoId)
      .delete();
  });

export const onChatRoomRemoved = functions.firestore
  .document("chat_rooms/{chatRoomId}")
  .onDelete(async (snapshot, context) => {
    const db = admin.firestore();
    const [personA, personB] = snapshot.id.split("000");

    const chatRoomId = snapshot.id;

    await db
      .collection("users")
      .doc(personA)
      .collection("myChatRooms")
      .doc(chatRoomId)
      .delete();

    await db
      .collection("users")
      .doc(personB)
      .collection("myChatRooms")
      .doc(chatRoomId)
      .delete();
  });
