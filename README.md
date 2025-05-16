# GrocerApp

A modern e-commerce application for grocery shopping built with Ruby on Rails 7.2.2.1, PostgreSQL, and Tailwind CSS.

## Features

- User authentication with Devise
- Product catalog with categories
- Shopping cart functionality
- Search and filtering
- Responsive design with Tailwind CSS
- Admin interface for product management

## Requirements

- Ruby 3.1.7
- PostgreSQL
- Node.js
- Yarn

## Setup

1. Clone the repository:
```bash
git clone https://github.com/yourusername/groceryapp.git
cd groceryapp
```

2. Install dependencies:
```bash
bundle install
yarn install
```

3. Setup database:
```bash
cp config/database.yml.example config/database.yml
rails db:create db:migrate db:seed
```

4. Start the server:
```bash
bin/dev
```

The application will be available at http://localhost:3000

## Testing

To run the test suite:
```bash
bundle exec rspec
```

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
