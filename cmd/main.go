package main

import (
	"github.com/gorilla/sessions"
	"github.com/labstack/echo-contrib/session"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/martinellegard/smarter-home-go/handlers"
	"github.com/martinellegard/smarter-home-go/services"
)

const (
	SECRET_KEY string = "secret"
	DB_NAME    string = "app_data.db"
)

func main() {
	app := echo.New()

	app.Static("/", "assets")

	app.HTTPErrorHandler = handlers.CustomHTTPErrorHandler

	// Helpers Middleware
	// e.Use(middleware.Recover())
	app.Use(middleware.Logger())

	// Session Middleware
	app.Use(session.Middleware(sessions.NewCookieStore([]byte(SECRET_KEY))))

	// store, err := db.NewStore(DB_NAME)
	// if err != nil {
	// e.Logger.Fatalf("failed to create store: %s", err)
	// }

	userService := services.NewUserServices(services.User{} /*,  store*/)
	authHandler := handlers.NewAuthHandler(userService)

	// ts := services.NewTodoServices(services.Todo{}, store)
	// th := handlers.NewTaskHandler(ts)

	// Setting Routes
	handlers.SetupRoutes(app, authHandler)

	// Start Server
	app.Logger.Fatal(app.Start(":8082"))
}
