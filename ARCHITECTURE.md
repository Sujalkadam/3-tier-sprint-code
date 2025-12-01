# 3-Tier Architecture Documentation

## Overview

This application has been refactored from a **2-tier** to a **3-tier architecture** for better separation of concerns, maintainability, and testability.

## Architecture Layers

### 1. Presentation Layer (Tier 1)
**Location:** `app/blueprints/`

- **Purpose:** Handles HTTP requests/responses and user interface rendering
- **Components:**
  - Route handlers (`routes.py` files)
  - Flask templates (Jinja2) in `app/templates/`
  - Forms (WTForms) in `forms.py` files
- **Responsibilities:**
  - Receive HTTP requests
  - Validate form input
  - Call service layer for business logic
  - Render templates with data
  - Return HTTP responses

**Example:**
```python
@admin_bp.route("/inventory/new", methods=["GET", "POST"])
def inventory_create():
    form = InventoryForm()
    if form.validate_on_submit():
        InventoryService.create_item(...)  # Calls service layer
        return redirect(...)
    return render_template(...)
```

### 2. Business Logic Layer (Tier 2)
**Location:** `app/services/`

- **Purpose:** Contains business rules, validation, and orchestration
- **Components:**
  - `AdminService` - Admin user operations
  - `StaffService` - Staff user operations
  - `InventoryService` - Inventory management logic
  - `AssignmentService` - Item assignment logic
  - `RequestService` - Request processing logic
  - `FeedbackService` - Feedback handling logic
- **Responsibilities:**
  - Implement business rules
  - Validate business constraints
  - Coordinate between repositories
  - Handle business-level errors
  - Ensure data consistency

**Example:**
```python
class InventoryService:
    @staticmethod
    def create_item(name, category, quantity, ...):
        if quantity < 0:
            raise ValueError("Quantity cannot be negative")
        return InventoryRepository.create(...)
```

### 3. Data Access Layer (Tier 3)
**Location:** `app/repositories/`

- **Purpose:** Handles all database operations
- **Components:**
  - `AdminRepository` - Admin user data access
  - `StaffRepository` - Staff user data access
  - `InventoryRepository` - Inventory data access
  - `AssignmentRepository` - Assignment data access
  - `RequestRepository` - Request data access
  - `FeedbackRepository` - Feedback data access
- **Responsibilities:**
  - Execute database queries
  - Manage database transactions
  - Map database results to models
  - Handle database-specific operations

**Example:**
```python
class InventoryRepository:
    @staticmethod
    def find_by_id(item_id):
        return InventoryItem.query.get(item_id)
    
    @staticmethod
    def create(name, category, quantity, ...):
        item = InventoryItem(...)
        db.session.add(item)
        db.session.commit()
        return item
```

## Technology Stack

### Frontend
- **Template Engine:** Jinja2 (server-side rendering)
- **CSS Framework:** Bootstrap 5.3.3
- **JavaScript:** Vanilla JS with Bootstrap components
- **Forms:** WTForms for form validation

### Backend
- **Framework:** Flask 3.0.3
- **ORM:** SQLAlchemy 2.0.34
- **Database:** MySQL (via PyMySQL)
- **Authentication:** Flask-Login
- **Migrations:** Flask-Migrate (Alembic)

### Database
- **Type:** MySQL
- **ORM:** SQLAlchemy
- **Connection:** PyMySQL driver

## Data Flow

```
HTTP Request
    ↓
Route Handler (Presentation Layer)
    ↓
Service Layer (Business Logic)
    ↓
Repository Layer (Data Access)
    ↓
Database (MySQL)
    ↓
Repository returns Model
    ↓
Service returns result
    ↓
Route Handler renders template
    ↓
HTTP Response
```

## Benefits of 3-Tier Architecture

1. **Separation of Concerns:** Each layer has a single, well-defined responsibility
2. **Maintainability:** Changes in one layer don't affect others
3. **Testability:** Each layer can be tested independently
4. **Reusability:** Business logic can be reused across different interfaces (web, API, CLI)
5. **Scalability:** Layers can be scaled independently
6. **Flexibility:** Easy to swap implementations (e.g., different database)

## File Structure

```
app/
├── blueprints/          # Presentation Layer
│   ├── admin/
│   ├── staff/
│   └── public/
├── services/            # Business Logic Layer
│   ├── admin_service.py
│   ├── staff_service.py
│   ├── inventory_service.py
│   ├── assignment_service.py
│   ├── request_service.py
│   └── feedback_service.py
├── repositories/        # Data Access Layer
│   ├── admin_repository.py
│   ├── staff_repository.py
│   ├── inventory_repository.py
│   ├── assignment_repository.py
│   ├── request_repository.py
│   └── feedback_repository.py
├── models.py            # SQLAlchemy models
├── templates/           # Jinja2 templates
└── static/              # CSS, JS, images
```

## Migration Notes

The application was migrated from 2-tier to 3-tier by:
1. Extracting database queries into repository classes
2. Moving business logic from route handlers to service classes
3. Refactoring route handlers to use services instead of direct database access
4. Maintaining backward compatibility with existing templates and forms

