# GrocerApp

A modern grocery delivery web application built with Ruby on Rails and Tailwind CSS.

## Features

- User authentication with Devise
- Product catalog with categories and search
- Shopping cart functionality
- Wishlist management
- Order processing and tracking
- Admin interface with ActiveAdmin
- Real-time search with Stimulus.js
- Responsive design with Tailwind CSS
- Email notifications
- Performance optimization with caching

## Prerequisites

- Ruby 3.1.7
- PostgreSQL
- Redis (for caching and background jobs)
- Node.js and Yarn
- ImageMagick (for image processing)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/grocerapp.git
   cd grocerapp
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Set up environment variables:
   Create a `.env` file in the root directory and add the following:
   ```
   DATABASE_URL=postgres://username:password@localhost/grocerapp_development
   REDIS_URL=redis://localhost:6379/1
   RAILS_MASTER_KEY=your_master_key
   ```

5. Start the servers:
   ```bash
   ./bin/dev
   ```

The application will be available at http://localhost:3000

## Running Tests

```bash
bundle exec rspec
```

## Background Jobs

The application uses Sidekiq for processing background jobs. To start Sidekiq:

```bash
bundle exec sidekiq
```

## Caching

The application uses Redis for caching. Make sure Redis is running:

```bash
redis-server
```

## Deployment

The application is configured for deployment on any platform that supports Ruby on Rails. A Dockerfile is included for containerized deployment.

1. Build the Docker image:
   ```bash
   docker build -t grocerapp .
   ```

2. Run the container:
   ```bash
   docker run -p 3000:3000 -e RAILS_MASTER_KEY=your_master_key grocerapp
   ```

## API Documentation

The application provides a JSON API for products and orders. See the [API documentation](docs/api.md) for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Ruby on Rails](https://rubyonrails.org/)
- [Tailwind CSS](https://tailwindcss.com/)
- [Stimulus.js](https://stimulus.hotwired.dev/)
- [ActiveAdmin](https://activeadmin.info/)
- [Devise](https://github.com/heartcombo/devise)
- [PostgreSQL](https://www.postgresql.org/)
- [Redis](https://redis.io/)
