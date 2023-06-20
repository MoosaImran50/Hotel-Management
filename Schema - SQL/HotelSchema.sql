create database hotel1
go
use hotel1
go

drop database hotel1

create table Users 
( UserId varchar(10) primary key, 
  Name varchar(50) NOT NULL, 
  Phone char(11) NOT NULL unique,
  DOB date NOT NULL,
  Email varchar(30) NOT NULL,
  State_ varchar(15) NOT NULL,
  City varchar(15) NOT NULL,
  Password_ varchar(20) NOT NULL,
  Warnings int default 0
)
go

create table admin_ 
(
	AdminId varchar(20) primary key,	--member id link with userid
	[Password] varchar(20) NOT NULL, --(length([Password]) > 8 AND [Password] like '%[A-Z]%' AND [Password] like '%[0-9]%')
	Name varchar(20) NOT NULL
)
go

create table Hotels 
( HotelId int primary key, 
  HotelName varchar(50) NOT NULL,
  HotelAddress varchar(50) NOT NULL,
  City varchar(20) NOT NULL,
  Description_ varchar(200),
  HotelRating float check(HotelRating >= 0 and HotelRating <=5)
)
go

create table Rooms 
( RoomId int primary key NOT NULL,	--Change to roomID
  HotelId int foreign key references Hotels(HotelId) on delete NO ACTION on update cascade NOT NULL,
  NoOfBeds int NOT NULL,
  RoomPrice float, --per day
  RoomStatus varchar(20) check(RoomStatus in ('Available','Unavailable')) NOT NULL default 'Available',
)
go

create table Booking
( BookingId int primary key,
  UserId varchar(10) foreign key references Users(UserId) on delete NO ACTION on update Cascade NOT NULL,
  HotelId int foreign key references Hotels(HotelId) on delete NO ACTION on update NO ACTION NOT NULL,
  RoomId int foreign key references Rooms(RoomId) on delete NO ACTION on update NO ACTION NOT NULL,
  BookingDate date NOT NULL
)
go

create table cancelledBookings
(
	BookingId int,
	UserId varchar(10),
	primary key(UserId,BookingId)
)
go

create table Reviews		--user comments only about particular hotel
( HotelId int foreign key references Hotels(HotelId) on delete NO ACTION on update NO ACTION,
  UserId varchar(10) foreign key references Users(UserId) on delete NO ACTION on update NO ACTION,
  UserRating float check(UserRating >= 0 and UserRating <=5),
  Feedback varchar(500),
  primary key(HotelId, UserId)
)
go

create table Blacklist 
( UserId varchar(10) foreign key references Users(UserId) on delete NO ACTION on update NO ACTION,
  [Description] varchar(200) NOT NULL,
  primary key(UserId)
)
go

create table Complaints
( UserId varchar(10) foreign key references Users(UserId) on delete NO ACTION on update cascade,
  Name varchar(20) NOT NULL,
  primary key(UserId)
)
go

--Procedures
---------------------------------------------------------------------------------------------------------------------------------------------------------------

--1
create procedure AddUser
@UserId int,
@Name varchar(50),
@Phone char(11),
@Gender varchar(6),
@Age int,
@UserType varchar(10),
@Points float
As
Begin
	insert into Users values(@UserId, @Name, @Phone, @Gender, @Age, @UserType, @Points)
End
go

Execute AddUser @UserId= 123, @Name='Ahsan Khan', @Phone='03085214677', @Gender='Male', @Age= 25, @UserType='User', @Points=0
Select *
From Users


----------------------------------------------------------------------------------------------------------------------------------------------------------------
--2
create procedure ModifyUser
@UserId int,
@Name varchar(50),
@Phone char(11),
@Gender varchar(6),
@Age int,
@UserType varchar(10),
@Points float
As
Begin
	update Users set UserId=@UserId, Name=@Name, Phone=@Phone, Gender=@Gender, Age=@Age, UserType=@UserType, Points=@Points 
	where UserId=@UserId
End
go

Execute ModifyUser @UserId= 123, @Name='umar Khan', @Phone='03227419433', @Gender='Female', @Age= 25, @UserType='User', @Points=0
Select *
From Users
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--3
create procedure AddHotel
@HotelId int, 
@OwnerId int ,
@HotelName varchar(50) ,
@HotelAddress varchar(50) ,
@NoOfRooms int,
@HotelRating float
As
Begin
	insert into Hotels values(@HotelId, @OwnerId, @HotelName, @HotelAddress, @NoOfRooms, @HotelRating)
End
go

Execute AddHotel @HotelId= 11, @OwnerId=1, @HotelName='moke', @HotelAddress='LHR', @NoOfRooms= 5, @HotelRating=3.4
Select *
From Hotels

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--4
create procedure ModifyHotel
@HotelId int, 
@OwnerId int ,
@HotelName varchar(50) ,
@HotelAddress varchar(50) ,
@NoOfRooms int,
@HotelRating float
As
Begin

    update Hotels 
	set HotelId=@HotelId, OwnerId=@OwnerId, HotelName=@HotelName, HotelAddress=@HotelAddress, NoOfRooms=@NoOfRooms, HotelRating=@HotelRating
	where HotelId=@HotelId
End
go

Execute ModifyHotel @HotelId= 123, @OwnerId=22, @HotelName='saksd', @HotelAddress='LHR', @NoOfRooms= 5, @HotelRating=4
Select *
From Hotels

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--5
create procedure AddRoom
@RoomNo int,
@HotelId int ,
@NoOfBeds int,
@RoomPrice float, --per day
@RoomStatus varchar(20)
As
Begin
	insert into Rooms values(@RoomNo, @HotelId, @NoOfBeds, @RoomPrice, @RoomStatus)
End
go


Execute AddRoom @RoomNo= 1, @HotelId=11, @NoOfBeds=4, @RoomPrice=25000, @RoomStatus= 'Available'
Select *
From Rooms
----------------------------------------------------------------------------------------------------------------------------------------------------------------

--6
create procedure ModifyRoom
@RoomNo int,
@HotelId int ,
@NoOfBeds int,
@RoomPrice float, --per day
@RoomStatus varchar(20)
As
Begin
	update Rooms set RoomNo=@RoomNo, HotelId=@HotelId, NoOfBeds=@NoOfBeds, RoomPrice=@RoomPrice, RoomStatus=@RoomStatus where RoomNo=@RoomNo AND HotelId=@HotelId
End
go


Execute ModifyRoom @RoomNo= 1, @HotelId=11, @NoOfBeds=444, @RoomPrice=23000, @RoomStatus= 'Available'
Select *
From Rooms
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--7
create procedure BlackListUser
@UserId int,
@HotelId int,
@Description varchar(200)
As
Begin
     If exists( Select UserId
	            From Booking
				Where UserId = @UserId AND HotelId = @HotelId AND [Status] = 'Not Arrived'
				Group by UserId
				Having count([status])>3 )
	Begin
	insert into BlackList values(@UserId, @HotelId, @Description)
	End
End
go

Execute BlackListUser @UserId = 123, @HotelId = 112, @Description = 'Not arrived to booking more than 3 times'
Select *
From BlackList

drop procedure BlackListUser

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--8
create procedure AddPackages
@PackageId int,
@HotelId int, 
@PackageDescription varchar(500),
@PackageStart date,
@PackageEnd date,
@Price float
As
Begin
	insert into Packages values(@PackageId, @HotelId, @PackageDescription, @PackageStart, @PackageEnd, @Price)
End
go


Execute AddPackages @PackageId= 1, @HotelId=11, @PackageDescription='heloo', @PackageStart='9-11-2020', @PackageEnd= '10-22-2021',@Price=500
select *
from Packages

-----------------------------------------------------------------------------------------------------------------------------------
--9
create procedure ModifyPackages
@PackageId int,
@HotelId int, 
@PackageDescription varchar(500),
@PackageStart date,
@PackageEnd date,
@Price float
As
Begin
	update Packages
    set PackageId=@PackageId, HotelId=@HotelId, PackageDescription=@PackageDescription, PackageStart=@PackageStart, PackageEnd=@PackageEnd, Price=@Price
	where PackageId=@PackageId AND HotelId=@HotelId
End
go


Execute ModifyPackages @PackageId= 1, @HotelId=11, @PackageDescription='hiadis', @PackageStart='2-11-2020', @PackageEnd= '1-22-2021',@Price=100
select *
from Packages
-----------------------------------------------------------------------------------------------------------------------------------
--10
create procedure AddReward
@UserId int,
@Points float ,
@Reward varchar(100),
@Description varchar(200)
As
Begin
	insert into Rewards values (@UserId,@Points,@Reward,@Description)
End
go


Execute AddReward  UserId=1,@Points=2.2,@Reward=112, @Description='heldo'
select *
from Rewards

---------------------------

--11
create procedure UpdateReward
@UserId int,
@Points float ,
@Reward varchar(100),
@Description varchar(200)
As
Begin
	
	update Rewards set UserId=@UserId,Points=@Points, Reward=@Reward, [Description]=@Description
	where UserId=@UserId
End
go


Execute UpdateReward @UserId=1, @Points=2.2,@Reward=112, @Description='heldo'
select *
from Rewards

-----------------------------------------------------------------------------------------------------------------------------------
--12
create procedure AddBooking
  @BookingId int,
  @UserId int,
  @HotelId int,
  @RoomNo int,
  @PackageId int,
  @BookingDate timestamp,
  @Status varchar(11),
  @CheckIn datetime,
  @CheckOut datetime
As
Begin
	insert into Booking values (@BookingId,@UserId,@HotelId,@RoomNo,@PackageId,@BookingDate,@Status,@CheckIn,@CheckOut)
End
go


Execute AddBooking  @BookingId=1,@UserId=2.2,@HotelId=112, @RoomNo=22,@PackageId=1,@BookingDate='2-11-2020',@Status='hi',@CheckIn='2-12-2020',@CheckOut='2-15-2020'
select *
from Booking
-----------------------------------------------------------------------------------------------------------------------------------
--13
create procedure UpdateBooking
  @BookingId int,
  @UserId int,
  @HotelId int,
  @RoomNo int,
  @PackageId int,
  @BookingDate timestamp,
  @Status varchar(11),
  @CheckIn datetime,
  @CheckOut datetime
As
Begin
	update Booking set BookingId=@BookingId,UserId=@UserId,HotelId=@HotelId,RoomNo=@RoomNo,PackageId=@PackageId,BookingDate=@BookingDate,[Status]=@Status,CheckIn=@CheckIn,CheckOut=@CheckOut
	where BookingId=@BookingId AND UserId=@UserId AND HotelId=@HotelId
End
go


Execute ModifyBooking  @BookingId=1,@UserId=2.2,@HotelId=112, @RoomNo=21,@PackageId=3,@BookingDate='2-1-2020',@Status='open',@CheckIn='2-12-2020',@CheckOut='2-15-2020'
select *
from Booking

-----------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------
--14
create procedure UserPayment
@BookingId int,
@UserId int,
@PaymentType varchar(13),
@TotalAmount float,
@BookingTime varbinary(8)
As
Begin
     
	 If exists ( Select BookingId 
	             From Booking
				 Where BookingId = @BookingId AND UserId = @UserID )
	 
	 Begin

	 set @TotalAmount = ( Select (RoomPrice * datediff(day, checkin, checkout)) - Price
	                      From (Rooms as R join Booking as B on R.RoomNo = B.RoomNo) join Packages as P on P.PackageId = B.PackageId )

	 Insert into Payment values(@BookingId, @UserId, @PaymentType, @TotalAmount, @BookingTime)
	 End

	 Else
	 Begin
	 Print 'Booking does not exist please type correct BookingId & UserId'
	 End
End
go

Execute UserPayment @BookingId = 123, @UserId = 111, @PaymentType = 'Cash', @TotalAmount = 0, @BookingTime = gettimestamp
Select *
From Payment

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--15
create procedure SignUp
@Email varchar(50),
@Password varchar(100)
As
Begin

	If exists ( Select Email
	            From [Login]
	            Where Email = @Email )
    Begin
	Print 'Email already exists!'
    End

    Else

	Begin
	Insert into [Login] values(@Email, @Password)
	Print 'Account created'
	End

End
go

Execute SignUp @Email = 'ahhs@gmail.com', @Password = 'QWERTY123$'
Select *
From [Login]

drop procedure SignUp

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--16
create procedure SignIn
@Email varchar(50),
@Password varchar(100)
As
Begin
	If exists ( Select *
	            From [Login]
	            Where Email = @Email AND [Password] = @Password )

	Begin
	Print 'SignIn successful'
	End

	Else

	Begin
	Print 'SignIn unsuccessful'
	End

End
go

Execute SignIn @Email = 'ahhs@gmail.com', @Password = 'QWERTY123$'

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--17
create procedure AddComplaint
@UserId int,
@Description varchar(200)
As
Begin
	insert into complaints values(@UserId, @Description,'Open')
End
go

Execute AddComplaint @UserId = 123, @Description = 'Room was not clean'
Select *
From Complaints

----------------------------------------------------------------------------------------------------------------------------------------------------------------
--18
create procedure UpdateComplaint
@UserId int
As
Begin
	update complaints set [status] = 'Closed' Where UserId = @UserId
End
go

Execute UpdateComplaint @UserId = 123
Select *
From Complaints


----------------------------------------------------------------------------------------------------------------------------------------------------------------
--19
create procedure AddRating
  @HotelId int,
  @UserId int,
  @UserRating float,
  @UserComment varchar(500),
  @Rating float
  
As set @Rating=(select avg(UserRating)
			from Rating)
Begin
	insert into Rating values(@HotelId, @UserId,@UserRating,@UserComment,@Rating)
End
go

Execute AddRating @HotelId=1,@UserId = 123,@UserRating=3, @UserComment = 'Good hotel',@Rating=0.0
Select *
From Rating
----------------------------------------------------------------------------------------------------------------------------------------------------------------
--20
create procedure cancelBooking
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------


--Views


create view AffordableHotelRooms
as
select h.hotelid, h.HotelName, RoomNo, NoOfBeds, RoomPrice , RoomStatus
from Hotels as h
join Rooms as r
on h.HotelId=r.HotelId
where RoomPrice < 10000
with check option
go

select * from AffordableHotelRooms

------------------------------------------------------------------------------------------------------

create view PremiumHotelRooms
as
select h.hotelid, h.HotelName, RoomNo, NoOfBeds, RoomPrice , RoomStatus
from Hotels as h
join Rooms as r
on h.HotelId=r.HotelId
where RoomPrice > 30000
with check option
go

select * from PremiumHotelRooms

------------------------------------------------------------------------------------------------------

create view PendingBoookings
as
select BookingId, u.UserId, u.Name, h.HotelId, h.HotelName, RoomNo, PackageId
from Booking as b
join Users as u
on b.userid=u.userid
join Hotels as h
on h.HotelId=b.HotelId
where [Status] = 'Pending'
with check option
go

select * from PendingBoookings

------------------------------------------------------------------------------------------------------

create view CustomersOnWarning
as
select u.UserId, u.Name, count(*) as NoOfCancelledBookings
from CancelBooking as cb
join Users as u
on cb.userid=u.userid
group by u.UserId, u.Name
having count(*) < 4
with check option
go

select * from CustomersOnWarning

------------------------------------------------------------------------------------------------------

create view FiveStarHotelPackages
as
select h.hotelid, h.HotelName, PackageId, PackageDescription, PackageStart , PackageEnd, Price
from Hotels as h
join Packages as p
on h.HotelId=p.HotelId
where HotelRating = 5.0
with check option
go

select * from FiveStarHotelPackages

------------------------------------------------------------------------------------------------------

create view AffordableHotelPackages
as
select h.hotelid, h.HotelName, PackageId, PackageDescription, PackageStart , PackageEnd, Price
from Hotels as h
join Packages as p
on h.HotelId=p.HotelId
where price < 20000
with check option
go

select * from AffordableHotelPackages

------------------------------------------------------------------------------------------------------

create view ActiveUserComplaints
as
select u.UserId, u.Name, [Description]
from Complaints as c
join Users as u
on c.userid=u.userid
where [status] = 'Open'
with check option
go

select * from ActiveUserComplaints

------------------------------------------------------------------------------------------------------

create view SingleBedAccommodation
as
select h.hotelid, h.HotelName, RoomNo, RoomPrice , RoomStatus
from Hotels as h
join Rooms as r
on h.HotelId=r.HotelId
where NoOfBeds = 1
with check option
go

select * from SingleBedAccommodation

------------------------------------------------------------------------------------------------------

create view AverageUserProvidedHotelRatings
as
select h.hotelid, h.HotelName, avg(HotelRating) as UserProvidedRating
from Hotels as h
join Rating as r
on h.HotelId=r.HotelId
group by h.HotelId, h.HotelName
with check option
go

select * from AverageUserProvidedHotelRatings

------------------------------------------------------------------------------------------------------

create view FullyBookedHotels
as
select h.hotelid, h.HotelName
from Hotels as h
join Rooms as r
on h.HotelId=r.HotelId
group by h.HotelId, h.HotelName, r.RoomStatus
having RoomStatus = 'Not Available'
with check option
go

select * from FullyBookedHotels

Insert into admin_ values('Ab12',123,'Ziyad')


drop table cancelledBookings 

Insert into Rooms values('125','12',1,200,'Available')