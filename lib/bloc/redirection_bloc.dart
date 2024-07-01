import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import "package:http/http.dart" as http;
import "dart:convert";

part "redirection_event.dart";
part "redirection_state.dart";


class RedirectionBloc extends Bloc<RedirectionEvent, RedirectionState>
{
    final _client = http.Client();

    RedirectionBloc() : super(const RedirectionState())
    {
      on<InitRedirection>(_onInit);
      on<RedirectionChange>(_onRedirectionChange);
    }

    Future<void> _onInit(InitRedirection event, Emitter<RedirectionState> emit) async
    {
      emit(state.copy(isLoading: true));

      final uri = Uri.https(
          "api.cloudflare.com",
          "/client/v4/zones/5c62aae18adf6c9c738c4ca13dd7f851/rulesets/a7c9f07459f244b5b292b7c866cdced5"
      );
      final response = await _client.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${const String.fromEnvironment("CLOUDFLARE_API_KEY")}"
          // "Referer": ""
        }
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copy(
            redirection: data["result"]["rules"].first["action_parameters"]["from_value"]["target_url"]["value"],
            isInit: true,
            isLoading: false
        ));
      } else {
        print("ERROR: ${data["errors"]}");
      }
    }

    Future<void> _onRedirectionChange(RedirectionChange event, Emitter<RedirectionState> emit) async
    {
      emit(state.copy(isLoading: true));

      final uri = Uri.https(
          "api.cloudflare.com",
          "/client/v4/zones/5c62aae18adf6c9c738c4ca13dd7f851/rulesets/a7c9f07459f244b5b292b7c866cdced5",
      );

      final response = await _client.put(
          uri,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${const String.fromEnvironment("CLOUDFLARE_API_KEY")}",
            // "Referer": ""
          },
        body: jsonEncode({
          "name": "default",
          "description": "",
          "phase": "http_request_dynamic_redirect",
          "kind": "zone",
          "rules": [
            {
              "id": "2212694a2027453d9ab13fc2dffcdf6f",
              "action": "redirect",
              "expression": "(http.host eq \"qr.stollpy.com\")",
              "description": "QR",
              "enabled": true,
              "action_parameters": {
                "from_value": {
                  "status_code": 302,
                  "target_url": {
                    "value": event.redirection
                  },
                  "preserve_query_string": true
                }
              }
            }
          ]
        })
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(state.copy(
            redirection: data["result"]["rules"].first["action_parameters"]["from_value"]["target_url"]["value"],
            isSuccess: true,
            isLoading: false,
        ));
        emit(state.copy(isSuccess: false));
      } else {
        print("ERROR: ${data["errors"]}");
      }
    }
}