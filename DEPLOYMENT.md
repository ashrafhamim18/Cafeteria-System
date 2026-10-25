# Deployment

This application is a Java Servlet/JSP application and runs in Tomcat. The included Dockerfile packages it for a container host such as Render, Railway, or Azure App Service.

## Render

1. Create a MySQL database on a managed provider such as Aiven, Railway, or Amazon RDS.
2. Import the database schema and record its host, port, database name, username, and password.
3. In Render, create a new **Blueprint** from this repository. Render will read `render.yaml`.
4. Set `DB_HOST`, `DB_USER`, and `DB_PASSWORD` in the Render service environment.
5. Deploy. The application listens on port `8080`.

The application now reads database settings from environment variables. Local development keeps the original defaults (`localhost`, database `cafeteria_system`, user `root`, password `root`).
