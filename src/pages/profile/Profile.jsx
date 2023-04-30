import "./profile.css";
import Topbar from "../../components/topbar/Topbar";
import Sidebar from "../../components/sidebar/Sidebar";
import Feed from "../../components/feed/Feed";

export default function Profile() {
  return (
    <>
      <Topbar />
      <div className="profile">
        <Sidebar />
        <div className="profileRight">
          <div className="profileRightTop">
            <div className="profileCover">
              <img
                className="profileCoverImg"
                src="assets/post/14.jpeg"
                alt=""
              />
              <img
                className="profileUserImg"
                src="assets/person/1.jpeg"
                alt=""
              />
            </div>
            <div className="profileInfo">
                <h4 className="profileInfoName">Sarah Lee</h4>
                <span className="profileInfoDesc">Hey Everyone!</span>
            </div>
          </div>
          <div className="profileRightBottom">
            <Feed />
          </div>
        </div>
      </div>
    </>
  );
}
