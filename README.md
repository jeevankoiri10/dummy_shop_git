# Dummy Shop

Flutter app for [dummyjson.com](https://dummyjson.com): log in, browse a paginated product list, open a product's details.

https://dummyjson.com/docs
https://dummyjson.com/openapi.json
https://dummyjson.com/products
https://dummyjson.com/users

Test account: **emilys / emilyspass**

## Run

Requires Flutter 3.35+.

```bash
flutter create . --project-name dummy_shop --platforms=android,ios,web
flutter pub get
flutter run
```

Run the tests with `flutter test`.

## Decisions

- **Structure:** feature-first (`auth`, `products`, `users`), each split into `data` and `presentation`. There's no domain layer because features this small don't need one. I'd add it once business logic outgrows the repositories.
- **State:** Bloc, with Cubits for the simple flows (login, session) and a full Bloc for the product list, which has three competing triggers (load, refresh, next page). Scroll events are ignored while a page is loading, and late responses are dropped after a refresh.
- **Product list:** covers loading, error and empty states, pull-to-refresh and pagination. A failed refresh keeps the current list and shows a message, and a failed next page can be retried from the bottom of the list.
- **API client:** generated from the [OpenAPI spec](https://dummyjson.com/openapi.json) with `swagger_parser` and Retrofit, then committed so the app builds without a generation step. `openapi/dummyjson.json` keeps only the endpoints the app calls, because the full spec's inline `Comment.user` overwrites the generated `User` model. Repositories map generated models to the app's own, so spec changes stop at the repository layer. After a spec change, run `dart run tool/update_openapi.dart`, `dart run swagger_parser` and `dart run build_runner build --delete-conflicting-outputs`, then let `flutter analyze` show what broke.
- **Errors:** repositories turn every Dio error into one `ApiException`, so the UI never imports Dio.
- **Auth:** tokens are kept in `flutter_secure_storage`, which is weaker on web than on mobile. An interceptor adds the token to each request. On a `401`, it renews the token once with `/auth/refresh` and retries, and requests that fail together share that refresh. If the refresh is rejected, the tokens are cleared and `SessionCubit` returns the user to login. A network error during a refresh doesn't log the user out.
- **Beyond the brief:** a profile page reads `/users/{id}` and requests only the fields it shows, which leaves out the password the API would otherwise return. Avatars fall back to `/icon`, and products with no image use `/image`.
- **DI:** wired by hand in `main.dart`, which is enough at this size.
- **Tests:** cover the Bloc and Cubits, product parsing, the refresh flow in the interceptor, and the login and profile screens.
