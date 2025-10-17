PRAGMA defer_foreign_keys=TRUE;
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    salt TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('viewer', 'controller')),
    game_instance_id TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "users" VALUES(1,'RCCFHOZ','6c00af79f1f05b1038bc4a15d13bdc4865b9688ad24d0412466d6c26870d248d2f46bd597d9422e4ec48251bf5bb1a0a13396a836e75b7f126e5eb7871b3ac94','d596030f496ecef9a9a2ed3ad9be3c090498af3d6d9cdcdc962f9f7bbc93f0e3','controller','7a7ae338-6d6c-420b-a91e-a811e3a4da4c','2025-10-16 05:03:40');
INSERT INTO "users" VALUES(2,'RCCFHOZ1','7595306cd2648020b3a0529b4896a6f0a48d50dd8de25ef31eeb8808aced46ff4b1dcfd738361a46610cd47abc6489273458a3a5210ce93ce830f717984bf4c5','c33af4451102d7f306bf4c921694d642c78ca671613f4ce8a32a74ad615aacfa','viewer','7a7ae338-6d6c-420b-a91e-a811e3a4da4c','2025-10-16 05:03:41');
INSERT INTO "users" VALUES(3,'controller2','0c394fd5f0e3cf5b5de1d0e2b38b02c80c94c60f4ffd5e505d659dc3e15d98f9af006ad013630136735dacb8b9e62ca93e7cb1413e8c673e686d4203e5efe53c','17ecb44d4444ce258f02584a9a3720c6e6de180331c6d1b104c56cfe985d8a3d','controller','0d656d42-a765-48a4-b68a-954f36d7be44','2025-10-16 05:03:42');
INSERT INTO "users" VALUES(4,'viewer2','a44058fade6570e2361d1f9b693b4b9d3442d94d487af16249e0b0eb292b5563f156293f03dfa8d27ad4e8287ba01f78c035cec5c91ae41cca0d92584aed87d7','55691aa4aa303de01b10b24ca4ee3fc3db5124be0693559879f889d16e5a57df','viewer','0d656d42-a765-48a4-b68a-954f36d7be44','2025-10-16 05:03:43');
INSERT INTO "users" VALUES(5,'test','60970fa5dc2463e7b30544242adafed563f2b1a214d23bc2e4b9b1de75878a56cbdfd192c09d7d01f41aaba955f42ac12fd62f4469e3f7ef56739bb9b5b97742','2c767c61c989437cfd96b1767b5ff69de42553ba08e2ff3f5191e7df28133b37','controller','f649c7ad-6aa9-47ec-9b82-e37c18099840','2025-10-16 08:27:47');
INSERT INTO "users" VALUES(6,'testv','cdea3dc7d7e1cf073c96472e1608efe889468b837ce43ff7eb3e3c05d76fed7891c03bf397e6a1fdaf4df20ec49aa9fa82f7bd5beeaff45dfa55b83d2f357606','f9d35ab9b380bacbf4317d76cda5cb4ec2a5891996b0255577ece604915d21b6','viewer','f649c7ad-6aa9-47ec-9b82-e37c18099840','2025-10-16 08:27:48');
INSERT INTO "users" VALUES(7,'test2','2f20740757174387130f1286db08d929558aa4c1de3a93b7b2ca1f8201b7d480219c73230483db744a86a705d6167bf472f81179d85880ab5e9d0ae2940e2f6e','fefe093157466f5575bf51120d3ac9604e271a4e0e011867844eaf9738e94de8','controller','82dfc467-107e-4200-9fcc-a4bc5d9a3f06','2025-10-16 08:27:49');
INSERT INTO "users" VALUES(8,'test2v','0455a768b4d0be1912afbdf4222b0ebd7e782378d6091f27dca89844d391e5446fa93a1d9145e5ca717b4a6d734d883e6a344684bc24c6fb14c0f10663af7858','8fda2669f3c7375c13ae424caa1cad17006838e5218ccf261bd77171cd39ec82','viewer','82dfc467-107e-4200-9fcc-a4bc5d9a3f06','2025-10-16 08:27:50');
CREATE TABLE sessions (
    id TEXT PRIMARY KEY,
    user_id INTEGER NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
INSERT INTO "sessions" VALUES('61219872-8b91-47e0-8db9-798a9fa6a147',5,'2025-10-17T00:01:42.343Z','2025-10-16 16:49:51');
INSERT INTO "sessions" VALUES('383810b9-ddf0-4938-aa0c-d862e9ecaaff',6,'2025-10-17T00:03:26.862Z','2025-10-16 16:25:52');
INSERT INTO "sessions" VALUES('b49c4086-0f44-415f-8485-d604e2143c63',6,'2025-10-17T01:11:07.310Z','2025-10-16 18:35:40');
INSERT INTO "sessions" VALUES('a5b9fa85-6d1d-4add-8b46-6f16148d6f0f',5,'2025-10-17T02:30:55.353Z','2025-10-16 19:11:28');
INSERT INTO "sessions" VALUES('ece02fcd-1555-4814-9896-c9cbb83d99da',6,'2025-10-17T02:52:12.947Z','2025-10-16 20:22:11');
INSERT INTO "sessions" VALUES('ba498440-585d-40ad-ab1f-65e1fdb8a81a',5,'2025-10-17T03:11:28.738Z','2025-10-16 19:59:46');
INSERT INTO "sessions" VALUES('ac43ec7e-c8f9-41d9-a900-bfc88c940491',6,'2025-10-17T03:59:26.419Z','2025-10-16 20:04:37');
INSERT INTO "sessions" VALUES('7a753b86-7526-41b1-8414-56b6627b6f53',5,'2025-10-17T03:59:50.411Z','2025-10-16 19:59:51');
INSERT INTO "sessions" VALUES('053822ea-ce6e-4ee7-9d91-916fa0ce2ad3',6,'2025-10-17T04:00:13.745Z','2025-10-16 20:03:22');
INSERT INTO "sessions" VALUES('774850bb-52ec-4512-bb65-feb0a50a4031',5,'2025-10-17T04:05:37.990Z','2025-10-16 20:13:15');
INSERT INTO "sessions" VALUES('f8f387c3-48f9-44e8-8d6f-488e23824b0c',5,'2025-10-17T04:22:15.210Z','2025-10-16 20:37:37');
INSERT INTO "sessions" VALUES('21825afe-24cb-47a1-9023-35778331d903',5,'2025-10-17T12:57:29.181Z','2025-10-17 06:50:03');
INSERT INTO "sessions" VALUES('9bafea3c-6b02-42da-8880-2866ba620c74',5,'2025-10-17T12:59:31.552Z','2025-10-17 05:09:20');
INSERT INTO "sessions" VALUES('e80072cf-61e8-4ee6-b95b-e4d39ac30773',6,'2025-10-17T13:09:02.428Z','2025-10-17 06:49:08');
INSERT INTO "sessions" VALUES('778f5d29-ca8f-4308-a5b5-f292fd032020',5,'2025-10-17T14:07:47.656Z','2025-10-17 06:17:41');
INSERT INTO "sessions" VALUES('55112da9-78c3-4af6-80ad-b9f9d82241ef',5,'2025-10-17T14:20:17.282Z','2025-10-17 06:49:55');
CREATE TABLE questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT NOT NULL,
    question_type TEXT NOT NULL CHECK(question_type IN ('quiz', 'recitation', 'character')),
    question_number INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    answer TEXT NOT NULL,
    hint_1 TEXT,
    hint_2 TEXT,
    hint_3 TEXT,
    hint_4 TEXT,
    points INTEGER DEFAULT 5,
    bonus_points INTEGER DEFAULT 2,
    bonus_hint_points INTEGER DEFAULT 1,
    imported_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_instance_id, question_type, question_number)
);
INSERT INTO "questions" VALUES(219,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',1,'His disobedience brought sin and mortality into human existence','Adam','Named every animal in the Garden before any woman was created','Was given a single command concerning the Tree of the Knowledge of Good and Evil','First man created by God',NULL,5,2,1,'2025-10-16 18:12:01');
INSERT INTO "questions" VALUES(220,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',2,'Created from her husband''s rib as a companion and equal partner','Eve','Persuaded by the serpent to eat the forbidden fruit','Named "the mother of all living" after leaving the Garden','First woman created by God',NULL,5,2,1,'2025-10-16 18:12:01');
INSERT INTO "questions" VALUES(221,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',3,'Preserved his family and all creatures from a worldwide flood','Noah','Endured ridicule for his faith during the building years','Offered burnt sacrifices of thanksgiving after the waters receded','Built a massive ark',NULL,5,2,1,'2025-10-16 18:12:01');
INSERT INTO "questions" VALUES(222,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',4,'Received a covenant symbolised by circumcision','Abraham','Stood ready to sacrifice Isaac before an angel stopped him','Welcomed three mysterious visitors who foretold his son''s birth','Left his homeland for God''s promise',NULL,5,2,1,'2025-10-16 18:12:01');
INSERT INTO "questions" VALUES(223,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',5,'Waited decades for a promised child despite barrenness','Sarah','Laughed when told she would bear a son in old age','Bore Isaac and demanded the dismissal of Hagar and Ishmael','Wife of Abraham',NULL,5,2,1,'2025-10-16 18:12:01');
INSERT INTO "questions" VALUES(224,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',6,'Escaped the destruction of Sodom with his daughters','Lot','Offered hospitality to two heavenly visitors','His wife turned into a pillar of salt for looking back','Travelled with his uncle Abraham before settling near Sodom',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(225,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',7,'Married Rebekah','Isaac','Carried wood for his own near-sacrifice on Mount Moriah','Was deceived by his son Jacob into giving away Esau''s blessing','Son of Abraham and Sarah',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(226,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',8,'Left her family immediately to marry Isaac','Rebekah','Received a prophecy about her twins struggling within her womb','Schemed for Jacob to receive his father''s final blessing','Drew water for a stranger''s camels marking divine selection',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(227,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',9,'Deceived his father to obtain the elder son''s blessing','Jacob','Saw a heavenly ladder in a dream at Bethel','Wrestled a divine being and was renamed "Israel."','Twin brother of Esau',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(228,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',10,'Sold his birthright for a meal of lentil stew','Esau','Lost his father''s blessing through his brother''s deceit','Forgave Jacob after years of separation and anger','Firstborn of Isaac known for red hair and hunting skill',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(229,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',11,'Dreamed of ruling over his brothers','Joseph (Son of Jacob)','Sold into slavery but rose to power in Egypt','Saved nations from famine through wise grain storage','Favoured with a coat of many colours',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(230,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',12,'Spoke with God through a burning bush','Moses','Led Israel out of Egypt through parted waters','Received the Ten Commandments atop Mount Sinai','Found in a basket among the reeds of the Nile',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(231,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',13,'Became the first high priest of Israel','Aaron','Fashioned a golden calf at the people''s demand','Carried a staff that budded as a divine sign','Older brother of Moses',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(232,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',14,'Commanded the sun to stand still','Joshua','Led the fall of Jericho through faith and marching','Divided the Promised Land among the tribes','Successor to Moses',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(233,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',15,'One of twelve spies sent into Canaan','Caleb','Along with Joshua urged faith instead of fear','Lived to claim the hill country promised to him','Represented courage and steadfast trust in divine promises',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(234,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',16,'Tore a lion apart with his bare hands','Samson','Fell for Delilah who betrayed his secret','Died destroying the Philistine temple in his final act','A Nazarite whose strength came from uncut hair',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(235,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',17,'Gleaned grain in Boaz''s field','Ruth','Lay at Boaz''s feet in a gesture of honour and request','Became the great-grandmother of King David','A Moabite widow loyal to her mother-in-law',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(236,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',18,'Vowed to dedicate her child entirely to God','Hannah','Mother of Samuel whom she delivered to Eli the priest','Praised God with a prophetic song of thanksgiving','Wept in the temple over her barrenness',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(237,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',19,'Heard God''s voice as a boy','Samuel','Anointed both Saul and David as kings','Rebuked Israel for their demand for a human ruler','Born through Hannah''s prayer',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(238,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',20,'Stood head and shoulders above others','Saul (King)','Anointed as Israel''s first monarch','Disobeyed divine instructions and lost divine favour','Died on the battlefield falling upon his own sword',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(239,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',21,'Son of King Saul and loyal friend to David','Jonathan','Displayed courage by attacking a Philistine outpost','Protected David from his father''s jealousy','Died beside Saul in battle against the Philistines',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(240,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',22,'Defeated a giant with a sling','David','Played the harp to soothe King Saul','Became Israel''s greatest king and psalmist','Sinned with Bathsheba but repented deeply',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(241,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',23,'Judged between two women claiming one child','Solomon','Built the first Temple in Jerusalem','Wrote Proverbs Ecclesiastes and the Song of Songs','Granted wisdom by divine gift',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(242,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',24,'Confronted prophets of Baal','Elijah','Called down fire from heaven on Mount Carmel','Fled into the wilderness and heard God in a gentle whisper','Ascended to heaven in a whirlwind with a fiery chariot',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(243,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',25,'Succeeded Elijah as prophet','Elisha','Purified a poisoned spring','Healed Naaman the Syrian of leprosy','Raised a Shunammite woman''s son from death',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(244,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',26,'A righteous man from Uz','Job','Lost his children possessions and health','Maintained faith though questioned by friends and wife','Was restored to greater prosperity after divine vindication',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(245,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',27,'A Jewish orphan raised by Mordecai','Esther','Chosen as queen for her beauty','Risked her life approaching the king uninvited','Instituted the festival of Purim to commemorate deliverance',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(246,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',28,'Guardian of Queen Esther','Mordecai','Exposed a plot to assassinate the king','Refused to bow to Haman provoking conflict','Became second in command after Haman''s downfall',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(247,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',29,'Taken captive to Babylon','Daniel','Interpreted Nebuchadnezzar''s dreams','Survived a night in a lions'' den','Maintained prayer discipline despite royal decrees',NULL,5,2,1,'2025-10-16 18:12:02');
INSERT INTO "questions" VALUES(248,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',30,'Friend of Daniel in Babylon','Shadrach','Refused to bow to the image','Cast into a blazing furnace with companions','Emerged unharmed protected by a divine presence',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(249,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',31,'Companion of Shadrach and Abednego','Meshach','Rejected idol worship','Witnessed divine intervention inside the fiery furnace','Became a symbol of steadfast faith under pressure',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(250,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',32,'Hebrew captive with Daniel','Abednego','Preferred death to disobedience','Escaped the flames without a single burn','His courage inspired generations of exiles',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(251,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',33,'Cupbearer to King Artaxerxes','Nehemiah','Received permission to rebuild Jerusalem''s walls','Faced mockery and threats from Sanballat and Tobiah','Restored the city''s defences through leadership and prayer',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(252,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',34,'Priest and scribe of the Law','Ezra','Led exiles back to Jerusalem','Restored temple worship','Enforced reform opposing intermarriage',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(253,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',35,'Prophet swallowed by a fish','Jonah','Fled from God''s command to go to Nineveh','Prayed from inside the great fish','Resented God''s mercy on repentant Nineveh',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(254,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',36,'Married an unfaithful woman','Hosea','Named his children with prophetic meanings','Preached divine love despite betrayal','Prophet symbolising Israel''s unfaithfulness',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(255,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',37,'Called by an angel while threshing wheat','Gideon','Tested God with a fleece','Defeated Midianites with only 300 men','Refused kingship acknowledging divine sovereignty',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(256,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',38,'Female leader of Israel','Deborah','Prophetess and judge under the palm tree','Directed Barak to battle against Sisera','Composed a victory song celebrating divine deliverance',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(257,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',39,'Commander who hesitated without her','Barak','Led Israel''s army with Deborah','Witnessed Sisera''s defeat through divine storm','Honoured among heroes of faith',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(258,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',40,'Wife of Heber the Kenite','Jael','Offered Sisera refuge after battle','Killed Sisera by driving a tent peg through his temple','Praised by Deborah',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(259,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',41,'Outcast warrior called to defend Israel','Jephthah','Made a rash vow','Defeated the Ammonites through divine aid','Remembered for victory mixed with grief',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(260,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',42,'Faithful king of Judah','Hezekiah','Destroyed idols and restored worship','Prayed for deliverance from Assyria','Granted fifteen extra years of life through divine mercy',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(261,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',43,'Child king of Judah','Josiah','Discovered the Book of the Law','Purged the land of idolatry','Died in battle against Pharaoh Neco',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(262,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',44,'Sidonian queen married to Ahab','Jezebel','Introduced Baal worship','Persecuted prophets of the Lord','Died violently devoured by dogs',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(263,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',45,'King of Israel husband of Jezebel','Ahab','Oft rebuked by Elijah','Coveted Naboth''s vineyard','Died from a random arrow despite disguise',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(264,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',46,'Syrian commander with leprosy','Naaman','Visited Elisha on a servant girl''s advice','Was told to wash in the Jordan','Healed completely after washing seven times',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(265,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',47,'Prophet called in youth','Jeremiah','Warned Judah of exile','Imprisoned and thrown into a cistern','Wrote Lamentations mourning Jerusalem''s fall',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(266,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',48,'Priest turned prophet in exile','Ezekiel','Saw visions of wheels and creatures','Lay on his side to symbolise sin','Prophesied dry bones returning to life',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(267,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',49,'Saw a vision of God''s throne','Isaiah','Predicted the birth of Emmanuel','Walked barefoot as a prophetic sign','Spoke of a suffering servant who would redeem many',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(268,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',50,'Name means "The Lord remembers"','Zechariah (Prophet)','Encouraged rebuilding of the temple','Saw visions of lampstands and scrolls','Prophesied a humble king on a donkey',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(269,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',51,'Ended with warning of judgment','Malachi','Last prophet before centuries of silence','Denounced corrupt priests','Predicted a messenger to prepare the way',NULL,5,2,1,'2025-10-16 18:12:03');
INSERT INTO "questions" VALUES(270,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',52,'Mother of Jesus','Mary (Mother of Jesus)','Visited by Gabriel with news of conception','Pondered prophecies about her child''s destiny','Present at the wedding in Cana and at the Cross',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(271,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',53,'Descendant of David from Nazareth','Joseph (Husband of Mary)','Sought to divorce Mary quietly','Obeyed angelic instructions to protect the child','Fled with family to Egypt to escape Herod',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(272,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',54,'Born to Zechariah and Elizabeth','John the Baptist','Lived in the wilderness','Baptised multitudes in Jordan','Beheaded for condemning Herod''s sin',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(273,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',55,'Fisherman called from Galilee','Peter','Walked on water briefly','Denied Christ three times','Became a bold preacher after Pentecost',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(274,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',56,'Brother of Peter and first disciple','Andrew','Introduced Peter to Jesus','Present at the feeding of five thousand','Crucified on an X-shaped cross according to tradition',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(275,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',57,'Brother of John the Apostle','James (Son of Zebedee)','One of the "sons of thunder"','Witnessed the Transfiguration','First apostolic martyr executed by Herod',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(276,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',58,'Disciple whom Jesus loved','John (The Apostle)','Wrote the Gospel of John','Cared for Mary after the Crucifixion','Exiled on Patmos where he saw visions',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(277,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',59,'Doubted the resurrection','Thomas','Invited by Christ to touch His wounds','Declared "My Lord and my God"','Later evangelised regions as far as India',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(278,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',60,'Tax collector turned disciple','Matthew','Fed Jesus at his banquet','Wrote a Gospel emphasising prophecy','Martyred while preaching abroad',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(279,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',61,'Disciple from Bethsaida','Philip','Tested by Jesus on feeding the crowd','Led an Ethiopian official to faith','Invited Nathanael to the Messiah',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(280,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',62,'Apostle also called Nathanael','Bartholomew','Praised as a man without deceit','Witnessed Christ''s miracles','Died a martyr for the Gospel',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(281,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',63,'Delivered from seven demons','Mary Magdalene','Present at His crucifixion and burial','First to witness the resurrected Christ','Commissioned to tell the disciples He had risen',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(282,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',64,'Sister of Mary and Lazarus','Martha','Welcomed Jesus into her home','Questioned Him about her brother''s death','Heard Jesus proclaim "I am the resurrection"',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(283,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',65,'Beloved friend of Jesus','Lazarus','Fell ill and died before Jesus arrived','Restored to life after four days','His resurrection caused many to believe',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(284,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',66,'Wealthy tax collector from Jericho','Zacchaeus','Climbed a sycamore tree','Welcomed Jesus joyfully','Repented and vowed to repay wrongs',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(285,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',67,'Pharisee who visited Jesus by night','Nicodemus','Heard about being born again','Defended Jesus before his peers','Helped prepare the body for burial',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(286,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',68,'Devoted sister of Lazarus','Mary of Bethany','Sat at Jesus'' feet','Anointed His feet with perfume','Her act foreshadowed His burial',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(287,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',69,'Council member awaiting God''s kingdom','Joseph of Arimathea','Secret follower of Jesus','Requested His body from Pilate','Laid Jesus in his own tomb',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(288,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',70,'First Christian martyr','Stephen','One of seven chosen to serve','Preached before the Sanhedrin','Saw a vision of Christ standing at God''s right hand',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(289,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',71,'Former persecutor of Christians','Paul (Saul of Tarsus)','Converted on Damascus road','Undertook missionary journeys','Authored many letters shaping doctrine',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(290,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',72,'Levite called "son of encouragement"','Barnabas','Introduced Paul to the apostles','Partnered in missionary journeys','Advocated forgiveness in church conflict',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(291,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',73,'Trusted missionary companion','Silas','Imprisoned in Philippi singing hymns','Freed by an earthquake that opened the prison','Partnered with Paul',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(292,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',74,'Young disciple with Jewish mother','Timothy','Trained by Paul','Served as overseer in Ephesus','Commended for faith taught by Lois',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(293,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',75,'Greek convert and companion of Paul','Titus','Organised churches in Crete','Delivered letters of reconciliation','Known for dependable leadership',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(294,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',76,'Wealthy believer from Colossae','Philemon','Hosted a church at home','Received Paul''s appeal on his servant','Remembered for forgiveness',NULL,5,2,1,'2025-10-16 18:12:04');
INSERT INTO "questions" VALUES(295,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',77,'Escaped servant who met Paul','Onesimus','Converted in prison','Returned voluntarily to Philemon','Later served as a minister',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(296,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',78,'Roman centurion from Caesarea','Cornelius','Noted for generosity and prayer','Received a vision to summon Peter','First recorded Gentile convert',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(297,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',79,'Merchant of purple cloth','Lydia','Worshipped God before hearing the Gospel','Hosted Paul after conversion','Her house became a gathering place',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(298,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',80,'Early believers who sold property','Ananias and Sapphira','Lied about their offering','Confronted by Peter for lying','Died instantly for deceit',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(299,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',81,'Tentmaking married couple','Priscilla and Aquila','Worked with Paul','Taught Apollos accurately','Known for theological precision',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(300,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',82,'Jewish scholar of Scripture','Apollos','Eloquent teacher from Alexandria','Mentored by Priscilla and Aquila','Became influential in Corinthian churches',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(301,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',83,'Paranoid Judean ruler','Herod the Great','King during Jesus'' birth','Ordered massacre of Bethlehem''s infants','Renovated the Second Temple with splendour',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(302,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',84,'Son of Herod the Great','Herod Antipas','Imprisoned John the Baptist','Mocked Jesus before crucifixion','Banished later by Rome',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(303,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',85,'Roman governor at the trial','Pontius Pilate','Declared Him innocent','Washed his hands of Jesus'' fate','His name appears in the Christian creed',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(304,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',86,'High priest opposing Jesus','Caiaphas','Said one man should die for people','Presided over nocturnal trial','Instrumental in handing Jesus to Rome',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(305,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',87,'Prisoner freed at Passover','Barabbas','Rebel and murderer','Released instead of Jesus','Symbolised substitutionary release from guilt',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(306,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',88,'Traveller on crucifixion road','Simon of Cyrene','Compelled to carry the cross','Originated from North Africa','Father of Alexander and Rufus',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(307,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',89,'Roman officer at crucifixion','The Centurion at the Cross','Supervised the execution','Witnessed the darkness and earthquake','Declared "Truly this was the Son of God"',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(308,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',90,'Met Jesus at Jacob''s well','The Samaritan Woman','Surprised by His request for water','Learned of living water','Evangelised her town after encounter',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(309,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',91,'Helped a wounded man','The Good Samaritan','Ignored by priest and Levite','Cared for the victim''s wounds','Exemplified mercy surpassing prejudice',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(310,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',92,'Approached Jesus seeking eternal life','The Rich Young Ruler','Claimed lifelong obedience','Went away sorrowful when told to sell','Embodied the struggle between faith and wealth',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(311,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',93,'Practised magic in Samaria','Simon the Sorcerer','Tried to buy the Spirit''s power','Rebuked sharply by Peter','His name later symbolised "simony"',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(312,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',94,'Young man in Troas','Eutychus','Fell asleep during Paul''s sermon','Fell from an upper window and died','Restored to life through Paul''s embrace',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(313,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',95,'Once a co-worker of Paul','Demas','Deserted the mission for worldly interests','Mentioned sorrowfully in Paul''s final letter','Symbolises the danger of divided loyalty',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(314,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',96,'Governor of Judea','Felix','Heard Paul speak of righteousness','Trembled but postponed his decision','Left Paul confined to please opponents',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(315,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',97,'Successor to Felix','Festus','Found no fault but hesitated','Conferred with Agrippa about Paul','Sent Paul to appeal before Caesar',NULL,5,2,1,'2025-10-16 18:12:05');
INSERT INTO "questions" VALUES(316,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',98,'Great-grandson of Herod the Great','Agrippa II','Heard Paul''s defence with interest','Admitted Paul almost persuaded him to believe','Represented fading Jewish royalty under Rome',NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(317,'f649c7ad-6aa9-47ec-9b82-e37c18099840','character',99,'Companion of Barnabas','John Mark','Deserted an early journey','Later reconciled with Paul','Authored the Gospel of Mark',NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(318,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',1,'Who was the first man created by God according to Genesis?','Adam',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(319,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',2,'What was the forbidden fruit that Adam and Eve were commanded not to eat from?','The fruit from the Tree of the Knowledge of Good and Evil',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(320,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',3,'Who was the first murderer mentioned in the Bible?','Cain',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(321,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',4,'Who was taken to heaven without experiencing death in Genesis?','Enoch',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(322,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',5,'Who built an ark to survive a worldwide flood?','Noah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(323,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',6,'How many people entered the ark with Noah?','Eight',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(324,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',7,'What was the sign of God''s covenant with Noah after the flood?','A rainbow',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(325,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',8,'Who was called by God to leave his homeland and go to a land God would show him?','Abraham',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(326,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',9,'What was the name of Abraham''s wife who bore Isaac?','Sarah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(327,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',10,'What city did God destroy with fire and brimstone because of its wickedness?','Sodom and Gomorrah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(328,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',11,'Who was turned into a pillar of salt for looking back at the city''s destruction?','Lot''s wife',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(329,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',12,'Who was the son Abraham was willing to sacrifice before God stopped him?','Isaac',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(330,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',13,'Who tricked his blind father into giving him the blessing meant for his brother?','Jacob',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(331,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',14,'What was the name of Jacob''s twin brother whom he deceived?','Esau',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(332,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',15,'How many sons did Jacob have?','Twelve',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(333,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',16,'Which of Jacob''s sons was sold into slavery by his brothers?','Joseph',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(334,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',17,'In which land did Joseph become a governor?','Egypt',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(335,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',18,'Who found Moses as a baby floating in a basket on the Nile River?','Pharaoh''s daughter',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(336,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',19,'What form did God appear to Moses in on Mount Horeb?','A burning bush',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:06');
INSERT INTO "questions" VALUES(337,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',20,'Who was Moses'' brother that spoke on his behalf before Pharaoh?','Aaron',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(338,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',21,'What was the final plague that led Pharaoh to release the Israelites?','The death of the firstborn',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(339,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',22,'What sea did the Israelites cross on dry ground during the Exodus?','The Red Sea',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(340,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',23,'What food did God provide from heaven for the Israelites in the wilderness?','Manna',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(341,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',24,'Where did Moses receive the Ten Commandments?','Mount Sinai',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(342,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',25,'Who succeeded Moses as leader of Israel?','Joshua',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(343,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',26,'Which city''s walls fell after the Israelites marched around it for seven days?','Jericho',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(344,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',27,'Who was the woman who helped the Israelite spies in Jericho and was spared?','Rahab',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(345,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',28,'Which judge defeated the Midianites with only 300 men?','Gideon',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(346,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',29,'Which woman judge and prophet led Israel with Barak?','Deborah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(347,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',30,'Who was the strong man whose power was lost when his hair was cut?','Samson',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(348,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',31,'Who betrayed Samson by revealing his secret to the Philistines?','Delilah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(349,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',32,'Which Moabite woman became the great-grandmother of King David?','Ruth',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(350,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',33,'Who was the prophet that anointed both Saul and David as kings?','Samuel',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:07');
INSERT INTO "questions" VALUES(351,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',34,'Who was Israel''s first king?','Saul',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(352,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',35,'Who played the harp to soothe King Saul''s troubled spirit?','David',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(353,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',36,'What weapon did David use to defeat Goliath?','A sling and a stone',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(354,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',37,'Who was the woman with whom David committed adultery?','Bathsheba',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(355,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',38,'Which prophet confronted David about his sin with Bathsheba?','Nathan',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(356,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',39,'Who was the son of David who rebelled against him?','Absalom',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(357,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',40,'Which king asked God for wisdom instead of riches or long life?','Solomon',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(358,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',41,'What magnificent structure did Solomon build in Jerusalem?','The Temple',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(359,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',42,'Who was the prophet taken to heaven in a whirlwind?','Elijah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(360,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',43,'Who succeeded Elijah and received a double portion of his spirit?','Elisha',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(361,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',44,'Who was the commander healed of leprosy after washing in the Jordan River?','Naaman',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(362,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',45,'Who was swallowed by a great fish for fleeing from God''s command?','Jonah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(363,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',46,'Which prophet interpreted dreams for King Nebuchadnezzar?','Daniel',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(364,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',47,'Who were the three men thrown into a fiery furnace for refusing to bow to an idol?','"Shadrach','Meshach','and Abednego"',NULL,NULL,5,2,5,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(365,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',48,'Who was thrown into a den of lions but was not harmed?','Daniel',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(366,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',49,'Which Jewish queen saved her people from extermination in Persia?','Esther',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(367,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',50,'Who was Esther''s cousin and guardian?','Mordecai',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(368,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',51,'Which prophet saw a vision of dry bones coming to life?','Ezekiel',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(369,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',52,'Which prophet foretold that a virgin would give birth to a son called Immanuel?','Isaiah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(370,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',53,'Which prophet married a woman named Gomer as a sign of Israel''s unfaithfulness?','Hosea',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:08');
INSERT INTO "questions" VALUES(371,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',54,'Who rebuilt Jerusalem''s walls despite opposition?','Nehemiah',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(372,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',55,'Who led the exiles in restoring the Law and temple worship?','Ezra',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(373,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',56,'Who was the last prophet of the Old Testament before the coming of John the Baptist?','Malachi',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(374,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',57,'Who was chosen to bear the Son of God?','Mary',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(375,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',58,'Who was the husband of Mary and earthly guardian of Jesus?','Joseph',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(376,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',59,'Where was Jesus born?','Bethlehem',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(377,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',60,'"Who visited Jesus as a baby bringing gold','frankincense','and myrrh?"','The Wise Men',NULL,NULL,5,2,5,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(378,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',61,'Who baptised Jesus in the Jordan River?','John the Baptist',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(379,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',62,'How long did Jesus fast in the wilderness?','Forty days and forty nights',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(380,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',63,'What miracle did Jesus perform at the wedding in Cana?','Turned water into wine',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(381,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',64,'Who were the first disciples Jesus called?','Peter and Andrew',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(382,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',65,'What did Jesus do to feed five thousand men?','Multiplied five loaves and two fish',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(383,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',66,'Who walked on water towards Jesus?','Peter',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(384,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',67,'What was the name of the tax collector who climbed a sycamore tree to see Jesus?','Zacchaeus',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(385,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',68,'Who anointed Jesus'' feet with perfume and wiped them with her hair?','Mary of Bethany',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(386,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',69,'Whose tomb did Jesus raise Lazarus from?','Lazarus''s tomb',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(387,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',70,'Who betrayed Jesus to the religious leaders?','Judas Iscariot',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(388,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',71,'What was the amount Judas received for betraying Jesus?','Thirty pieces of silver',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(389,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',72,'Who denied Jesus three times before the rooster crowed?','Peter',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(390,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',73,'Who sentenced Jesus to be crucified?','Pontius Pilate',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(391,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',74,'What was written above Jesus on the cross?','"Jesus of Nazareth','King of the Jews"',NULL,NULL,NULL,5,5,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(392,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',75,'Who helped carry Jesus'' cross on the way to Golgotha?','Simon of Cyrene',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:09');
INSERT INTO "questions" VALUES(393,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',76,'Who was the first to see the risen Christ?','Mary Magdalene',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(394,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',77,'Which disciple doubted the resurrection until he saw Jesus'' wounds?','Thomas',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(395,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',78,'Where did Jesus ascend into heaven?','Mount of Olives',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(396,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',79,'Who replaced Judas Iscariot among the apostles?','Matthias',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(397,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',80,'What event marked the coming of the Holy Spirit to the disciples?','Pentecost',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(398,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',81,'Who was the first Christian martyr?','Stephen',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(399,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',82,'Who was converted on the road to Damascus?','Saul of Tarsus (Paul)',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(400,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',83,'Who was the first Gentile converted to Christianity?','Cornelius',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(401,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',84,'Who was Paul''s close companion on his missionary journeys?','Barnabas',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(402,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',85,'In which city were believers first called Christians?','Antioch',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(403,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',86,'Who opened her home to Paul and was a seller of purple cloth?','Lydia',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(404,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',87,'Who fell asleep during Paul''s preaching and was raised back to life?','Eutychus',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(405,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',88,'Who was the young pastor mentored by Paul and led the church in Ephesus?','Timothy',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(406,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',89,'Who was the runaway servant whom Paul sent back with a letter of forgiveness?','Onesimus',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(407,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',90,'Who was the Roman governor who trembled at Paul''s message?','Felix',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(408,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',91,'"Who said to Paul','""Almost thou persuadest me to be a Christian""?"','King Agrippa',NULL,NULL,NULL,5,5,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(409,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',92,'Who wrote the Book of Revelation while exiled on Patmos?','John the Apostle',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(410,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',93,'What island did Paul shipwreck on during his voyage to Rome?','Malta',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(411,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',94,'Who was the wealthy man that provided his tomb for Jesus'' burial?','Joseph of Arimathea',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(412,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',95,'"What Roman officer declared','""Truly this was the Son of God""?"','The Centurion at the Cross',NULL,NULL,NULL,5,5,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(413,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',96,'Which prophet foretold the coming of Elijah before the day of the Lord?','Malachi',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(414,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',97,'Who was struck blind for opposing Paul''s ministry on Cyprus?','Elymas the sorcerer',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:10');
INSERT INTO "questions" VALUES(415,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',98,'Which couple lied about the price of their land and fell dead?','Ananias and Sapphira',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:11');
INSERT INTO "questions" VALUES(416,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',99,'Which apostle was known as "the beloved disciple"?','John',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:11');
INSERT INTO "questions" VALUES(417,'f649c7ad-6aa9-47ec-9b82-e37c18099840','quiz',100,'Which Gospel writer was also a physician?','Luke',NULL,NULL,NULL,NULL,5,2,1,'2025-10-16 18:12:11');
INSERT INTO "questions" VALUES(618,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',1,'Recite Hebrews 11:1','Now faith is the substance of things hoped for, the evidence of things not seen.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:14');
INSERT INTO "questions" VALUES(619,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',2,'Recite Proverbs 3:5','Trust in the Lord with all your heart, and lean not on your own understanding;',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:14');
INSERT INTO "questions" VALUES(620,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',3,'Recite Proverbs 3:6','In all your ways acknowledge Him, and He shall direct your paths.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(621,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',4,'Recite 2 Corinthians 5:7','For we walk by faith, not by sight.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(622,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',5,'Recite Psalm 56:3','Whenever I am afraid, I will trust in You.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(623,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',6,'Recite Isaiah 26:3','You will keep him in perfect peace, whose mind is stayed on You, because he trusts in You.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(624,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',7,'Recite Psalm 37:5','Commit your way to the Lord, trust also in Him, and He shall bring it to pass.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(625,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',8,'Recite Philippians 4:13','I can do all things through Christ who strengthens me.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(626,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',9,'Recite Mark 9:23','Jesus said to him, ''If you can believe, all things are possible to him who believes.''',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(627,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',10,'Recite Romans 10:17','So then faith comes by hearing, and hearing by the word of God.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(628,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',11,'Recite Psalm 1:3','He shall be like a tree planted by the rivers of water, that brings forth its fruit in its season, whose leaf also shall not wither; and whatever he does shall prosper.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(629,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',12,'Recite 1 Corinthians 13:4','Love suffers long and is kind; love does not envy; love does not parade itself, is not puffed up;',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(630,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',13,'Recite 1 Corinthians 13:13','And now abide faith, hope, love, these three; but the greatest of these is love.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(631,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',14,'Recite 1 John 4:8','He who does not love does not know God, for God is love.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(632,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',15,'Recite Romans 12:9','Let love be without hypocrisy. Abhor what is evil. Cling to what is good.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(633,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',16,'Recite John 15:12','This is My commandment, that you love one another as I have loved you.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(634,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',17,'Recite Ephesians 4:2','With all lowliness and gentleness, with longsuffering, bearing with one another in love,',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(635,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',18,'Recite Romans 8:32','He who did not spare His own Son, but delivered Him up for us all, how shall He not with Him also freely give us all things?',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(636,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',19,'Recite Romans 13:10','Love does no harm to a neighbor; therefore love is the fulfillment of the law.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(637,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',20,'Recite Matthew 22:39','And the second is like it: ''You shall love your neighbor as yourself.''',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(638,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',21,'Recite Joshua 1:9','Have I not commanded you? Be strong and of good courage; do not be afraid, nor be dismayed, for the Lord your God is with you wherever you go.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(639,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',22,'Recite Isaiah 41:10','Fear not, for I am with you; be not dismayed, for I am your God. I will strengthen you, yes, I will help you, I will uphold you with My righteous right hand.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(640,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',23,'Recite Psalm 46:1','God is our refuge and strength, a very present help in trouble.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:15');
INSERT INTO "questions" VALUES(641,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',24,'Recite Nehemiah 8:10','Do not sorrow, for the joy of the Lord is your strength.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(642,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',25,'Recite Deuteronomy 31:6','Be strong and of good courage, do not fear nor be afraid of them; for the Lord your God, He is the One who goes with you. He will not leave you nor forsake you.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(643,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',26,'Recite Philippians 4:6','Be anxious for nothing, but in everything by prayer and supplication, with thanksgiving, let your requests be made known to God;',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(644,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',27,'Recite Psalm 27:1','The Lord is my light and my salvation; whom shall I fear? The Lord is the strength of my life; of whom shall I be afraid?',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(645,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',28,'Recite 2 Timothy 1:7','For God has not given us a spirit of fear, but of power and of love and of a sound mind.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(646,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',29,'Recite Isaiah 40:31','But those who wait on the Lord shall renew their strength; they shall mount up with wings like eagles, they shall run and not be weary, they shall walk and not faint.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(647,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',30,'Recite Psalm 55:22','Cast your burden on the Lord, and He shall sustain you; He shall never permit the righteous to be moved.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(648,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',31,'Recite Jeremiah 29:11','For I know the thoughts that I think toward you, says the Lord, thoughts of peace and not of evil, to give you a future and a hope.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(649,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',32,'Recite Romans 8:28','And we know that all things work together for good to those who love God, to those who are the called according to His purpose.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(650,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',33,'Recite Lamentations 3:22','Through the Lord''s mercies we are not consumed, because His compassions fail not.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(651,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',34,'Recite Psalm 30:5','For His anger is but for a moment, His favor is for life; weeping may endure for a night, but joy comes in the morning.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(652,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',35,'Recite Romans 15:13','Now may the God of hope fill you with all joy and peace in believing, that you may abound in hope by the power of the Holy Spirit.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(653,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',36,'Recite Colossians 3:23','And whatever you do, do it heartily, as to the Lord and not to men,',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(654,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',37,'Recite Revelation 21:4','And God will wipe away every tear from their eyes; there shall be no more death, nor sorrow, nor crying. There shall be no more pain, for the former things have passed away.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(655,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',38,'Recite Psalm 121:1–2','I will lift up my eyes to the hills—from whence comes my help? My help comes from the Lord, who made heaven and earth.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(656,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',39,'Recite Isaiah 43:19','Behold, I will do a new thing, now it shall spring forth; shall you not know it? I will even make a road in the wilderness and rivers in the desert.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(657,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',40,'Recite Romans 12:12','Rejoicing in hope, patient in tribulation, continuing steadfastly in prayer;',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(658,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',41,'Recite James 1:5','If any of you lacks wisdom, let him ask of God, who gives to all liberally and without reproach, and it will be given to him.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(659,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',42,'Recite Proverbs 1:7','The fear of the Lord is the beginning of knowledge, but fools despise wisdom and instruction.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(660,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',43,'Recite Psalm 119:105','Your word is a lamp to my feet and a light to my path.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(661,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',44,'Recite Proverbs 16:3','Commit your works to the Lord, and your thoughts will be established.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:16');
INSERT INTO "questions" VALUES(662,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',45,'Recite Proverbs 19:21','There are many plans in a man''s heart, nevertheless the Lord''s counsel—that will stand.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(663,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',46,'Recite Isaiah 30:21','Your ears shall hear a word behind you, saying, ''This is the way, walk in it,'' whenever you turn to the right hand or whenever you turn to the left.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(664,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',47,'Recite Colossians 3:16','Let the word of Christ dwell in you richly in all wisdom, teaching and admonishing one another in psalms and hymns and spiritual songs, singing with grace in your hearts to the Lord.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(665,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',48,'Recite Psalm 32:8','I will instruct you and teach you in the way you should go; I will guide you with My eye.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(666,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',49,'Recite Proverbs 4:7','Wisdom is the principal thing; therefore get wisdom. And in all your getting, get understanding.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(667,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',50,'Recite Psalm 37:23','The steps of a good man are ordered by the Lord, and He delights in his way.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(668,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',51,'Recite John 14:27','Peace I leave with you, My peace I give to you; not as the world gives do I give to you. Let not your heart be troubled, neither let it be afraid.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(669,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',52,'Recite Matthew 11:28','Come to Me, all you who labor and are heavy laden, and I will give you rest.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(670,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',53,'Recite Psalm 34:18','The Lord is near to those who have a broken heart, and saves such as have a contrite spirit.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(671,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',54,'Recite Philippians 4:7','And the peace of God, which surpasses all understanding, will guard your hearts and minds through Christ Jesus.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(672,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',55,'Recite 2 Thessalonians 3:16','Now may the Lord of peace Himself give you peace always in every way. The Lord be with you all.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(673,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',56,'Recite 1 Peter 5:7','Casting all your care upon Him, for He cares for you.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(674,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',57,'Recite Psalm 147:3','He heals the brokenhearted and binds up their wounds.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(675,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',58,'Recite Matthew 5:9','Blessed are the peacemakers, for they shall be called sons of God.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(676,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',59,'Recite Isaiah 12:2','Behold, God is my salvation, I will trust and not be afraid; For Yah, the Lord, is my strength and song; He also has become my salvation.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(677,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',60,'Recite Psalm 62:1','Truly my soul silently waits for God; from Him comes my salvation.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(678,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',61,'Recite Micah 6:8','He has shown you, O man, what is good; And what does the Lord require of you But to do justly, To love mercy, And to walk humbly with your God?',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(679,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',62,'Recite Matthew 6:33','But seek first the kingdom of God and His righteousness, and all these things shall be added to you.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(680,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',63,'Recite Romans 12:2','And do not be conformed to this world, but be transformed by the renewing of your mind, that you may prove what is that good and acceptable and perfect will of God.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(681,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',64,'Recite James 1:22','But be doers of the word, and not hearers only, deceiving yourselves.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(682,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',65,'Recite Psalm 1:1','Blessed is the man Who walks not in the counsel of the ungodly, Nor stands in the path of sinners, Nor sits in the seat of the scornful.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(683,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',66,'Recite Psalm 19:14','Let the words of my mouth and the meditation of my heart Be acceptable in Your sight, O Lord, my strength and my Redeemer.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:17');
INSERT INTO "questions" VALUES(684,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',67,'Recite Matthew 5:16','Let your light so shine before men, that they may see your good works and glorify your Father in heaven.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(685,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',68,'Recite Romans 6:23','For the wages of sin is death, but the gift of God is eternal life in Christ Jesus our Lord.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(686,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',69,'Recite Galatians 5:22–23','But the fruit of the Spirit is love, joy, peace, longsuffering, kindness, goodness, faithfulness, gentleness, self-control. Against such there is no law.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(687,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',70,'Recite Ephesians 2:10','For we are His workmanship, created in Christ Jesus for good works, which God prepared beforehand that we should walk in them.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(688,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',71,'Recite Matthew 5:14','You are the light of the world. A city that is set on a hill cannot be hidden.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(689,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',72,'Recite 1 Thessalonians 5:18','In everything give thanks; for this is the will of God in Christ Jesus for you.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(690,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',73,'Recite Psalm 100:4','Enter into His gates with thanksgiving, And into His courts with praise. Be thankful to Him, and bless His name.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(691,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',74,'Recite Jeremiah 33:3','Call to Me, and I will answer you, and show you great and mighty things, which you do not know.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(692,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',75,'Recite Psalm 118:24','This is the day the Lord has made; We will rejoice and be glad in it.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(693,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',76,'Recite Galatians 6:9','And let us not grow weary while doing good, for in due season we shall reap if we do not lose heart.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(694,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',77,'Recite Mark 11:24','Therefore I say to you, whatever things you ask when you pray, believe that you receive them, and you will have them.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(695,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',78,'Recite Philippians 4:19','And my God shall supply all your need according to His riches in glory by Christ Jesus.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(696,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',79,'Recite 1 John 5:14','Now this is the confidence that we have in Him, that if we ask anything according to His will, He hears us.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(697,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',80,'Recite Colossians 4:2','Continue earnestly in prayer, being vigilant in it with thanksgiving.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(698,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',81,'Recite Psalm 91:1','He who dwells in the secret place of the Most High Shall abide under the shadow of the Almighty.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(699,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',82,'Recite Psalm 91:11','For He shall give His angels charge over you, To keep you in all your ways.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(700,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',83,'Recite Psalm 34:7','The angel of the Lord encamps all around those who fear Him, And delivers them.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(701,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',84,'Recite 2 Samuel 22:31','As for God, His way is perfect; The word of the Lord is proven; He is a shield to all who trust in Him.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(702,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',85,'Recite Exodus 14:14','The Lord will fight for you, and you shall hold your peace.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(703,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',86,'Recite Psalm 18:2','The Lord is my rock and my fortress and my deliverer; My God, my strength, in whom I will trust; My shield and the horn of my salvation, my stronghold.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(704,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',87,'Recite Proverbs 18:10','The name of the Lord is a strong tower; The righteous run to it and are safe.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(705,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',88,'Recite Psalm 121:7','The Lord shall preserve you from all evil; He shall preserve your soul.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(706,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',89,'Recite Isaiah 54:17','No weapon formed against you shall prosper, And every tongue which rises against you in judgment You shall condemn. This is the heritage of the servants of the Lord, And their righteousness is from Me, Says the Lord.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(707,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',90,'Recite Nahum 1:7','The Lord is good, A stronghold in the day of trouble; And He knows those who trust in Him.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:18');
INSERT INTO "questions" VALUES(708,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',91,'Recite Romans 10:9','That if you confess with your mouth the Lord Jesus and believe in your heart that God has raised Him from the dead, you will be saved.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(709,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',92,'Recite Acts 16:31','So they said, ''Believe on the Lord Jesus Christ, and you will be saved, you and your household.''',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(710,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',93,'Recite John 14:6','Jesus said to him, ''I am the way, the truth, and the life. No one comes to the Father except through Me.''',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(711,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',94,'Recite Ephesians 2:8','For by grace you have been saved through faith, and that not of yourselves; it is the gift of God.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(712,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',95,'Recite 1 John 1:9','If we confess our sins, He is faithful and just to forgive us our sins and to cleanse us from all unrighteousness.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(713,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',96,'Recite Titus 3:5','Not by works of righteousness which we have done, but according to His mercy He saved us, through the washing of regeneration and renewing of the Holy Spirit.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(714,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',97,'Recite Romans 8:1','There is therefore now no condemnation to those who are in Christ Jesus, who do not walk according to the flesh, but according to the Spirit.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(715,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',98,'Recite John 10:10','The thief does not come except to steal, and to kill, and to destroy. I have come that they may have life, and that they may have it more abundantly.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(716,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',99,'Recite Revelation 3:20','Behold, I stand at the door and knock. If anyone hears My voice and opens the door, I will come in to him and dine with him, and he with Me.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
INSERT INTO "questions" VALUES(717,'f649c7ad-6aa9-47ec-9b82-e37c18099840','recitation',100,'Recite Romans 5:8','But God demonstrates His own love toward us, in that while we were still sinners, Christ died for us.',NULL,NULL,NULL,NULL,10,2,1,'2025-10-16 18:29:19');
CREATE TABLE team_members (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT NOT NULL,
    team TEXT NOT NULL CHECK(team IN ('A', 'B')),
    member_number INTEGER NOT NULL,
    member_name TEXT NOT NULL DEFAULT '',
    is_visible BOOLEAN DEFAULT 1,
    UNIQUE(game_instance_id, team, member_number)
);
INSERT INTO "team_members" VALUES(1,'0d656d42-a765-48a4-b68a-954f36d7be44','B',2,'',1);
INSERT INTO "team_members" VALUES(2,'0d656d42-a765-48a4-b68a-954f36d7be44','B',3,'',1);
INSERT INTO "team_members" VALUES(3,'0d656d42-a765-48a4-b68a-954f36d7be44','B',1,'',1);
INSERT INTO "team_members" VALUES(4,'0d656d42-a765-48a4-b68a-954f36d7be44','A',1,'Emma',1);
INSERT INTO "team_members" VALUES(5,'0d656d42-a765-48a4-b68a-954f36d7be44','A',2,'Johnson',1);
INSERT INTO "team_members" VALUES(6,'0d656d42-a765-48a4-b68a-954f36d7be44','A',3,'',1);
INSERT INTO "team_members" VALUES(7,'0d656d42-a765-48a4-b68a-954f36d7be44','A',4,'',1);
INSERT INTO "team_members" VALUES(8,'0d656d42-a765-48a4-b68a-954f36d7be44','B',4,'',1);
INSERT INTO "team_members" VALUES(9,'0d656d42-a765-48a4-b68a-954f36d7be44','A',5,'',1);
INSERT INTO "team_members" VALUES(10,'0d656d42-a765-48a4-b68a-954f36d7be44','B',5,'',1);
INSERT INTO "team_members" VALUES(11,'0d656d42-a765-48a4-b68a-954f36d7be44','A',6,'',1);
INSERT INTO "team_members" VALUES(12,'0d656d42-a765-48a4-b68a-954f36d7be44','B',6,'',1);
INSERT INTO "team_members" VALUES(13,'0d656d42-a765-48a4-b68a-954f36d7be44','A',7,'',1);
INSERT INTO "team_members" VALUES(14,'0d656d42-a765-48a4-b68a-954f36d7be44','B',7,'',1);
INSERT INTO "team_members" VALUES(15,'0d656d42-a765-48a4-b68a-954f36d7be44','B',8,'',1);
INSERT INTO "team_members" VALUES(16,'0d656d42-a765-48a4-b68a-954f36d7be44','A',9,'',1);
INSERT INTO "team_members" VALUES(17,'0d656d42-a765-48a4-b68a-954f36d7be44','A',8,'',1);
INSERT INTO "team_members" VALUES(18,'0d656d42-a765-48a4-b68a-954f36d7be44','B',9,'',1);
INSERT INTO "team_members" VALUES(19,'0d656d42-a765-48a4-b68a-954f36d7be44','A',10,'',1);
INSERT INTO "team_members" VALUES(20,'0d656d42-a765-48a4-b68a-954f36d7be44','B',10,'',1);
INSERT INTO "team_members" VALUES(21,'0d656d42-a765-48a4-b68a-954f36d7be44','A',12,'',1);
INSERT INTO "team_members" VALUES(22,'0d656d42-a765-48a4-b68a-954f36d7be44','B',11,'',1);
INSERT INTO "team_members" VALUES(23,'0d656d42-a765-48a4-b68a-954f36d7be44','A',11,'',1);
INSERT INTO "team_members" VALUES(24,'0d656d42-a765-48a4-b68a-954f36d7be44','B',12,'',1);
INSERT INTO "team_members" VALUES(25,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',1,'Modupe',1);
INSERT INTO "team_members" VALUES(26,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',3,'',1);
INSERT INTO "team_members" VALUES(27,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',1,'joy',1);
INSERT INTO "team_members" VALUES(28,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',2,'tayo',1);
INSERT INTO "team_members" VALUES(29,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',3,'',1);
INSERT INTO "team_members" VALUES(30,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',2,'emmanuel',1);
INSERT INTO "team_members" VALUES(31,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',4,'',1);
INSERT INTO "team_members" VALUES(32,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',4,'',1);
INSERT INTO "team_members" VALUES(33,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',5,'',1);
INSERT INTO "team_members" VALUES(34,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',5,'',1);
INSERT INTO "team_members" VALUES(35,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',6,'',1);
INSERT INTO "team_members" VALUES(36,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',6,'',1);
INSERT INTO "team_members" VALUES(37,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',7,'',1);
INSERT INTO "team_members" VALUES(38,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',7,'',1);
INSERT INTO "team_members" VALUES(39,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',8,'',1);
INSERT INTO "team_members" VALUES(40,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',8,'',1);
INSERT INTO "team_members" VALUES(41,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',9,'',1);
INSERT INTO "team_members" VALUES(42,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',9,'',1);
INSERT INTO "team_members" VALUES(43,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',10,'',1);
INSERT INTO "team_members" VALUES(44,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',10,'',1);
INSERT INTO "team_members" VALUES(45,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',12,'',1);
INSERT INTO "team_members" VALUES(46,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',12,'',1);
INSERT INTO "team_members" VALUES(47,'f649c7ad-6aa9-47ec-9b82-e37c18099840','B',11,'',1);
INSERT INTO "team_members" VALUES(48,'f649c7ad-6aa9-47ec-9b82-e37c18099840','A',11,'',1);
CREATE TABLE game_state (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT UNIQUE NOT NULL,
    current_question_type TEXT CHECK(current_question_type IN ('quiz', 'recitation', 'character', NULL)),
    current_question_number INTEGER,
    active_team TEXT CHECK(active_team IN ('A', 'B', NULL)),
    is_bonus_round BOOLEAN DEFAULT 0,
    hints_shown INTEGER DEFAULT 0,
    hints_requested INTEGER DEFAULT 0,
    question_answered BOOLEAN DEFAULT 0,
    answer_visible BOOLEAN DEFAULT 0,
    team_a_quiz_score INTEGER DEFAULT 0,
    team_a_recitation_score INTEGER DEFAULT 0,
    team_a_character_score INTEGER DEFAULT 0,
    team_b_quiz_score INTEGER DEFAULT 0,
    team_b_recitation_score INTEGER DEFAULT 0,
    team_b_character_score INTEGER DEFAULT 0,
    show_score_breakdown BOOLEAN DEFAULT 0,
    show_aggregate_only BOOLEAN DEFAULT 1,
    game_ended BOOLEAN DEFAULT 0,
    timer_started_at TIMESTAMP,
    timer_duration INTEGER DEFAULT 60,
    dark_mode BOOLEAN DEFAULT 0,
    last_saved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "game_state" VALUES(1,'0d656d42-a765-48a4-b68a-954f36d7be44','recitation',3,'B',0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,60,1,'2025-10-16 08:36:34','2025-10-16 08:36:34');
INSERT INTO "game_state" VALUES(2,'f649c7ad-6aa9-47ec-9b82-e37c18099840',NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,60,1,'2025-10-17 06:50:03','2025-10-17 06:50:03');
CREATE TABLE answer_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT NOT NULL,
    question_type TEXT NOT NULL,
    question_number INTEGER NOT NULL,
    team TEXT NOT NULL CHECK(team IN ('A', 'B')),
    is_bonus BOOLEAN DEFAULT 0,
    is_correct BOOLEAN NOT NULL,
    hints_used INTEGER DEFAULT 0,
    points_awarded INTEGER DEFAULT 0,
    time_taken INTEGER,
    answered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE undo_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT NOT NULL,
    action_type TEXT NOT NULL,
    previous_state TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE skip_log (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    game_instance_id TEXT NOT NULL,
    question_type TEXT NOT NULL,
    question_number INTEGER NOT NULL,
    skipped_by_team TEXT NOT NULL CHECK(skipped_by_team IN ('A', 'B')),
    skipped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE session_answers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  game_instance_id TEXT NOT NULL,
  question_type TEXT NOT NULL,
  question_number INTEGER NOT NULL,
  team TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(game_instance_id, question_type, question_number)
);
DELETE FROM sqlite_sequence;
INSERT INTO "sqlite_sequence" VALUES('users',8);
INSERT INTO "sqlite_sequence" VALUES('game_state',2);
INSERT INTO "sqlite_sequence" VALUES('team_members',48);
INSERT INTO "sqlite_sequence" VALUES('questions',717);
INSERT INTO "sqlite_sequence" VALUES('answer_log',70);
INSERT INTO "sqlite_sequence" VALUES('skip_log',4);
INSERT INTO "sqlite_sequence" VALUES('session_answers',52);
INSERT INTO "sqlite_sequence" VALUES('undo_history',52);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_game_instance ON users(game_instance_id);
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);
CREATE INDEX idx_questions_instance ON questions(game_instance_id);
CREATE INDEX idx_questions_type ON questions(question_type);
CREATE INDEX idx_questions_lookup ON questions(game_instance_id, question_type, question_number);
CREATE INDEX idx_members_instance ON team_members(game_instance_id);
CREATE INDEX idx_members_team ON team_members(game_instance_id, team);
CREATE INDEX idx_game_state_instance ON game_state(game_instance_id);
CREATE INDEX idx_answer_log_instance ON answer_log(game_instance_id);
CREATE INDEX idx_answer_log_question ON answer_log(game_instance_id, question_type, question_number);
CREATE INDEX idx_undo_instance ON undo_history(game_instance_id);
CREATE INDEX idx_undo_created ON undo_history(created_at DESC);
CREATE INDEX idx_skip_instance ON skip_log(game_instance_id);
CREATE INDEX idx_session_answers_game ON session_answers(game_instance_id);
CREATE TRIGGER update_game_state_timestamp 
AFTER UPDATE ON game_state
BEGIN
    UPDATE game_state 
    SET updated_at = CURRENT_TIMESTAMP 
    WHERE id = NEW.id;
END;
