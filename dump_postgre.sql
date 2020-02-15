CREATE TYPE user_role AS ENUM('Patient', 'Administration', 'Nurse', 'Doctor', 'Receptionist');
CREATE TYPE appointment_status AS ENUM('awaiting', 'in progress', 'cancelled', 'past');
CREATE TYPE document_type AS ENUM('social security card', 'passport', 'driving license', 'health insurance');
CREATE TYPE action_type AS ENUM('take', 'add', 'view');

CREATE TABLE UserTB(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Surname VARCHAR(50) NOT NULL,
	Patronymic VARCHAR(50),
	Role USER_ROLE NOT NULL,
	PasswordHash VARCHAR(50) NOT NULL,
	Salary INT,
	Email VARCHAR(100),
	PRIMARY KEY(Id)
);

CREATE TABLE TimeSlot(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	StartTime TIME WITH TIME ZONE NOT NULL,
	EndTime TIME WITH TIME ZONE NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE MessageTb(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	FromUserId INT REFERENCES UserTb(Id) NOT NULL,
	ToUserId INT REFERENCES UserTb(Id) NOT NULL,
	Time TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE('utc')),
	Text TEXT NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE CheckTb(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Amount INT NOT NULL,
	IsPaid BOOL NOT NULL,
	PayerId INT REFERENCES UserTb(Id) NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE Appointment (
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Date DATE NOT NULL DEFAULT NOW(),
	Status APPOINTMENT_STATUS NOT NULL,
	RoomNumber INT NOT NULL,
	TimeSlotId INT REFERENCES TIMESLOT(Id) NOT NULL,
	AssignedCheckId INT REFERENCES CHECKTB(Id),
	PRIMARY KEY(Id)
);

CREATE TABLE UserAppointment(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Appointment INT REFERENCES APPOINTMENT(Id) NOT NULL,
	UserId INT REFERENCES USERTB(Id) NOT NULL,
	Comment TEXT,
	PRIMARY KEY(Id)
);

CREATE TABLE NoticeTb(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Title VARCHAR(150) NOT NULL,
	Text TEXT NOT NULL,
	CreatedAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW() AT TIME ZONE('utc')),
	CreatedByUserId int REFERENCES USERTB(Id) NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE DocumentTb(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Type DOCUMENT_TYPE NOT NULL,
	DocumentId VARCHAR(150),
	File TEXT NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE MedicalReport(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	CreatedAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW() AT TIME ZONE('utc')),
	PrescribedTreatment TEXT,
	DoctorId INT REFERENCES USERTB(Id) NOT NULL,
	PatientId INT REFERENCES USERTB(Id) NOT NULL,
	AssignedCheckId INT REFERENCES CHECKTB(Id),
	PRIMARY KEY(Id)
);

CREATE TABLE MedicineStock(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Name VARCHAR(150) NOT NULL,
	Amount INT NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE MedicineJournal(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	ActionTime TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW() AT TIME ZONE('utc')),
	ActionType ACTION_TYPE NOT NULL,
	Amount INT,
	UserId INT REFERENCES USERTB(Id) NOT NULL,
	PRIMARY KEY(Id)
);

CREATE TABLE UserDocument(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	DocumentId INT REFERENCES DOCUMENTTB(Id),
	UserId INT REFERENCES USERTB(Id),
	PRIMARY KEY(Id)
);

CREATE TABLE DocumentReport(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	DocumentId INT REFERENCES DOCUMENTTB(Id),
	Report INT REFERENCES MEDICALREPORT(Id),
	PRIMARY KEY(Id)
);

CREATE TABLE Notification(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	Title VARCHAR(150) NOT NULL,
	Text TEXT NOT NULL,
	CreatedAt TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT(NOW() AT TIME ZONE('utc')),
	CreatedByUserId int REFERENCES USERTB(Id),
	PRIMARY KEY(Id)
);

CREATE TABLE NotificationDestination(
	Id INT GENERATED BY DEFAULT AS IDENTITY,
	NotificationId INT REFERENCES NOTIFICATION(Id),
	IntendedForUserId INT REFERENCES USERTB(Id),
	IsViewed BOOL NOT NULL,
	PRIMARY KEY(Id)
);

INSERT INTO timeslot VALUES (1, '00:00:00', '00:59:59');
INSERT INTO timeslot VALUES (2, '01:00:00', '01:59:59');
INSERT INTO timeslot VALUES (3, '02:00:00', '02:59:59');
INSERT INTO timeslot VALUES (4, '03:00:00', '03:59:59');
INSERT INTO timeslot VALUES (5, '04:00:00', '04:59:59');
INSERT INTO timeslot VALUES (6, '05:00:00', '05:59:59');
INSERT INTO timeslot VALUES (7, '06:00:00', '06:59:59');
INSERT INTO timeslot VALUES (8, '07:00:00', '07:59:59');
INSERT INTO timeslot VALUES (9, '08:00:00', '08:59:59');
INSERT INTO timeslot VALUES (10, '09:00:00', '09:59:59');
INSERT INTO timeslot VALUES (11, '10:00:00', '10:59:59');
INSERT INTO timeslot VALUES (12, '11:00:00', '11:59:59');
INSERT INTO timeslot VALUES (13, '12:00:00', '12:59:59');
INSERT INTO timeslot VALUES (14, '13:00:00', '13:59:59');
INSERT INTO timeslot VALUES (15, '14:00:00', '14:59:59');
INSERT INTO timeslot VALUES (16, '15:00:00', '15:59:59');
INSERT INTO timeslot VALUES (17, '16:00:00', '16:59:59');
INSERT INTO timeslot VALUES (18, '17:00:00', '17:59:59');
INSERT INTO timeslot VALUES (19, '18:00:00', '18:59:59');
INSERT INTO timeslot VALUES (20, '19:00:00', '19:59:59');
INSERT INTO timeslot VALUES (21, '20:00:00', '20:59:59');
INSERT INTO timeslot VALUES (22, '21:00:00', '21:59:59');
INSERT INTO timeslot VALUES (23, '22:00:00', '22:59:59');
INSERT INTO timeslot VALUES (24, '23:00:00', '23:59:59');


INSERT INTO usertb VALUES (1, 'Ivan', 'Ivanov', 'Ivanovich', 'Doctor', md5('pass1'), 30000, 'i.i.i@i.i');
INSERT INTO usertb VALUES (2, 'Maria', 'Ivanova', 'Ivanovna', 'Doctor', md5('pass2'), 40000, 'mii@yandex.ru');
INSERT INTO usertb VALUES (3, 'Maria', 'Last_name', NULL, 'Doctor', md5('pass3'), 50000, 'ml@yandex.ru');
INSERT INTO usertb VALUES (4, 'Anna', 'Smith', NULL, 'Patient', md5('pass4'), NULL, 'anna1537@gmail.com');
INSERT INTO usertb VALUES (5, 'Karl', 'Smith', NULL, 'Patient', md5('pass4'), NULL, 'karl1337@gmail.com');
INSERT INTO usertb VALUES (6, 'Daria', 'Lavronova', 'Petrovna', 'Doctor', md5('pass6'), 60000, 'dlp@yandex.ru');


INSERT INTO appointment VALUES (1, '2019-09-28', 'past', 107, 16, NULL);
INSERT INTO userappointment VALUES (1, 1, 2, 'I have headache');
INSERT INTO userappointment VALUES (2, 1, 4, NULL);

INSERT INTO appointment VALUES (2, '2019-09-28', 'past', 107, 17, NULL);
INSERT INTO userappointment VALUES (3, 2, 2, NULL);
INSERT INTO userappointment VALUES (4, 2, 3, NULL);
INSERT INTO userappointment VALUES (5, 2, 5, NULL);

INSERT INTO appointment VALUES (3, '2019-10-28', 'past', 107, 16, NULL);
INSERT INTO userappointment VALUES (6, 3, 2, NULL);
INSERT INTO userappointment VALUES (7, 3, 5, NULL);

INSERT INTO appointment VALUES (4, '2019-10-28', 'past', 107, 17, NULL);
INSERT INTO userappointment VALUES (8, 4, 1, NULL);
INSERT INTO userappointment VALUES (9, 4, 4, NULL);

INSERT INTO appointment VALUES (5, '2019-10-28', 'past', 107, 18, NULL);
INSERT INTO userappointment VALUES (10, 5, 3, NULL);
INSERT INTO userappointment VALUES (11, 5, 4, NULL);

INSERT INTO appointment VALUES (6, '2019-10-28', 'past', 107, 19, NULL);
INSERT INTO userappointment VALUES (12, 6, 2, NULL);
INSERT INTO userappointment VALUES (13, 6, 4, NULL);

INSERT INTO appointment VALUES (7, '2019-10-28', 'past', 107, 20, NULL);
INSERT INTO userappointment VALUES (14, 7, 6, NULL);
INSERT INTO userappointment VALUES (15, 7, 4, NULL);

INSERT INTO appointment VALUES (8, '2019-10-28', 'past', 107, 21, NULL);
INSERT INTO userappointment VALUES (16, 8, 1, NULL);
INSERT INTO userappointment VALUES (17, 8, 2, NULL);
INSERT INTO userappointment VALUES (18, 8, 3, NULL);
INSERT INTO userappointment VALUES (19, 8, 6, NULL);

INSERT INTO appointment VALUES (9, '2018-11-19', 'past', 107, 20, NULL);
INSERT INTO userappointment VALUES (20, 9, 1, NULL);
INSERT INTO userappointment VALUES (21, 9, 2, NULL);
INSERT INTO userappointment VALUES (22, 9, 3, NULL);
INSERT INTO userappointment VALUES (23, 9, 6, NULL);