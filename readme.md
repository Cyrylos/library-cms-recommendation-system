# LibraryCMS

Recommendation system for [Library CMS](https://github.com/dosadczuk/library-cms-backend)

## Requirements

* Pandas
* surprise
* sqlalchemy
* psycopg2

---

## About

This is proof of concept for recommendation system for Library CMS. \
The engine is based on SVD algorithm. Recommendations are based on books borrows and book ratings of users. \
Borrows without rating as a rating value have mean of all raitngs. Beceause of this they are taken into a count during predictions.

TOP 10 queries were added to create rankings.