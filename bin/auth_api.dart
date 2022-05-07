import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import 'auth_repository.dart';

void main(List<String> arguments) async {
  final app = Router();
  final authRepository = AuthRepository();

  app.get('/me', (Request request) async {
    final key = request.headers['Authorization'];

    final user = authRepository.getUser(key!);

    if (user != null) {
      return Response.ok(
        user.toJson(),
        headers: {
          'Content-Type': 'application/json',
        },
      );
    }

    return Response.forbidden('');
  });

  app.post('/register', (Request request) async {
    final params = jsonDecode(await request.readAsString());

    final token = authRepository.register(
      params['name'],
      params['email'],
      params['password'],
    );

    if (token != null) {
      return Response.ok(token);
    } else {
      return Response.forbidden('');
    }
  });

  app.post('/login', (Request request) async {
    final params = jsonDecode(await request.readAsString());

    final token = authRepository.login(
      params['email'],
      params['password'],
    );

    if (token != null) {
      return Response.ok(token);
    }

    return Response.forbidden('Email and/or password incorrect');
  });

  final authMid = createMiddleware(requestHandler: (Request req) {
    if (req.url.toString() == 'me' && req.headers['Authorization'] == null) {
      return Response.forbidden('');
    }
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(authMid)
      .addHandler(app);
  final server = await io.serve(handler, 'localhost', 8080);

  print('Serving at http://${server.address.host}:${server.port}');
}
