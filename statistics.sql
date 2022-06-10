-- TOP 10 authors
SELECT a.first_name || ' ' || a.last_name AS full_name, COUNT(b2.id) AS borrows
FROM authors a
         INNER JOIN books_authors ba ON a.id = ba.author_id
         INNER JOIN books b ON ba.book_id = b.id
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY full_name
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 genres
SELECT g.value AS genre, COUNT(b2.id) AS borrows
FROM genres g
         INNER JOIN books b ON g.id = b.genre_id
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY genre
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 languages
SELECT l.value AS language, COUNT(b2.id) AS borrows
FROM languages l
         INNER JOIN books b ON l.id = b.language_id
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY language
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 publishers
SELECT p.name AS publisher, COUNT(b2.id) AS borrows
FROM publishers p
         INNER JOIN books b ON p.id = b.publisher_id
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY publisher
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 tags
SELECT t.value AS tag, COUNT(b2.id) AS borrows
FROM tags t
         INNER JOIN books_tags bt ON t.id = bt.tag_id
         INNER JOIN books b ON bt.book_id = b.id
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY tag
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 users
SELECT u.first_name || ' ' || u.last_name AS full_name, COUNT(b.id) AS borrows
FROM users u
         INNER JOIN borrows b ON u.id = b.user_id
GROUP BY full_name
ORDER BY borrows DESC
LIMIT 10;

-- TOP 10 books (rating)
SELECT b.title AS book, ROUND(AVG(r.value), 2) AS rating
FROM ratings r
         INNER JOIN books b ON r.book_id = b.id
GROUP BY book
ORDER BY rating DESC
LIMIT 10;

-- TOP 10 books (borrows)
SELECT b.title AS book, COUNT(b2.id) AS borrows
FROM books b
         INNER JOIN copies c ON b.id = c.book_id
         INNER JOIN borrows b2 ON c.id = b2.copy_id
GROUP BY book
ORDER BY borrows DESC
LIMIT 10;
