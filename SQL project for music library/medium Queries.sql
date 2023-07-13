use custom

-- write a query to return email ,first name , last name and genre of all rock music listeners. Return your list ordered alphatecially
-- by email starting with A

select * from customer
select * from genre
select * from invoice
select * from invoice_line
select * from track1
select * from artist
select * from album

select distinct email,first_name ,last_name from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in(
select track_id from track1
join genre on track1.genre_id = genre.genre_id
where genre.name like 'Rock'
)
order by email;

--method2
select distinct email as Email , first_name as FirstName , last_name as LastName , genre.name as Name
from customer
join invoice on invoice.customer_id = customer.customer_id
join invoice_line on invoice_line.invoice_id = invoice.invoice_id
join track1 on track1.track_id = invoice_line.track_id
join genre on genre.genre_id = track1.genre_id
where genre.name like 'Rock'
order by email;



-- lets invite te artist who have  written the most rock music in our dataset.Write a query that returns the artist name and total track count of the
-- top 10 rock bands

select top 10 artist.artist_id,artist.name ,COUNT(artist.artist_id) as number_of_songs
from track1
join album on album.album_id = track1.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track1.genre_id
where genre.name like 'Rock'
Group by artist.artist_id ,artist.name
order by number_of_songs desc ;

-- return all track names that have a song length longer than the average song length.Return the name and miliseconds for each track
--order by the song length with the longest songs listed first

select name , milliseconds from track1
where milliseconds > ( select AVG(milliseconds) as avg_track_length
from track1)
order by milliseconds