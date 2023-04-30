import "./sidebar.css";
import {
  RssFeed,
  PhotoLibrary,
  People
} from "@material-ui/icons";
import { Users } from "../../database";
import CloseFriend from "../closeFriend/CloseFriend";

export default function Sidebar() {
  return (
    <div className="sidebar">
      <div className="sidebarWrapper">
        <ul className="sidebarList">
          <li className="sidebarListItem">
            <RssFeed className="sidebarIcon" />
            <span className="sidebarListItemText">Feed</span>
          </li>
          <li className="sidebarListItem">
            <PhotoLibrary className="sidebarIcon" />
            <span className="sidebarListItemText">Albums</span>
          </li>
        </ul>
        <hr className="sidebarHr" />
        <ul className="sidebarFriendList">
        <h4 className="sidebarFriendList">Friends</h4>
          {Users.map((u) => (
            <CloseFriend key={u.id} user={u} />
          ))}
        </ul>
      </div>
    </div>
  );
}
