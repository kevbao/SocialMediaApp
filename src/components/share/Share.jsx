import "./share.css";
import {PermMedia, Label} from "@material-ui/icons"

export default function Share() {
  return (
    <div className="share">
      <div className="shareWrapper">
        <div className="shareTop">
          <img className="shareProfileImg" src="/assets/person/1.jpeg" alt="" />
          <input
            placeholder="Let's Share!"
            className="shareInput"
          />
        </div>
        <hr className="shareHr"/>
        <div className="shareBottom">
            <div className="shareOptions">
                <div className="shareOption">
                    <PermMedia htmlColor="green" className="shareIcon"/>
                    <span className="shareOptionText">Photo</span>
                </div>
                <div className="shareOption">
                    <Label htmlColor="red" className="shareIcon"/>
                    <span className="shareOptionText">Tag</span>
                </div>
            </div>
            <button className="shareButton">Share</button>
        </div>
      </div>
    </div>
  );
}
