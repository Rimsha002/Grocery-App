# GrocerApp API Documentation

This document describes the GrocerApp REST API endpoints.

## Authentication

All API requests require authentication using JWT tokens. Include the token in the Authorization header:

```
Authorization: Bearer your_jwt_token
```

To obtain a token, make a POST request to `/api/v1/auth/login` with your credentials:

```bash
curl -X POST https://api.grocerapp.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'
```

## Products

### List Products

```
GET /api/v1/products
```

Query parameters:
- `page` (optional): Page number for pagination
- `per_page` (optional): Number of items per page (default: 24)
- `category` (optional): Filter by category ID
- `query` (optional): Search query
- `min_price` (optional): Minimum price filter
- `max_price` (optional): Maximum price filter
- `sort` (optional): Sort field (name, price, rating, created_at)
- `direction` (optional): Sort direction (asc, desc)

Response:
```json
{
  "products": [
    {
      "id": 1,
      "name": "Red Apple",
      "description": "Fresh red apples",
      "price": "2.99",
      "category": {
        "id": 1,
        "name": "Fruits"
      },
      "image_url": "https://example.com/images/apple.jpg",
      "rating": 4.5,
      "stock_status": "In Stock"
    }
  ],
  "meta": {
    "current_page": 1,
    "total_pages": 10,
    "total_count": 235
  }
}
```

### Get Product Details

```
GET /api/v1/products/:id
```

Response:
```json
{
  "id": 1,
  "name": "Red Apple",
  "description": "Fresh red apples",
  "price": "2.99",
  "compare_at_price": "3.99",
  "category": {
    "id": 1,
    "name": "Fruits"
  },
  "images": [
    {
      "id": 1,
      "url": "https://example.com/images/apple-1.jpg"
    }
  ],
  "rating": 4.5,
  "reviews_count": 25,
  "stock_quantity": 100,
  "unit": "kg",
  "brand": "Local Farm"
}
```

## Cart

### Get Cart

```
GET /api/v1/cart
```

Response:
```json
{
  "items": [
    {
      "id": 1,
      "product": {
        "id": 1,
        "name": "Red Apple",
        "price": "2.99",
        "image_url": "https://example.com/images/apple.jpg"
      },
      "quantity": 2,
      "total": "5.98"
    }
  ],
  "subtotal": "5.98",
  "delivery_fee": "5.00",
  "discount": "0.00",
  "total": "10.98"
}
```

### Add Item to Cart

```
POST /api/v1/cart/items
```

Request body:
```json
{
  "product_id": 1,
  "quantity": 2
}
```

### Update Cart Item

```
PATCH /api/v1/cart/items/:id
```

Request body:
```json
{
  "quantity": 3
}
```

### Remove Cart Item

```
DELETE /api/v1/cart/items/:id
```

## Orders

### List Orders

```
GET /api/v1/orders
```

Response:
```json
{
  "orders": [
    {
      "id": 1,
      "number": "ORD-2024-001",
      "status": "confirmed",
      "total": "45.98",
      "created_at": "2024-03-20T10:30:00Z",
      "items_count": 3
    }
  ]
}
```

### Get Order Details

```
GET /api/v1/orders/:id
```

Response:
```json
{
  "id": 1,
  "number": "ORD-2024-001",
  "status": "confirmed",
  "items": [
    {
      "product": {
        "id": 1,
        "name": "Red Apple",
        "image_url": "https://example.com/images/apple.jpg"
      },
      "quantity": 2,
      "unit_price": "2.99",
      "total": "5.98"
    }
  ],
  "subtotal": "45.98",
  "delivery_fee": "5.00",
  "discount": "0.00",
  "total": "50.98",
  "address": {
    "full_name": "John Doe",
    "street_address": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zip_code": "10001"
  },
  "created_at": "2024-03-20T10:30:00Z",
  "estimated_delivery_time": "2024-03-20T12:30:00Z"
}
```

### Create Order

```
POST /api/v1/orders
```

Request body:
```json
{
  "address_id": 1,
  "payment_method": "card",
  "discount_code": "WELCOME10"
}
```

## Error Responses

All error responses follow this format:

```json
{
  "error": {
    "code": "invalid_request",
    "message": "The request was invalid",
    "details": ["Product not found"]
  }
}
```

Common error codes:
- `unauthorized`: Authentication failed
- `invalid_request`: Invalid request parameters
- `not_found`: Resource not found
- `validation_error`: Validation failed
- `payment_error`: Payment processing failed 