# README

This project uses the [Google Books API](https://developers.google.com/books) to query for books, and you can add them to your library.

### Specifications

- Ruby 2.7.3
- Rails 5.2.6
- RSPEC
- Faraday
- JWT (Token Based Authentication)
- Kaminari

## Instructions

All the functionality of the application is based on upon an authenticated user.

### Creating a User

```JSON
  POST REQUEST TO /users
  {
    "username": "example_username",
    "password": "my_passord"
  }
```

Make sure you hang on to the token. You'll need it for the Token Based Authentication.
From here on out, use the `Authorization` header `Bearer <<your_token_here>>`

If you misplace your token, you can always grab it again:

```JSON
  POST REQUEST TO /grab_token
  {
    "username": "example_username",
    "password": "my_password"
  }
```

---

### Querying Books

Search for a book using a GET REQUEST TO `/query` with a `search_term` parameter

Example

```sh
  localhost:3000/query?search_term=dune
```

You'll get 10 results from the [Google Books API](https://developers.google.com/books).
Keep an eye out for the `id` field in the response, you'll need that to accurately add a book to your library.

---

### Saving Books to your Library

Here is where your basic CRUD operations come in.

To find view the books currently in your library:

```JSON
  GET REQUEST TO /books
```

This takes a number of optional parameters

- Pagination => `?page=<<page #>>`
  - Will paginate the results of your library to 25 per page
- Filtering => `?filter=rated`
  - Will only return books that you've rated on a scale from 1 - 10
- Sorting => `?sort_by=rating`
  - Will change the default order of books to a descending list by book rating

To add a book to your library:

```JSON
  POST REQUEST TO /books
  {
    "google_id": "<<your book's ID returned from the API query>>",
    "my_rating": a number between 1 and 10, #optional
    "notes": "notes about your book" #optional
  }
```

The other fields, `title`, `author`, `description`, and `image_links` will be filled in for you.

To update your rating and/or notes on a book:

```JSON
  PUT REQUEST TO /books/:id
  {
    "my_rating": 5,
    "notes": "This note is different from the first one!"
  }
```

Finally, do delete a book from your library:

```JSON
  DELETE REQUEST TO /books/:id
```
