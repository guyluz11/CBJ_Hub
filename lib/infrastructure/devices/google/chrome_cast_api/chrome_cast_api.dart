import 'dart:convert';
import 'dart:math';

import 'package:dart_chromecast/casting/cast.dart';
import 'package:logging/logging.dart';
import 'package:universal_io/io.dart';

final Logger log = new Logger('Chromecast CLI');

void startCasting(
    List<CastMedia> media, String host, int? port, bool? append) async {
  log.fine('Start Casting');

  // try to load previous state saved as json in saved_cast_state.json
  Map? savedState;
  try {
    final File savedStateFile = File("./saved_cast_state.json");
    savedState = jsonDecode(await savedStateFile.readAsString()) as Map;
  } catch (e) {
    // does not exist yet
    log.warning('error fetching saved state' + e.toString());
  }

  // create the chromecast device with the passed in host and port
  final CastDevice device = CastDevice(
    host: host,
    port: port,
    type: '_googlecast._tcp',
  );

  // instantiate the chromecast sender class
  final CastSender castSender = CastSender(
    device,
  );

  // listen for cast session updates and save the state when
  // the device is connected
  castSender.castSessionController.stream
      .listen((CastSession? castSession) async {
    if (castSession!.isConnected) {
      final File savedStateFile = File('./saved_cast_state.json');
      final Map map = {
        'time': DateTime.now().millisecondsSinceEpoch,
      }..addAll(castSession.toMap());
      await savedStateFile.writeAsString(jsonEncode(map));
      log.fine('Cast session was saved to saved_cast_state.json.');
    }
  });

  CastMediaStatus? prevMediaStatus;
  // Listen for media status updates, such as pausing, playing, seeking, playback etc.
  castSender.castMediaStatusController.stream
      .listen((CastMediaStatus? mediaStatus) {
    // show progress for example
    if (mediaStatus == null) {
      return;
    }
    if (null != prevMediaStatus &&
        mediaStatus.volume != prevMediaStatus!.volume) {
      // volume just updated
      log.info('Volume just updated to ${mediaStatus.volume}');
    }
    if (null == prevMediaStatus ||
        mediaStatus.position != prevMediaStatus?.position) {
      // update the current progress
      log.info('Media Position is ${mediaStatus.position}');
    }
    prevMediaStatus = mediaStatus;
  });

  bool connected = false;
  bool didReconnect = false;

  if (null != savedState) {
    // If we have a saved state,
    // try to reconnect
    connected = await castSender.reconnect(
      sourceId: savedState['sourceId'] as String?,
      destinationId: savedState['destinationId'] as String?,
    );
    if (connected) {
      didReconnect = true;
    }
  }

  // if reconnection failed or we never had a saved state to begin with
  // connect to a fresh session.
  if (!connected) {
    connected = await castSender.connect();
  }

  if (!connected) {
    log.warning('COULD NOT CONNECT!');
    return;
  }
  log.info("Connected with device");

  if (!didReconnect) {
    // dont relaunch if we just reconnected, because that would reset the player state
    castSender.launch();
  }

  // load CastMedia playlist and send it to the chromecast
  castSender.loadPlaylist(media, append: append);

  // Initiate key press handler
  // space = toggle pause
  // s = stop playing
  // left arrow = seek current playback - 10s
  // right arrow = seek current playback + 10s
  // up arrow = volume up 5%
  // down arrow = volume down 5%
  // stdin.echoMode = false;
  // stdin.lineMode = false;

  // stdin.asBroadcastStream().listen((List<int> data) {
  //   _handleUserInput(castSender, data);
  // });
}

void _handleUserInput(CastSender castSender, List<int> data) {
  if (data.length == 0) return;

  final int keyCode = data.last;

  log.info("pressed key with key code: $keyCode");

  if (32 == keyCode) {
    // space = toggle pause
    castSender.togglePause();
  } else if (115 == keyCode) {
    // s == stop
    castSender.stop();
  } else if (27 == keyCode) {
    // escape = disconnect
    castSender.disconnect();
  } else if (65 == keyCode) {
    // up
    final double? volume = castSender.castSession?.castMediaStatus?.volume;
    if (volume != null) {
      castSender.setVolume(min(1, volume + 0.1));
    }
  } else if (66 == keyCode) {
    // down
    final double? volume = castSender.castSession?.castMediaStatus?.volume;
    if (volume != null) {
      castSender.setVolume(max(0, volume - 0.1));
    }
  } else if (67 == keyCode || 68 == keyCode) {
    // left or right = seek 10s back or forth
    final double seekBy = 67 == keyCode ? 10.0 : -10.0;
    if (null != castSender.castSession &&
        null != castSender.castSession!.castMediaStatus) {
      castSender.seek(
        max(0.0, castSender.castSession!.castMediaStatus!.position! + seekBy),
      );
    }
  }
}
