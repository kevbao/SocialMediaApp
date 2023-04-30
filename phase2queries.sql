CREATE TABLE Users (
user_id INT NOT NULL UNIQUE,
first_name VARCHAR[20] NOT NULL,
last_name VARCHAR[20] NOT NULL,
email VARCHAR[30] NOT NULL UNIQUE,
dob DATE NOT NULL,
hashed_pw VARCHAR[20] NOT NULL,
hometown VARCHAR[20],
gender VARCHAR[10],
PRIMARY KEY (user_id)
);

CREATE TABLE Friends (
user_id INT NOT NULL,
friend_id INT NOT NULL,
date_formed DATE NOT NULL,
PRIMARY KEY (user_id, friend_id),
FOREIGN KEY (user_id)
  REFERENCES Users(user_id),
FOREIGN KEY (friend_id)
  REFERENCES Users(user_id)
);

CREATE TABLE Albums (
album_id INT NOT NULL UNIQUE,
owner_id INT,
date_created DATE NOT NULL,
name VARCHAR[20] NOT NULL,
PRIMARY KEY (album_id),
FOREIGN KEY (owner_id)
  REFERENCES Users(user_id)
);

CREATE TABLE Photos (
photo_id INT NOT NULL UNIQUE,
caption VARCHAR[50],
data IMAGE NOT NULL,
album_id INT,
PRIMARY KEY (photo_id),
FOREIGN KEY (album_id)
  REFERENCES Albums(album_id)
  ON DELETE CASCADE
);

CREATE TABLE Likes (
user_id INT,
photo_id INT,
PRIMARY KEY (user_id, photo_id),
FOREIGN KEY (user_id)
  REFERENCES Users(user_id),
FOREIGN KEY (photo_id)
  REFERENCES Photos(photo_id)
  ON DELETE CASCADE
);

CREATE TABLE Comments (
comment_id INT NOT NULL UNIQUE,
user_id INT,
photo_id INT,
date DATE NOT NULL,
text VARCHAR[50] NOT NULL,
PRIMARY KEY (comment_id),
FOREIGN KEY (user_id) 
  REFERENCES Users(user_id),
FOREIGN KEY (photo_id) 
  REFERENCES Photos(photo_id)
  ON DELETE CASCADE
);
CREATE TABLE Tags (
tag VARCHAR[15] NOT NULL,
photo_id INT,
PRIMARY KEY (tag, photo_id),
FOREIGN KEY (photo_id)
  REFERENCES Photos(photo_id)
  ON DELETE CASCADE
);

INSERT INTO Users (user_id, first_name, last_name, dob, email, hashed_pw)
VALUES ([user_id], [first_name], [last_name], [date_of_birth], [email], [hashed_pw]);

UPDATE Users
SET [column to update] = [update value]
WHERE user_id = [user_id];

SELECT user_id, first_name, last_name
FROM Users
WHERE first_name = [name]
OR last_name = [name];

INSERT INTO Friends(user_id, friend_id, date_formed)
VALUES ([user_id], [friend_id], [today’s date]);

SELECT user_id, first_name, last_name
FROM Users
WHERE user_id IN
(SELECT friend_id
FROM Friends
WHERE user_id = [user_id])
OR user_id IN
(SELECT user_id
FROM Friends
WHERE friend_id = [user_id])
ORDER BY first_name, last_name;

SELECT u.user_id, first_name, last_name,
CASE
    WHEN nP IS NULL AND nC IS NULL THEN 0
    WHEN nP IS NULL THEN nC
    WHEN nC IS NULL THEN nP
    ELSE nP + nC
END AS Contribution
FROM Users AS u
LEFT JOIN (SELECT a.owner_id, COUNT(p.photo_id) AS nP
           FROM Albums AS a
           LEFT JOIN Photos AS p
           ON a.album_id = p.album_id
           GROUP BY a.owner_id) AS a
ON a.owner_id = u.user_id
LEFT JOIN (SELECT user_id, COUNT(comment_id) as nC
           FROM Comments AS c
           GROUP BY user_id) AS c
ON c.user_id = u.user_id
ORDER BY Contribution DESC, last_name
LIMIT 10;

SELECT user_id
FROM Users
WHERE email=[email]
AND hashed_pw=[password];

SELECT photo_id, data, caption
FROM Photos
WHERE album_id IN
(SELECT album_id
 FROM Albums
 WHERE owner_id IN
 (SELECT user_id
  FROM Users
  WHERE user_id IN
  (SELECT friend_id
   FROM Friends
   WHERE user_id = [user_id])))
ORDER BY photo_id DESC;

SELECT photo_id, data, caption
FROM Photos
WHERE album_id IN
(SELECT album_id
 FROM Albums
 WHERE owner_id = [user_id])
ORDER BY photo_id DESC;

INSERT INTO Photos (photo_id, caption, data, album_id)
VALUES ([photo_id], [caption], [image binary], [album_id]);

INSERT INTO Tags(tag, photo_id)
VALUES ([tag], [photo_id]);


INSERT INTO Albums (album_id, owner_id, date_created, name)
VALUES ([album_id], [user_id], [today’s date], [name]);

DELETE FROM Photos
WHERE photo_id = [photo_id];

SELECT owner_id
FROM Albums
WHERE album_id IN
(SELECT album_id
 FROM Photos
 WHERE photo_id = [photo_id]);

DELETE FROM Albums
WHERE album_id = [album_id];

SELECT owner_id
FROM Albums
WHERE album_id = [album_id];

SELECT photo_id, data, caption
FROM Photos
WHERE photo_id IN
(SELECT photo_id
 FROM Tags
 WHERE tag = [tag]);

SELECT tag, count(*)
FROM Tags
GROUP BY tag
ORDER BY count(*) DESC
LIMIT 10;

SELECT photo_id, data, caption
FROM Photos
WHERE photo_id IN 
(SELECT photo_id
 FROM Tags
 WHERE tag = [tag_1])
[AND photo_id IN
 (SELECT photo_id
  FROM Tags
  WHERE tag = [tag_n])...]

INSERT INTO Comments(comment_id, user_id, photo_id, date, text)
VALUES([comment_id], [user_id], [photo_id], [today’s date], [text]);

DELETE FROM Comments
WHERE comment_id = [comment_id];

INSERT INTO Likes(user_id, photo_id)
VALUES([user_id], [photo_id]);

SELECT u.user_id, first_name, last_name, nC AS numComments
FROM Users AS u
JOIN (SELECT user_id, text, COUNT(*) AS nC
           FROM Comments
           WHERE text LIKE "%[text]%"
           GROUP BY user_id) AS c
ON u.user_id = c.user_id
ORDER BY nC DESC, last_name;

SELECT u.user_id, first_name, last_name, COUNT(friend_id) as NumMutuals
FROM Users as u
JOIN Friends as f
ON u.user_id = f.user_id
WHERE friend_id IN (SELECT friend_id
                    FROM Friends
                    WHERE user_id = [user_id])
AND f.user_id NOT IN (SELECT friend_id
                      FROM Friends
                      WHERE user_id = [user_id])
AND f.user_id <> [user_id]
GROUP BY f.user_id
ORDER BY NumMutuals DESC;

SELECT p.photo_id, caption, data
FROM Photos AS p
JOIN Tags AS t
ON p.photo_id = t.photo_id
JOIN (SELECT *, COUNT(*) as totalTag
      FROM Tags
      GROUP BY photo_id
      ) as t2
ON p.photo_id = t2.photo_id
JOIN Albums AS A
ON a.album_id = p.album_id
WHERE t.tag IN (SELECT tag
              FROM Albums AS a
              JOIN Photos AS p
              ON a.album_id = p.album_id
              JOIN Tags AS t
              ON t.photo_id = p.photo_id
              JOIN Users
              ON user_id = owner_id
              WHERE user_id = [user_id]
              GROUP BY tag
              ORDER BY COUNT(p.photo_id) DESC
              LIMIT 5)
AND owner_id <> [user_id]
GROUP BY p.photo_id
ORDER BY COUNT(t.tag) DESC, totalTag;
