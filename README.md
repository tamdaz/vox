# vox

vox is an API for exchanging messages between users in conversations, built with the Athena Framework.

## Installation

Requires Crystal 1.22.2 and SQLite.

First, install dependencies:

```sh
shards install
```

## Usage

Create your local configuration:

```sh
cp .env.example .env
```

Set the host, port, and database URL in your `.env` file.

Run the database migrations:

```sh
shards run console -- orm:mig:mig
```

Start the server:

```sh
shards run server
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/tamdaz/vox/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [tamdaz](https://github.com/tamdaz) - creator and maintainer
