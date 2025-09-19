```dart
String fixImageUrl(String url) {
    return url.replaceFirst("https://localhost", "http://192.168.1.98");
  }
```

### ✅ Example using `flutter_dotenv`

In your **`.env`** file:

```env
LOCAL_URL=http://192.168.1.98
PROD_URL=https://yourdomain.com
```

---

### Update your Dart code:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String fixImageUrl(String url) {
  final localUrl = dotenv.env['LOCAL_URL'] ?? "http://192.168.1.98";
  final prodUrl = dotenv.env['PROD_URL'] ?? "https://localhost";

  return url.replaceFirst(prodUrl, localUrl);
}
```


Perfect 👌 Let’s make it **environment-aware** with `APP_ENV`.

---

### 🔹 Step 1 – Add variables in `.env`

```env
APP_ENV=development

# Local dev
LOCAL_URL=http://192.168.1.98
LOCAL_HOST=https://localhost

# Production
PROD_URL=https://yourdomain.com
```

---

### 🔹 Step 2 – Update your Dart code

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

String fixImageUrl(String url) {
  final env = dotenv.env['APP_ENV'] ?? "production";

  if (env == "development") {
    final localUrl = dotenv.env['LOCAL_URL'] ?? "http://192.168.1.98";
    final localHost = dotenv.env['LOCAL_HOST'] ?? "https://localhost";
    return url.replaceFirst(localHost, localUrl);
  } else {
    final prodUrl = dotenv.env['PROD_URL'] ?? "";
    if (prodUrl.isNotEmpty && url.startsWith("https://localhost")) {
      return url.replaceFirst("https://localhost", prodUrl);
    }
    return url;
  }
}
```

---

### 🔹 Example Usage

```dart
final url1 = fixImageUrl("https://localhost/wp-content/uploads/2025/09/image.jpg");
print(url1);
// If APP_ENV=development → http://192.168.1.98/wp-content/uploads/2025/09/image.jpg
// If APP_ENV=production  → https://yourdomain.com/wp-content/uploads/2025/09/image.jpg
```

---

✅ This way:

* **In dev**: replaces `https://localhost` with your LAN IP.
* **In prod**: replaces with your real domain.
* No more hardcoding inside code.

---

👉 Do you want me to also adjust your `WooCommerceService` to **pick base URL based on `APP_ENV`** in the same way?
